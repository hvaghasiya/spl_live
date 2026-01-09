import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../api_services/api_service.dart';
import '../../../components/DeviceInfo/device_info.dart';
import '../../../helper_files/constant_variables.dart';
import '../../../helper_files/ui_utils.dart';
import '../../../models/commun_models/user_details_model.dart';
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
      if (value['status'] && value['data'] != null) {

        final userData = UserDetailsModel.fromJson(value['data']);

        GetStorage().write(ConstantsVariables.authToken, value['data']['Token']);
        GetStorage().write(ConstantsVariables.isActive, value['data']['IsActive']);
        GetStorage().write(ConstantsVariables.isVerified, value['data']['IsVerified']);
        GetStorage().write(ConstantsVariables.isUserDetailSet, value['data']['IsUserDetailSet']);
        GetStorage().write(ConstantsVariables.userData, value['data']);
        GetStorage().write(ConstantsVariables.id, value['data']["Id"]);

        attachFreshchatUser(userData);

        Get.toNamed(AppRoutName.setMPINPage);
      } else {
        AppUtils().accountFlowDialog(msg: value['message']);
      }
    });
  }

  void attachFreshchatUser(UserDetailsModel userData) {

    final FreshchatUser user = FreshchatUser(
      userData.id.toString(),
      "",
    );

    user.setFirstName(userData.userName ?? "User");

    if (userData.phoneNumber != null && userData.phoneNumber!.isNotEmpty) {
      user.setPhone(
        userData.phoneNumber!,
        userData.countryCode ?? "91",
      );
    }

    Freshchat.setUser(user);
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
