import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../api_services/api_service.dart';
import '../../../helper_files/app_colors.dart';
import '../../../helper_files/custom_text_style.dart';
import '../../../helper_files/dimentions.dart';
import '../../../helper_files/ui_utils.dart';
import '../../../routes/app_routes_name.dart';
import '../../Set MPIN Page/model/user_details_model.dart';

class UserDetailsPageController extends GetxController {
  var fullNameController = TextEditingController();
  var userNameController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  final pattern = RegExp(r'^[a-zA-Z\s]+$');
  RxBool pVisibility = false.obs;
  RxBool cpVisibility = false.obs;

  void onTapOfVisibilityIcon(RxBool visibility) => visibility.value = !visibility.value;

  void onTapOfRegister() {
    if (fullNameController.text.trim().isEmpty) {
      AppUtils().accountFlowDialog(msg: "ENTERFULLNAME".tr);
      // AppUtils.showErrorSnackBar(bodyText: "ENTERFULLNAME".tr);
    } else if (fullNameController.text.length < 6 && pattern.hasMatch(fullNameController.text.toString())) {
      AppUtils()
          .accountFlowDialog(msg: "Full name must be at least 6 characters long and \nshould not contain any numbers");
      // AppUtils.showErrorSnackBar(
      //     bodyText: "Full name must be at least 6 characters long and \nshould not contain any numbers");
    } else if (userNameController.text.trim().isEmpty) {
      AppUtils().accountFlowDialog(msg: "ENTERUSERNAME".tr);
      // AppUtils.showErrorSnackBar(bodyText: "ENTERUSERNAME".tr);
    } else if (passwordController.text.isEmpty) {
      AppUtils().accountFlowDialog(msg: "ENTERPASSWORD".tr);
      // AppUtils.showErrorSnackBar(bodyText: "ENTERPASSWORD".tr);
    } else if (passwordController.text.toString().length < 6) {
      AppUtils().accountFlowDialog(msg: "MINSIXCHAR".tr);
      // AppUtils.showErrorSnackBar(bodyText: "MINSIXCHAR".tr);
    } else if (confirmPasswordController.text.isEmpty) {
      AppUtils().accountFlowDialog(msg: "ENTERCONFIRMPASSWORD".tr);
      // AppUtils.showErrorSnackBar(bodyText: "ENTERCONFIRMPASSWORD".tr);
    } else if (confirmPasswordController.text.toString().length < 6) {
      AppUtils().accountFlowDialog(msg: "MINSIXCHAR".tr);
      // AppUtils.showErrorSnackBar(bodyText: "MINSIXCHAR".tr);
    } else if (passwordController.text != confirmPasswordController.text) {
      AppUtils().accountFlowDialog(msg: "PASSWORDDOESNTMATCHED".tr);
      // AppUtils.showErrorSnackBar(bodyText: "PASSWORDDOESNTMATCHED".tr);
    } else {
      // var userDetails = UserDetails(
      //   fullName: fullNameController.text,
      //   userName: userNameController.text,
      //   password: passwordController.text,
      // );
      // checkUserName(username: userNameController.text);
      checkUserName(username: userNameController.text.trim());
    }
  }

  void checkUserName({String? username}) async {
    ApiService().checkUserName(username: username).then((value) async {
      if (value != null) {
        // if (value['status']) {
        if (value['isUsernameAvailable'] == false) {
          Get.defaultDialog(
            barrierDismissible: false,
            title: "",
            onWillPop: () async => false,
            titleStyle: CustomTextStyle.textRobotoSansMedium.copyWith(fontSize: 0),
            content: Column(
              children: [
                Text(
                  value['message'] ?? "",
                  textAlign: TextAlign.center,
                  style: CustomTextStyle.textRobotoSansMedium.copyWith(
                    fontSize: Dimensions.h14,
                  ),
                )
              ],
            ),
            actions: [
              InkWell(
                onTap: () => Get.back(),
                child: Container(
                  color: AppColors.appbarColor,
                  height: Dimensions.h40,
                  width: Dimensions.w200,
                  child: Center(
                    child: Text(
                      'OK',
                      style: CustomTextStyle.textRobotoSansBold.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        if (value['isUsernameAvailable']) {
          Get.toNamed(
            AppRoutName.setMPINPage,
            arguments: UserDetails(
              fullName: fullNameController.text,
              userName: userNameController.text,
              password: passwordController.text,
            ),
          );
        }
        // }
      }
    });
  }
}
