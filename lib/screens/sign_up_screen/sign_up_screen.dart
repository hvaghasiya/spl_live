import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../components/edit_text_field_with_icon.dart';
import '../../components/simple_button_with_corner.dart';
import '../../helper_files/app_colors.dart';
import '../../helper_files/constant_image.dart';
import '../../helper_files/custom_text_style.dart';
import '../../helper_files/dimentions.dart';
import '../../helper_files/ui_utils.dart';
import 'controller/sign_up_controller.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final controller = Get.find<SignUpPageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.appbarColor),
        systemOverlayStyle: AppUtils.toolBarStyleDark,
      ),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.w35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SizedBox(height: Get.height * 0.10),
              SizedBox(
                height: Dimensions.h150,
                width: Dimensions.w200,
                child: Image.asset(
                  ConstantImage.splLogo,
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                "REGISTER".tr,
                style: CustomTextStyle.textRobotoSlabMedium.copyWith(
                  color: AppColors.appbarColor,
                  fontSize: Dimensions.h20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Dimensions.h20),
              RoundedCornerEditTextWithIcon(
                height: Dimensions.h40,
                width: Get.width,
                controller: controller.mobileNumberController,
                keyboardType: TextInputType.phone,
                hintText: "Enter Mobile Number".tr,
                imagePath: ConstantImage.phoneSVG,
                autofocus: true,
                maxLines: 1,
                minLines: 1,
                isEnabled: true,
                formatter: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
              ),
              SizedBox(height: Dimensions.h20),
              RoundedCornerButton(
                text: "SEND OTP".tr,
                color: AppColors.appbarColor,
                borderColor: AppColors.appbarColor,
                fontSize: Dimensions.h12,
                fontWeight: FontWeight.w500,
                fontColor: AppColors.white,
                letterSpacing: 0,
                borderRadius: Dimensions.r25,
                borderWidth: 1,
                textStyle: CustomTextStyle.textRobotoSansMedium,
                onTap: () => controller.onTapOfSendOtp(),
                height: Dimensions.h30,
                width: double.infinity,
              ),
              // SizedBox(height: Get.height * 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
