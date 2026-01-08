import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../api_services/api_service.dart';
import '../../../helper_files/constant_variables.dart';
import '../../../helper_files/ui_utils.dart';
import '../../../routes/app_routes_name.dart';


class VerifyOTPController extends GetxController {
  var argument = Get.arguments;
  bool verifyOTP = false;
  RxString otp = "".obs;
  RxString mpin = "".obs;
  RxString confirmMpin = "".obs;
  String phoneNumber = "";

  @override
  void onInit() {
    super.onInit();
    getStoredUserData();
    _startTimer();
  }

  var userData;
  Future<void> getStoredUserData() async {
    if (argument != null) {
      phoneNumber = argument['phoneNumber'];
      // countryCode = argument['countryCode'];
      verifyOTP = false;
    } else {
      // var data = GetStorage().read(ConstantsVariables.userData);
      // userData = UserDetailsModel.fromJson(data);
      verifyOTP = true;
    }
  }

  void onTapOfContinue() {
    if (otp.isEmpty) {
      AppUtils().accountFlowDialog(msg: "ENTEROTP".tr);
      // AppUtils.showErrorSnackBar(bodyText: "ENTEROTP".tr);
    } else if (otp.value.length < 6) {
      AppUtils().accountFlowDialog(msg: "ENTERVALIDOTP".tr);
      // AppUtils.showErrorSnackBar(bodyText: "ENTERVALIDOTP".tr);
    } else {
      verifyOTP ? callVerifyOTPApi() : callVerifyUserApi();
    }
  }

  void callVerifyUserApi() async {
    ApiService().verifyUser({
      "countryCode": "+91",
      "phoneNumber": phoneNumber,
      "otp": otp.value,
    }).then((value) async {
      if (value['status']) {
        AppUtils.showSuccessSnackBar(bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
        var userData = value['data'];
        if (userData != null) {
          String authToken = userData['Token'] ?? "Null From API";
          bool isActive = userData['IsActive'] ?? false;
          bool isVerified = userData['IsVerified'] ?? false;
          bool isUserDetailSet = value['data']['IsUserDetailSet'] ?? false;
          GetStorage().write(ConstantsVariables.authToken, authToken);
          GetStorage().write(ConstantsVariables.isActive, isActive);
          GetStorage().write(ConstantsVariables.isVerified, isVerified);
          GetStorage().write(ConstantsVariables.isUserDetailSet, isUserDetailSet);
          GetStorage().write(ConstantsVariables.id, value['data']['Id']);
          Get.toNamed(AppRoutName.userDetailsPage);
        } else {
          AppUtils().accountFlowDialog(msg: "Something went wrong!!!");
          // AppUtils.showErrorSnackBar(bodyText: "Something went wrong!!!");
        }
      } else {
        AppUtils().accountFlowDialog(msg: value['message']);
        // AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      }
    });
  }

  void callVerifyOTPApi() async {
    ApiService().verifyOTP({"otp": otp.value}).then((value) async {
      if (value['status']) {
        // AppUtils.showSuccessSnackBar(bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
        var userData = value['data'];
        String authToken = userData['Token'] ?? "Null From API";
        GetStorage().write(ConstantsVariables.authToken, authToken);
        if (userData != null) {
          Get.toNamed(
            AppRoutName.setMPINPage,
          );
        } else {
          AppUtils().accountFlowDialog(msg: "Something went wrong!!!");
          // AppUtils.showErrorSnackBar(bodyText: "Something went wrong!!!");
        }
      } else {
        AppUtils().accountFlowDialog(msg: value['message']);
        // AppUtils.showErrorSnackBar(
        //   bodyText: value['message'] ?? "",
        // );
      }
    });
  }

  void callResendOtpApi() async {
    ApiService().resendOTP({"phoneNumber": phoneNumber, "countryCode": "+91"}).then((value) async {
      if (value['status']) {
        secondsRemaining.value = 60;
        _startTimer();
        AppUtils.showSuccessSnackBar(bodyText: "${value['message']}", headerText: "SUCCESSMESSAGE".tr);
      } else {
        AppUtils().accountFlowDialog(msg: value['message']);
        // AppUtils.showErrorSnackBar(
        //   bodyText: value['message'] ?? "",
        // );
      }
    });
  }

  var secondsRemaining = 60.obs;
  late Timer _timer;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        _timer.cancel(); // Stop the timer when it reaches 0
      }
    });
  }

  String get formattedTime {
    int minutes = (secondsRemaining.value ~/ 60);
    int seconds = (secondsRemaining.value % 60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void onClose() {
    _timer.cancel(); // Cancel the timer when the controller is closed
    super.onClose();
  }
}
