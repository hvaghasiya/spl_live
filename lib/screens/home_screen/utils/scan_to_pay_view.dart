import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gal/gal.dart';

import '../../../api_services/api_service.dart';
import '../../../helper_files/app_colors.dart';
import '../../../helper_files/constant_image.dart';
import '../../../helper_files/custom_text_style.dart';
import '../../../helper_files/ui_utils.dart';

class ScanToPayScreen extends StatefulWidget {
  final String payeeName;
  final String amount;
  final Map<String, dynamic>? paymentData;

  ScanToPayScreen({
    super.key,
    this.payeeName = "ADMIN",
    this.amount = "10.00",
    this.paymentData,
  });

  @override
  State<ScanToPayScreen> createState() => _ScanToPayScreenState();
}

class _ScanToPayScreenState extends State<ScanToPayScreen> with WidgetsBindingObserver {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSub;

  bool _isPaymentAppOpened = false;
  bool _isLoading = false;
  final GlobalKey _qrKey = GlobalKey();

  Timer? _timer;
  final ValueNotifier<int> _remainingSecondsNotifier = ValueNotifier<int>(179);


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _listenDeepLinks();
    _startTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _linkSub?.cancel();
    _timer?.cancel();
    _remainingSecondsNotifier.dispose();
    super.dispose();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_remainingSecondsNotifier.value == 0) {
          timer.cancel();
          if (mounted) {
            Navigator.pop(context);
          }
        } else {
          _remainingSecondsNotifier.value--;
        }
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_isPaymentAppOpened) {
        debugPrint("🔄 App Resumed. Checking Status...");
        _isPaymentAppOpened = false;
        Future.delayed(const Duration(seconds: 2), () {
          _checkPaymentStatus();
        });
      }
    }
  }

  void _listenDeepLinks() {
    _appLinks = AppLinks();
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) _handleDeepLink(uri);
    });
    _linkSub = _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });
  }

  void _handleDeepLink(Uri uri) {
    if (uri.toString().contains("upi-redirect")) {
      String? clientTxnId = uri.queryParameters['clientTxnId'];
      String? orderId = uri.queryParameters['orderId'];

      if (clientTxnId != null && orderId != null) {
        _checkPaymentStatus(forceIds: {'clientTxnId': clientTxnId, 'orderId': orderId});
      }
    }
  }

  Future<void> _checkPaymentStatus({Map<String, String>? forceIds}) async {
    if (_isLoading) return;
    if(mounted) {
      setState(() => _isLoading = true);
      AppUtils.showProgressDialog(isCancellable: false);
    }

    try {
      String orderId = "";
      String clientTxnId = "";

      if (forceIds != null) {
        orderId = forceIds['orderId'] ?? "";
        clientTxnId = forceIds['clientTxnId'] ?? "";
      } else {
        orderId = widget.paymentData?['order_id']?.toString() ?? widget.paymentData?['paymentId']?.toString() ?? "";
        final Map<String, dynamic> upiIntent = widget.paymentData?['upi_intent'] ?? {};
        clientTxnId = upiIntent['clientTxnId']?.toString() ?? "";
      }

      if (orderId.isEmpty) {
        _handleError("Order ID missing");
        return;
      }

      final res = await ApiService().checkOrderStatus(
        clientTxnId: clientTxnId,
        orderId: orderId,
      );

      AppUtils.hideProgressDialog();

      if (res != null && res['status'] == true) {
        final String status = res['data']['status'].toString().toLowerCase();
        if (status == 'success') {
          _showSuccessPopup();
        } else if (status == 'failed') {
          AppUtils.showErrorSnackBar(bodyText: "Payment Failed ❌");
        } else {
          _showPendingPopup(status);
        }
      } else {
        AppUtils.showErrorSnackBar(bodyText: "Could not verify status.");
      }

    } catch (e) {
      AppUtils.hideProgressDialog();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleError(String msg) {
    AppUtils.hideProgressDialog();
    if(mounted) setState(() => _isLoading = false);
    AppUtils.showErrorSnackBar(bodyText: msg);
  }

  void _showPendingPopup(String status) {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.info_outline, color: Colors.orange, size: 60.sp),
              SizedBox(height: 15.h),
              Text(
                "Payment Status: $status",
                style: CustomTextStyle.textRobotoMedium.copyWith(fontSize: 18.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.appbarColor),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        );
      },
    );
  }

  void _showSuccessPopup() {
    if (!mounted) return;
    if (ModalRoute.of(context)?.isCurrent != true) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 60.sp),
                SizedBox(height: 15.h),
                Text("Payment Successful!", style: CustomTextStyle.textRobotoMedium.copyWith(fontSize: 18.sp)),
                SizedBox(height: 20.h),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.appbarColor),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context, true);
                  },
                  child: const Text("OK", style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showQrSavedPopup() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 60.sp),
              SizedBox(height: 15.h),
              Text(
                "QR Saved to Gallery!",
                style: CustomTextStyle.textRobotoMedium.copyWith(fontSize: 18.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.appbarColor),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _launchUPI(String? url, {bool isPaytm = false, bool isPhonePe = false}) async {


    if (isPhonePe) {
      final Uri phonePeUri = Uri.parse("phonepe://pay");

      final bool installed = await canLaunchUrl(phonePeUri);
      if (!installed) {
        AppUtils.showErrorSnackBar(bodyText: "PhonePe app not installed");
        return;
      }

      _isPaymentAppOpened = true;
      await launchUrl(
        phonePeUri,
        mode: LaunchMode.externalNonBrowserApplication,
      );
      return;
    }

    if (url != null && url.isNotEmpty) {
      _isPaymentAppOpened = true;
      try {
        String finalUrl = url;

        if (isPaytm) {
          try {
            final uri = Uri.parse(url);
            final p = uri.queryParameters;
            finalUrl = "paytmmp://cash_wallet?pa=${p['pa']}&am=${p['am']}&pn=${p['pn']}&tn=${p['tn']}&tr=${p['tr']}&featuretype=money_transfer";
          } catch (e) { finalUrl = url; }
        }

        Uri uri = Uri.parse(finalUrl);
        try {
          await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
        } catch (e) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      } catch (e) {
        _isPaymentAppOpened = false;
        AppUtils.showErrorSnackBar(bodyText: "Could not launch app");
      }
    } else {
      AppUtils.showErrorSnackBar(bodyText: "Link not available");
    }
  }

  Future<void> _shareQrImage() async {
    _isPaymentAppOpened = true;
    try {
      Uint8List? imageBytes = await _captureQrImage();

      if (imageBytes != null) {
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/upi_payment_qr.png').create();
        await file.writeAsBytes(imageBytes);

        await Share.shareXFiles(
            [XFile(file.path)],
            text: 'Scan this QR code to pay.',
            subject: 'Pay via UPI'
        );
      } else {
        _isPaymentAppOpened = false;
        AppUtils.showErrorSnackBar(bodyText: "Could not generate QR image.");
      }
    } catch (e) {
      _isPaymentAppOpened = false;
      AppUtils.showErrorSnackBar(bodyText: "Error sharing image");
    }
  }

  Future<void> _saveQrToGallery() async {
    try {
      bool hasAccess = await Gal.hasAccess();
      if (!hasAccess) await Gal.requestAccess();

      Uint8List? imageBytes = await _captureQrImage();

      if (imageBytes != null) {
        await Gal.putImageBytes(
          imageBytes,
          name: "SPL_QR_${DateTime.now().millisecondsSinceEpoch}",
        );
        _showQrSavedPopup();
        // AppUtils.showSuccessSnackBar(bodyText: "QR Saved to Gallery! ✅");
      } else {
        AppUtils.showErrorSnackBar(bodyText: "Failed to generate QR image.");
      }
    } catch (e) {
      if (e.toString().contains("access")) {
        AppUtils.showErrorSnackBar(bodyText: "Please allow photos permission.");
        openAppSettings();
      } else {
        AppUtils.showErrorSnackBar(bodyText: "Failed to save image.");
      }
    }
  }

  Future<Uint8List?> _captureQrImage() async {
    final String? qrBase64 = widget.paymentData?['qrImageBase64'];

    if (qrBase64 != null && qrBase64.isNotEmpty) {
      return base64Decode(qrBase64);
    } else {
      RenderRepaintBoundary? boundary = _qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if(boundary == null) {
        await Future.delayed(const Duration(milliseconds: 100));
        boundary = _qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      }

      if (boundary != null) {
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        return byteData?.buffer.asUint8List();
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final upiIntents = widget.paymentData?['upi_intent'] ?? {};
    final paytmLink = upiIntents['paytm_link'] ?? upiIntents['bhim_link'];

    final String? qrBase64 = widget.paymentData?['qrImageBase64'];
    final String paymentUrl = widget.paymentData?['payment_url'] ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete Payment"),
        centerTitle: true,
        backgroundColor: AppColors.appbarColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: Container(
            padding: EdgeInsets.all(11.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Amount
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.grey[50],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("₹${widget.amount}", style: CustomTextStyle.textRobotoMedium.copyWith(fontSize: 16.sp)),
                      InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: widget.amount));
                          AppUtils.showErrorSnackBar(bodyText: "Amount copied!");
                        },
                        child: Icon(Icons.copy, size: 20.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),

                Text("SCAN QR TO PAY", style: CustomTextStyle.textRobotoMedium.copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 10.h),

                RepaintBoundary(
                  key: _qrKey,
                  child: Container(
                    height: 180.w, width: 180.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: (qrBase64 != null && qrBase64.isNotEmpty)
                        ? Image.memory(base64Decode(qrBase64), fit: BoxFit.contain)
                        : (paymentUrl.isNotEmpty)
                        ? QrImageView(data: paymentUrl, version: QrVersions.auto, size: 180.w)
                        : Icon(Icons.broken_image, color: Colors.red, size: 40),
                  ),
                ),

                SizedBox(height: 15.h),
                ValueListenableBuilder<int>(
                  valueListenable: _remainingSecondsNotifier,
                  builder: (context, remainingSeconds, child) {
                    int minutes = remainingSeconds ~/ 60;
                    int seconds = remainingSeconds % 60;
                    String timerText = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

                    return Text(
                      "QR Expires in: $timerText",
                      style: CustomTextStyle.textRobotoMedium.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    );
                  },
                ),

                SizedBox(height: 15.h),

                SizedBox(
                  width: double.infinity,
                  height: 45.h,
                  child: OutlinedButton.icon(
                    onPressed: _saveQrToGallery,
                    icon: const Icon(Icons.download_rounded),
                    label: const Text("Save QR to Gallery"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.appbarColor,
                      side: BorderSide(color: AppColors.appbarColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                  ),
                ),
                SizedBox(height: 15.h),

                SizedBox(
                  width: double.infinity,
                  height: 45.h,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : () => _checkPaymentStatus(),
                    icon: _isLoading
                        ? SizedBox(width: 20.w, height: 20.w, child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.refresh),
                    label: Text(_isLoading ? "Checking..." : "Check Payment Status"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),


                Row(
                  children: [
                    Expanded(child: InkWell(onTap: () => _launchUPI(paytmLink, isPaytm: true), child: _buildPaymentButton(assetName: ConstantImage.paytm, label: "PayTM"))),
                    SizedBox(width: 15.w),
                    // GPay shares QR
                    Expanded(child: InkWell(onTap: () => _shareQrImage(), child: _buildPaymentButton(assetName: ConstantImage.gPay, label: "GPay"))),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [

                    Expanded(child: InkWell(onTap: () async{await _saveQrToGallery(); _launchUPI(null, isPhonePe: true); }, child: _buildPaymentButton(assetName: ConstantImage.phonepay, label: "PhonePe"))),
                  ],
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentButton({required String assetName, required String label}) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(assetName, height: 24.h, errorBuilder: (_, __, ___) => Icon(Icons.payment)),
          SizedBox(width: 8.w),
          Text(label, style: CustomTextStyle.textRobotoMedium.copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
