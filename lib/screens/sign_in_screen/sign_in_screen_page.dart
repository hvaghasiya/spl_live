import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart' show GetStorage;


import '../../components/edit_text_field_with_icon.dart';
import '../../components/password_field_with_icon.dart';
import '../../components/simple_button_with_corner.dart';
import '../../helper_files/app_colors.dart';
import '../../helper_files/constant_image.dart';
import '../../helper_files/constant_variables.dart';
import '../../helper_files/custom_text_style.dart';
import '../../helper_files/dimentions.dart';
import '../../helper_files/ui_utils.dart';
import '../../routes/app_routes_name.dart';
import 'controller/sign_in_screen_controller.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final controller = Get.find<SignInPageController>();
  @override
  void initState() {
    super.initState();
    GetStorage().write(ConstantsVariables.timeOut, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.appbarColor),
        systemOverlayStyle: AppUtils.toolBarStyleDark,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // SizedBox(height: Get.height * 0.1),
            SizedBox(
              height: Dimensions.h70,
              width: Dimensions.w150,
              child: Image.asset(
                ConstantImage.splLogo,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: Dimensions.h18),
            Text(
              "WELCOMEBACK".tr,
              style: CustomTextStyle.textRobotoMedium.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: Dimensions.h22,
                letterSpacing: 1,
                color: AppColors.appbarColor,
              ),
            ),
            Text(
              "SIGNIN".tr,
              style: CustomTextStyle.textRobotoMedium.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: Dimensions.h22,
                letterSpacing: 1,
                color: AppColors.appbarColor,
              ),
            ),
            SizedBox(height: Dimensions.h20),
            _buildSignInForm(),
            SizedBox(height: Dimensions.h20),
          ],
        ),
      ),
    );
  }

  _buildMobileNumberField() {
    return RoundedCornerEditTextWithIcon(
      height: Dimensions.h40,
      controller: controller.mobileNumberController,
      keyboardType: TextInputType.phone,
      hintText: "ENTERMOBILENUMBER".tr,
      imagePath: ConstantImage.phoneSVG,
      autofocus: true,
      onChanged: (v) {
        if (v?.length == 10) {
          controller.focusNode1.unfocus();
          controller.focusNode2.requestFocus();
          controller.cursorTimer?.cancel();
          controller.cursorTimer = Timer(const Duration(milliseconds: 50), () {
            controller.mobileNumberController.selection = TextSelection.fromPosition(
              TextPosition(offset: controller.mobileNumberController.text.length),
            );
          });
        }
      },
      hintTextStyle: CustomTextStyle.textRobotoSansLight.copyWith(
        color: AppColors.grey,
        fontSize: Dimensions.h14,
      ),
      textStyle: CustomTextStyle.textRobotoSansLight.copyWith(
        fontSize: Dimensions.h16,
      ),
      maxLines: 1,
      focusNode: controller.focusNode1,
      minLines: 1,
      isEnabled: true,
      maxLength: 10,
      formatter: [FilteringTextInputFormatter.digitsOnly],
    );
  }

  _buildSignInForm() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.h10),
      child: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: _buildMobileNumberField(),
            ),
            SizedBox(height: Dimensions.h20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: _buildPasswordField(),
            ),
            SizedBox(height: Dimensions.h20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.w15),
              child: RoundedCornerButton(
                text: "SIGNIN".tr,
                color: AppColors.appbarColor,
                borderColor: AppColors.appbarColor,
                fontSize: Dimensions.h14,
                fontWeight: FontWeight.w500,
                fontColor: AppColors.white,
                letterSpacing: 0,
                borderRadius: Dimensions.r25,
                borderWidth: 1,
                textStyle: CustomTextStyle.textRobotoMedium,
                onTap: () => controller.onTapOfSignIn(),
                height: Dimensions.h30,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: orView(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.w15),
              child: RoundedCornerButton(
                text: "FORGOTPASS".tr,
                color: AppColors.white,
                borderColor: AppColors.appBlueColor,
                fontSize: Dimensions.h12,
                fontWeight: FontWeight.w500,
                fontColor: AppColors.appBlueColor,
                letterSpacing: 0,
                borderRadius: Dimensions.r25,
                borderWidth: 1,
                textStyle: CustomTextStyle.textRobotoMedium,
                onTap: () => Get.toNamed(AppRoutName.forgotPasswordPage),
                height: Dimensions.h30,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row orView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            color: AppColors.greyShade.withOpacity(0.6),
            indent: Dimensions.w30,
            endIndent: Dimensions.w20,
            thickness: 2,
          ),
        ),
        Text(
          "OR",
          style: CustomTextStyle.textInterRegular.copyWith(
              fontSize: Dimensions.h18, color: AppColors.greyShade.withOpacity(0.6), fontWeight: FontWeight.w400),
        ),
        Expanded(
          child: Divider(
            color: AppColors.greyShade.withOpacity(0.6),
            indent: Dimensions.w20,
            endIndent: Dimensions.w30,
            thickness: 2,
          ),
        ),
      ],
    );
  }

  _buildPasswordField() {
    return PasswordFieldWithIcon(
      focusNode: controller.focusNode2,
      height: Dimensions.h40,
      keyBoardType: TextInputType.visiblePassword,
      controller: controller.passwordController,
      hintText: "ENTERPASSWORDTEXT".tr,
      hidePassword: controller.visiblePassword.value,
      suffixIcon: InkWell(
        onTap: () {
          controller.onTapOfVisibilityIcon();
        },
        child: Icon(
          Icons.visibility,
          size: Dimensions.h15,
          color: controller.visiblePassword.value ? AppColors.appbarColor : AppColors.grey,
        ),
      ),
      suffixIconColor: AppColors.appbarColor,
      imagePath: ConstantImage.lockSVG,
    );
  }
}
