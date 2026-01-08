import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:get/get.dart';

import '../../components/password_field_with_icon.dart';
import '../../components/simple_button_with_corner.dart';
import '../../helper_files/app_colors.dart';
import '../../helper_files/constant_image.dart';
import '../../helper_files/custom_text_style.dart';
import '../../helper_files/dimentions.dart';
import 'controller/reset_password_controller.dart';

class ResetPasswordPage extends StatelessWidget {
  ResetPasswordPage({Key? key}) : super(key: key);

  final controller = Get.find<ResetPasswordController>();
  final verticalSpace = SizedBox(height: Dimensions.h20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            _buildChangePasswordForm(context),
          ],
        ),
      ),
    );
  }

  _buildChangePasswordForm(context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.h20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(height: 10),
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
          const SizedBox(height: 10),
          Center(
            child: Text(
              "RESETPASSWORD".tr,
              style: CustomTextStyle.textRobotoSlabBold.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.h26,
                letterSpacing: 1,
                color: AppColors.appbarColor,
              ),
            ),
          ),
          // verticalSpace,
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: Dimensions.w20),
          //   child: Text(
          //     "RESETPASSWORDTEXT".tr,
          //     textAlign: TextAlign.center,
          //     style: CustomTextStyle.textRobotoSansLight.copyWith(
          //       fontSize: Dimensions.h16,
          //       letterSpacing: 1,
          //       height: 1.5,
          //       color: AppColors.appbarColor,
          //     ),
          //   ),
          // ),
          verticalSpace,
          _buildPinCodeField(
            context: context,
            pinCodeLength: 6,
            title: "OTP".tr,
            pinType: controller.otp,
            focusNode: controller.focusNode1,
            onChanged: (val) {
              if (val.length == 6) {
                controller.focusNode1.unfocus();
                controller.focusNode2.requestFocus();
              }
            },
          ),
          SizedBox(
            height: Dimensions.h10,
          ),
          Obx(
            () => Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.h12),
                child: GestureDetector(
                  onTap: () => controller.formattedTime.toString() != "0:00" ? null : controller.callResendOtpApi(),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "DIDOTP".tr,
                      style: CustomTextStyle.textRobotoSansLight.copyWith(
                        color: AppColors.appbarColor,
                        fontWeight: FontWeight.normal,
                        fontSize: Dimensions.h14,
                      ),
                      children: [
                        controller.formattedTime.toString() != "0:00"
                            ? TextSpan(
                                text: controller.formattedTime.toString(),
                                style: CustomTextStyle.textRobotoSansLight.copyWith(
                                  color: AppColors.appbarColor,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.normal,
                                  fontSize: Dimensions.h14,
                                ),
                              )
                            : TextSpan(
                                text: "RESENDOTP".tr,
                                style: CustomTextStyle.textRobotoSansLight.copyWith(
                                  color: AppColors.appbarColor,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.normal,
                                  fontSize: Dimensions.h14,
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Obx(
          //   () => Align(
          //     alignment: Alignment.bottomRight,
          //     child: Padding(
          //       padding: const EdgeInsets.only(right: 20.0, top: 10),
          //       child: GestureDetector(
          //         onTap: () {
          //           controller.formattedTime.toString() != "0:00"
          //               ? null
          //               : controller.callResendOtpApi();
          //         },
          //         child: Text(
          //           controller.formattedTime.toString(),
          //           style: CustomTextStyle.textRobotoSansMedium.copyWith(
          //             fontWeight: FontWeight.bold,
          //             fontSize: Dimensions.h15,
          //             decoration: TextDecoration.underline,
          //             letterSpacing: 1,
          //             color: AppColors.appbarColor,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          verticalSpace,
          _buildPasswordField(
              focusNode: controller.focusNode2,
              onChanged: (val) {
                if (val.isEmpty) {
                  controller.focusNode2.unfocus();
                  controller.focusNode1.requestFocus();
                }
              },
              title: "PASSWORD".tr,
              hintText: "ENTERPASSWORD".tr,
              textController: controller.passwordController,
              visibility: controller.pVisibility),
          verticalSpace,
          _buildPasswordField(
              focusNode: controller.focusNode3,
              onChanged: (val) {},
              title: "ENTERCONFIRMPASSWORD".tr,
              hintText: "ENTERCONFIRMPASSWORD".tr,
              textController: controller.confirmPasswordController,
              visibility: controller.cpVisibility),
          verticalSpace,
          RoundedCornerButton(
            text: "RESETPASSWORD".tr,
            color: AppColors.appbarColor,
            borderColor: AppColors.appbarColor,
            fontSize: Dimensions.h15,
            fontWeight: FontWeight.w500,
            fontColor: AppColors.white,
            letterSpacing: 0,
            borderRadius: Dimensions.r9,
            borderWidth: 1,
            textStyle: CustomTextStyle.textRobotoSlabMedium,
            onTap: () => controller.onTapOfResetPassword(),
            height: Dimensions.h46,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  _buildPasswordField({
    required String title,
    required String hintText,
    required TextEditingController textController,
    required RxBool visibility,
    FocusNode? focusNode,
    required Function(String) onChanged,
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
            color: visibility.value ? AppColors.appbarColor : AppColors.grey,
          ),
        ),
        suffixIconColor: AppColors.grey,
        imagePath: ConstantImage.lockSVG,
      );
    });
  }

  _buildPinCodeField({
    required BuildContext context,
    required String title,
    required RxString pinType,
    required int pinCodeLength,
    FocusNode? focusNode,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: CustomTextStyle.textRobotoSlabBold.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: Dimensions.h15,
            letterSpacing: 1,
            color: AppColors.black,
          ),
        ),
        PinCodeFields(
          autofocus: true,
          length: pinCodeLength,
          focusNode: focusNode,
          obscureText: false,
          obscureCharacter: "",
          textStyle: CustomTextStyle.textRobotoSansMedium
              .copyWith(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 20),
          animationDuration: const Duration(milliseconds: 200),
          onComplete: (val) {
            pinType.value = val;
          },
          keyboardType: TextInputType.number,
          animation: Animations.fade,
          activeBorderColor: AppColors.appbarColor,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          onChange: (val) {
            pinType.value = val;
            onChanged(val);
          },
          enabled: true,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          responsive: true,
        ),
        // PinCodeTextField(
        //   length: pinCodeLength,
        //   appContext: context,
        //   cursorColor: AppColors.black,
        //   obscureText: false,
        //   animationType: AnimationType.fade,
        //   keyboardType: TextInputType.number,
        //   enableActiveFill: true,
        //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        //   pinTheme: PinTheme(
        //       shape: PinCodeFieldShape.box,
        //       activeFillColor: AppColors.grey.withOpacity(0.2),
        //       inactiveFillColor: AppColors.grey.withOpacity(0.2),
        //       selectedFillColor: AppColors.grey.withOpacity(0.2),
        //       inactiveColor: Colors.transparent,
        //       activeColor: Colors.transparent,
        //       selectedColor: Colors.transparent,
        //       errorBorderColor: Colors.transparent,
        //       borderWidth: 0,
        //       borderRadius: BorderRadius.all(Radius.circular(Dimensions.r5))),
        //   textStyle: CustomTextStyle.textPTsansMedium
        //       .copyWith(color: AppColors.black, fontWeight: FontWeight.bold),
        //   animationDuration: const Duration(milliseconds: 200),
        //   // controller: controller.otpController,
        //   onCompleted: (val) {
        //     pinType.value = val;
        //   },
        //   onChanged: (val) {
        //     pinType.value = val;
        //   },
        //   beforeTextPaste: (text) {
        //     return false;
        //   },
        // ),
      ],
    );
  }
}
