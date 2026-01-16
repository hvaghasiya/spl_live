import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/api_services/api_service.dart';

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

class _PaymentScreenState extends State<PaymentScreen>
    with WidgetsBindingObserver {

  late final WebViewController _controller;
  Timer? _statusTimer;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initWebView();
    // _startPolling();
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
      _checkPaymentStatus();
    }
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


  String buildPaytmCashWalletUrl({
    required String upi,
    required String amount,
    required String name,
    required String txnId,
  }) {
    return 'paytmmp://cash_wallet'
        '?pa=$upi'
        '&am=$amount'
        '&pn=${Uri.encodeComponent(name)}'
        '&tn=$txnId'
        '&tr=$txnId'
        '&featuretype=money_transfer';
  }

  Future<void> payWithPaytm() async {
    final url = buildPaytmCashWalletUrl(
      upi: 'Q406781001@ybl',
      amount: '1',
      name: 'SKYLINE TRADERS',
      txnId: widget.upiIntent['paymentId'].toString(),
    );

    try {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalNonBrowserApplication,
      );


      _startPolling();

    } catch (_) {
      _showSnack("Paytm app not installed");
    }
  }


  Future<void> payWithGPay() async {
    final link = widget.upiIntent['gpay_link'];
    if (link == null) return;

    try {
      await launchUrl(
        Uri.parse(link),
        mode: LaunchMode.externalNonBrowserApplication,
      );
      _startPolling();
    } catch (_) {
      _showSnack("Google Pay not installed");
    }
  }


  void shareQr() {
    Share.share(widget.paymentUrl, subject: "Pay via UPI");
  }


  void _hideWebShareButton() {
    _controller.runJavaScript('''
      document.querySelectorAll('button').forEach(btn => {
        if (btn.innerText && btn.innerText.toLowerCase().includes('share')) {
          btn.style.display = 'none';
        }
      });
    ''');
  }


  void _startPolling() {
    _statusTimer = Timer.periodic(
      const Duration(seconds: 5),
          (_) => _checkPaymentStatus(),
    );
  }

  Future<void> _checkPaymentStatus() async {
    try {
      final res = await ApiService()
          .checkPaymentStatus(paymentId: widget.upiIntent['paymentId']);

      if (res == null || res['data'] == null) return;

      final data = res['data'];

      final status =
          data['payment_status'] ??
              data['paymentStatus'] ??
              data['status'];

      if (status == null) return;

      if (status.toString().toUpperCase() == 'SUCCESS') {
        _statusTimer?.cancel();
        _showSnack("Payment Successful 🎉");
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) Navigator.pop(context, true);
      }

      if (status.toString().toUpperCase() == 'FAILED') {
        _statusTimer?.cancel();
        _showSnack("Payment Failed ❌");
      }
    } catch (e) {
      debugPrint("Payment status error: $e");
    }
  }


  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Complete Payment",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.appbarColor,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (isLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: payWithPaytm,
                child: Image.asset('assets/images/paytm.png', height: 45),
              ),
              const SizedBox(width: 30),
              GestureDetector(
                onTap: payWithGPay,
                child: Image.asset('assets/images/GooglePay.png', height: 45),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: shareQr,
              icon: const Icon(Icons.share),
              label: const Text("Share QR"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
