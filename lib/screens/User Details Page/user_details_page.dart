import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/constant_image.dart';
import 'package:spllive/routes/app_routes_name.dart';

import '../../components/edit_text_field_with_icon.dart';
import '../../components/password_field_with_icon.dart';
import '../../components/simple_button_with_corner.dart';
import '../../helper_files/custom_text_style.dart';
import '../../helper_files/dimentions.dart';
import 'controller/user_details_page_controller.dart';

class UserDetailsPage extends StatelessWidget {
  UserDetailsPage({Key? key}) : super(key: key);
  final controller = Get.find<UserDetailsPageController>();
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) async {
        return await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => onExitAlert(context, onCancel: () {
            Navigator.of(context).pop(false);
          }, onExit: () {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          }),
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: Dimensions.h15, right: Dimensions.h15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: Get.height * 0.11),
                Center(
                  child: SizedBox(
                    height: Dimensions.h70,
                    width: Dimensions.w150,
                    child: Image.asset(
                      ConstantImage.splLogo,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.h15),
                Text(
                  "SIGN UP".tr,
                  style: CustomTextStyle.textRobotoSlabBold.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.h25,
                    letterSpacing: 1,
                    color: AppColors.appbarColor,
                  ),
                ),
                SizedBox(height: Dimensions.h15),
                _buildNormalField(
                  hintText: "Enter Full Name".tr,
                  textController: controller.fullNameController,
                  maxLength: 100,
                  keyboardType: TextInputType.text,
                  autofocus: true,
                  formatter: [
                    FullNameInputFormatter(),
                    LengthLimitingTextInputFormatter(50),
                    // FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z]+$')),
                    // FilteringTextInputFormatter.allow(RegExp("[a-z A-Z ']")),
                    // FilteringTextInputFormatter.deny(RegExp(r'\s+'), replacementString: " "),
                  ],
                  //focusNode: controller.fullNameFocusNode,
                ),
                SizedBox(height: Dimensions.h15),
                _buildNormalField(
                  hintText: "Enter User Name".tr,
                  textController: controller.userNameController,
                  maxLength: 100,
                  keyboardType: TextInputType.text,
                  autofocus: true,
                  formatter: [
                    UsernameInputFormatter(),
                    // FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z]+$')),
                    // FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9' ]+")),
                    // FilteringTextInputFormatter.deny(RegExp(r'\s+'), replacementString: " "),
                    LengthLimitingTextInputFormatter(20)
                  ],
                  //focusNode: controller.fullNameFocusNode,
                ),
                // _buildNormalField(
                //   hintText: "Enter User Name".tr,
                //   textController: controller.userNameController,
                //   maxLength: 100,
                //   keyboardType: TextInputType.text,
                //   formatter: [
                //     FilteringTextInputFormatter.allow(RegExp("[a-z A-Z ']")),
                //     // FilteringTextInputFormatter.deny(RegExp(r'\s+'), replacementString: " "),
                //     LengthLimitingTextInputFormatter(20)
                //   ],
                //   // onFieldSubmitted: (v) => controller.checkUserName(username: v),
                //   // onTapOutside: (v) {
                //   //   controller.checkUserName(username: controller.userNameController.text);
                //   // }
                //   //  focusNode: controller.userNameFocusNode,
                // ),
                SizedBox(height: Dimensions.h15),
                _buildPasswordField(
                  hintText: "Enter Password".tr,
                  textController: controller.passwordController,
                  visibility: controller.pVisibility,
                ),
                SizedBox(height: Dimensions.h15),
                _buildPasswordField(
                  hintText: "Enter Confirm Password".tr,
                  textController: controller.confirmPasswordController,
                  visibility: controller.cpVisibility,
                ),
                SizedBox(height: Dimensions.h15),
                _buildSignUpButtonRow(),
                SizedBox(height: Dimensions.h15),
                _buildCreateAccount(),
                SizedBox(height: Get.height * 0.2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AlertDialog onExitAlert(BuildContext context, {required Function() onExit, required Function() onCancel}) {
    return AlertDialog(
      title: Text(
        'Exit App',
        style: CustomTextStyle.textRobotoSansBold,
      ),
      content: Text('Are you sure you want to exit the app?', style: CustomTextStyle.textRobotoSansMedium),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(
            'Cancel',
            style: CustomTextStyle.textRobotoSansBold.copyWith(
              color: AppColors.appbarColor,
            ),
          ),
        ),
        TextButton(
          onPressed: onExit,
          child: Text(
            'Exit',
            style: CustomTextStyle.textRobotoSansBold.copyWith(
              color: AppColors.redColor,
            ),
          ),
        ),
      ],
    );
  }

  _buildNormalField({
    required String hintText,
    required TextEditingController textController,
    required int maxLength,
    required TextInputType keyboardType,
    List<TextInputFormatter>? formatter,
    bool? autofocus,
    FocusNode? focusNode,
    Function()? onEditingComplete,
    Function(PointerDownEvent?)? onTapOutside,
    Function(String)? onFieldSubmitted,
  }) {
    return RoundedCornerEditTextWithIcon(
      height: Dimensions.h40,
      controller: textController,
      keyboardType: keyboardType,
      hintText: hintText,
      imagePath: ConstantImage.profileIconSVG,
      maxLines: 1,
      minLines: 1,
      isEnabled: true,
      maxLength: maxLength,
      formatter: formatter,
      focusNode: focusNode,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      onTapOutside: onTapOutside,
      autofocus: autofocus ?? false,
      hintTextStyle: CustomTextStyle.textRobotoSansLight.copyWith(
        color: AppColors.grey,
        fontSize: Dimensions.h14,
        // fontWeight: FontWeight.w500,
      ),
    );
  }

  _buildPasswordField({
    required String hintText,
    required TextEditingController textController,
    required RxBool visibility,
    FocusNode? focusNode,
    Function(String)? onChanged,
  }) {
    return Obx(() {
      return PasswordFieldWithIcon(
        focusNode: focusNode,
        onChanged: onChanged,
        height: Dimensions.h40,
        keyBoardType: TextInputType.visiblePassword,
        controller: textController,
        hintText: hintText,
        hidePassword: visibility.value,
        suffixIcon: InkWell(
          onTap: () {
            controller.onTapOfVisibilityIcon(visibility);
          },
          child: Icon(
            Icons.visibility,
            size: Dimensions.h15,
            color: visibility.value ? AppColors.grey : AppColors.appbarColor,
          ),
        ),
        suffixIconColor: AppColors.appbarColor,
        imagePath: ConstantImage.lockSVG,
      );
    });
  }

  _buildSignUpButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RoundedCornerButton(
          height: Dimensions.h30,
          width: Dimensions.w300,
          letterSpacing: 1,
          color: AppColors.appbarColor,
          fontSize: Dimensions.h12,
          fontWeight: FontWeight.w500,
          // text: "SIGNUP".tr,
          text: "Register",
          textStyle: CustomTextStyle.textRobotoSansMedium,
          borderRadius: Dimensions.h25,
          borderColor: AppColors.appbarColor,
          borderWidth: 2,
          fontColor: AppColors.white,
          onTap: () => controller.onTapOfRegister(),
        ),
      ],
    );
  }

  _buildCreateAccount() {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.h15),
      child: GestureDetector(
        onTap: () => Get.offAllNamed(AppRoutName.signInPage),
        child: Center(
          child: Text(
            "ACCOUNTLOGIN".tr,
            // "${"HAVEANACCOUNT".tr}? ${"LOGIN".tr} ${"HERE".tr}.",
            style: CustomTextStyle.textRobotoSansLight.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: Dimensions.h14,
              letterSpacing: 1,
              color: AppColors.appbarColor,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }
}

class UsernameInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Regex to allow alphanumeric, underscore, and dot characters only
    final regex = RegExp(r'^[a-zA-Z0-9._]*$');

    if (regex.hasMatch(newValue.text)) {
      return newValue;
    }
    // If the new value doesn't match the regex, return the old value
    return oldValue;
  }
}

class FullNameInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Regex to allow only alphabetic characters and spaces
    final regex = RegExp(r'^[a-zA-Z\s]*$');

    if (regex.hasMatch(newValue.text)) {
      // Prevent multiple spaces in a row or leading spaces
      final sanitizedText = newValue.text.replaceAll(RegExp(r'\s+'), ' ');
      return newValue.copyWith(
        text: sanitizedText,
        selection: TextSelection.collapsed(offset: sanitizedText.length),
      );
    }
    // If the new value doesn't match, return the old value
    return oldValue;
  }
}
