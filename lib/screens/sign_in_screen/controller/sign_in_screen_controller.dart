import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../api_services/api_service.dart';
import '../../../components/DeviceInfo/device_info.dart';
import '../../../helper_files/constant_variables.dart';
import '../../../helper_files/ui_utils.dart';
import '../../../routes/app_routes_name.dart';

class SignInPageController extends GetxController {
  final mobileNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  RxBool visiblePassword = false.obs;
  Timer? cursorTimer;

  @override
  void dispose() {
    cursorTimer?.cancel();
    mobileNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onTapOfVisibilityIcon() => visiblePassword.value = !visiblePassword.value;

  void callSignInApi() async {
    ApiService().signInAPI({
      "phoneNumber": mobileNumberController.text,
      "password": passwordController.text,
      "countryCode": "+91",
      "deviceId": DeviceInfo.deviceId,
    }).then((value) async {
      if (value['status']) {
        if (value['data'] != null) {
          String authToken = value['data']['Token'] ?? "Null From API";
          bool isActive = value['data']['IsActive'] ?? false;
          bool isVerified = value['data']['IsVerified'] ?? false;
          bool isUserDetailSet = value['data']['IsUserDetailSet'] ?? false;
          GetStorage().write(ConstantsVariables.authToken, authToken);
          GetStorage().write(ConstantsVariables.isActive, isActive);
          GetStorage().write(ConstantsVariables.isVerified, isVerified);
          GetStorage().write(ConstantsVariables.userData, value['data']);
          GetStorage().write(ConstantsVariables.isUserDetailSet, isUserDetailSet);
          GetStorage().write(ConstantsVariables.id, value['data']["Id"]);
          Get.toNamed(AppRoutName.setMPINPage);
        } else {
          AppUtils.showErrorSnackBar(bodyText: "Something went wrong!!!");
        }
      } else {
        print("value['message'].length >= 15 ${value['message'].length}");
        print("value['message'].length >= 15 ${value['message'].length <= 17}");
        AppUtils().accountFlowDialog(msg: value['message']);
      }
    });
  }

  void onTapOfSignIn() {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.closeAllSnackbars();
    if (mobileNumberController.text.isEmpty) {
      AppUtils().accountFlowDialog(msg: "ENTERMOBILENUMBER".tr);
      // AppUtils.showErrorSnackBar(bodyText: "ENTERMOBILENUMBER".tr);
    } else if (mobileNumberController.text.length < 10) {
      AppUtils().accountFlowDialog(msg: "ENTERVALIDNUMBER".tr);
      // AppUtils.showErrorSnackBar(bodyText: "ENTERVALIDNUMBER".tr);
    } else if (passwordController.text.isEmpty) {
      AppUtils().accountFlowDialog(msg: "Please_enter_password".tr);
      // AppUtils.showErrorSnackBar(bodyText: "ENTERPASSWORD".tr);
    } else {
      callSignInApi();
    }
  }
}
