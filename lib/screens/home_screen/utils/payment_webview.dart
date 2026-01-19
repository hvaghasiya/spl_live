import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../../../api_services/api_service.dart';
import '../../../api_services/api_urls.dart';
import '../../../helper_files/app_colors.dart';


class PaymentScreen extends StatefulWidget {
  final String paymentUrl;
  final Map<String, dynamic> upiIntent;

  const PaymentScreen({
    super.key,
    required this.paymentUrl,
    required this.upiIntent,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with WidgetsBindingObserver {
  late final WebViewController _controller;
  Timer? _statusTimer;
  bool isLoading = true;
  final GlobalKey _qrKey = GlobalKey();

  List<Map<String, dynamic>> _availableApps = [];
  bool _isPaymentAppOpened = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initWebView();
    _startPolling();
    _checkInstalledApps();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _statusTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_isPaymentAppOpened) {
        _isPaymentAppOpened = false;

        _checkPaymentStatus(force: true);

        Future.delayed(const Duration(seconds: 2), () {
          _redirectToResultPage();
        });
      }
    }
  }


  void _redirectToResultPage() {
    try {
      final String clientTxnId =
          widget.upiIntent['clientRefId'] ?? "";
      final String txnId =
          widget.upiIntent['order_id']?.toString() ?? "";

      final String redirectUrl =
          "${ApiUtils.baseURL}/payment/upi-redirect"
          "?client_txn_id=$clientTxnId"
          "&txn_id=$txnId"
          "&ts=${DateTime.now().millisecondsSinceEpoch}";

      debugPrint("REDIRECT => $redirectUrl");

      _controller.loadRequest(Uri.parse(redirectUrl));

      if (mounted) {
        setState(() => isLoading = true);
      }
    } catch (e) {
      debugPrint("Redirect error: $e");
    }
  }


  Future<void> _checkInstalledApps() async {
    List<Map<String, dynamic>> tempApps = [];
    if (await canLaunchUrl(Uri.parse("paytmmp://"))) {
      tempApps.add({'name': 'Paytm', 'icon': 'assets/images/paytm.png', 'type': 'app', 'scheme': 'paytmmp'});
    }
    if (await canLaunchUrl(Uri.parse("tez://"))) {
      tempApps.add({'name': 'GPay', 'icon': 'assets/images/GooglePay.png', 'type': 'app', 'scheme': 'tez'});
    }
    if (await canLaunchUrl(Uri.parse("phonepe://"))) {
      tempApps.add({'name': 'PhonePe', 'icon': Icons.account_balance_wallet, 'isIconData': true, 'color': Colors.purple, 'type': 'app', 'scheme': 'phonepe'});
    }
    tempApps.add({'name': 'Share QR', 'icon': Icons.share, 'isIconData': true, 'color': Colors.blue, 'type': 'share'});

    if (mounted) setState(() => _availableApps = tempApps);
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => isLoading = false);
            _hideWebShareButton();
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _handleAppTap(Map<String, dynamic> appData) {
    if (appData['type'] == 'share') {
      _captureAndShareImage();
    } else {
      _isPaymentAppOpened = true;

      String scheme = appData['scheme'];
      String? link;
      if (scheme == 'paytmmp') {
        link = widget.upiIntent['bhim_link'] ?? widget.upiIntent['paytm_link'];
        if (link != null) link = _generatePaytmLink(link);
      } else if (scheme == 'tez') {
        link = widget.upiIntent['gpay_link'];
      } else if (scheme == 'phonepe') {
        link = widget.upiIntent['phonepe_link'];
      }
      _launchPaymentApp(link, appData['name']);
    }
  }

  Future<void> _launchPaymentApp(String? url, String appName) async {
    Navigator.pop(context);
    if (url == null || url.isEmpty) return;
    Uri uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
    } catch (e) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _generatePaytmLink(String sourceLink) {
    try {
      final uri = Uri.parse(sourceLink);
      final p = uri.queryParameters;
      return "paytmmp://cash_wallet?pa=${p['pa']}&am=${p['am']}&pn=${p['pn']}&tn=${p['tn']}&tr=${p['tr']}&featuretype=money_transfer";
    } catch (e) { return sourceLink; }
  }

  Future<void> _captureAndShareImage() async {
    Navigator.pop(context);
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      RenderRepaintBoundary? boundary = _qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        final Uint8List pngBytes = byteData.buffer.asUint8List();
        final directory = await getTemporaryDirectory();
        final String filePath = '${directory.path}/payment_qr.png';
        final File imgFile = File(filePath);
        await imgFile.writeAsBytes(pngBytes);
        if (mounted) await Share.shareXFiles([XFile(filePath)], text: '');
      }
    } catch (e) {}
  }

  void _startPolling() {
    _statusTimer?.cancel();
    _statusTimer = Timer.periodic(const Duration(seconds: 5), (_) => _checkPaymentStatus());
  }

  Future<void> _checkPaymentStatus({bool force = false}) async {
    try {
      final res = await ApiService().checkPaymentStatus(
        paymentId: widget.upiIntent['paymentId'],
      );

      if (res == null || res['data'] == null) return;

      String status =
      (res['data']['payment_status'] ?? res['data']['status'])
          .toString()
          .toUpperCase();

      debugPrint("PAYMENT STATUS => $status");

      if (status == 'SUCCESS') {
        _statusTimer?.cancel();

        if (!mounted) return;

        _showSnack("Payment Successful 🎉");

        await Future.delayed(const Duration(seconds: 1));
        if (mounted) Navigator.pop(context, true);
      }

      else if (status == 'FAILED') {
        _statusTimer?.cancel();

        if (!mounted) return;

        _showSnack("Payment Failed ❌");
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pop(context, false);
      }

      else if (status == 'PENDING' && force) {

        _redirectToResultPage();
      }
    } catch (e) {
      debugPrint("Status error: $e");
    }
  }


  void _hideWebShareButton() {
    _controller.runJavaScript("document.querySelectorAll('button').forEach(b => { if(b.innerText.toLowerCase().includes('share')) b.style.display='none'; });");
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _showDynamicSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Pay or Share via", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _availableApps.isEmpty
                  ? const Center(child: Text("Loading..."))
                  : GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 15, crossAxisSpacing: 10),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _availableApps.length,
                itemBuilder: (context, index) => _buildAppItem(_availableApps[index]),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppItem(Map<String, dynamic> app) {
    return InkWell(
      onTap: () => _handleAppTap(app),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 55, width: 55, padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade300), boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 4, spreadRadius: 1)]),
            child: (app['isIconData'] == true) ? Icon(app['icon'], color: app['color'], size: 28) : Image.asset(app['icon'], fit: BoxFit.contain),
          ),
          const SizedBox(height: 8),
          Text(app['name'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complete Payment"), centerTitle: true, backgroundColor: AppColors.appbarColor, foregroundColor: Colors.white),
      body: Column(
        children: [
          Expanded(
            child: RepaintBoundary(
              key: _qrKey,
              child: Stack(
                children: [
                  Container(color: Colors.white, child: WebViewWidget(controller: _controller)),
                  if (isLoading) const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: SizedBox(
              height: 55,
              child: ElevatedButton.icon(
                onPressed: _showDynamicSheet,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                icon: const Icon(Icons.share, size: 24),
                label: const Text("Share / Pay via UPI", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}