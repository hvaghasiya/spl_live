import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/simple_button_with_corner.dart';
import '../../helper_files/app_colors.dart';
import '../../helper_files/constant_image.dart';
import '../../helper_files/custom_text_style.dart';
import '../../helper_files/dimentions.dart';
import '../../routes/app_routes_name.dart';
import 'controller/welcome_screen.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  var controller = Get.put(WelcomeScreenController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var verticalSpace = SizedBox(height: Dimensions.h10);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.w25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: Get.height * 0.2),
              SizedBox(
                height: Dimensions.h150,
                width: Dimensions.h200,
                child: Image.asset(
                  ConstantImage.splLogo,
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                "Welcome",
                style: CustomTextStyle.textRobotoSlabLight.copyWith(
                  fontSize: Dimensions.h25,
                  color: AppColors.appbarColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              verticalSpace,
              verticalSpace,
              RoundedCornerButton(
                text: "SIGNIN".tr,
                color: AppColors.appbarColor,
                borderColor: AppColors.appbarColor,
                fontSize: Dimensions.h12,
                fontWeight: FontWeight.w500,
                fontColor: AppColors.white,
                letterSpacing: 0,
                borderRadius: Dimensions.r25,
                borderWidth: 1,
                textStyle: CustomTextStyle.textRobotoSansLight,
                onTap: () => Get.toNamed(AppRoutName.signInPage),
                height: Dimensions.h30,
                width: double.infinity,
              ),
              verticalSpace,
              orView(),
              verticalSpace,
              RoundedCornerButton(
                text: "SIGNUP".tr,
                color: AppColors.white,
                borderColor: AppColors.appbarColor,
                fontSize: Dimensions.h12,
                fontWeight: FontWeight.w500,
                fontColor: AppColors.appbarColor,
                letterSpacing: 0,
                borderRadius: Dimensions.r50,
                borderWidth: 1,
                textStyle: CustomTextStyle.textRobotoSansMedium,
                onTap: () => Get.toNamed(AppRoutName.signUnPage),
                height: Dimensions.h30,
                width: double.infinity,
              ),
              SizedBox(height: Get.height * 0.2),
            ],
          ),
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
            indent: Dimensions.w20,
            endIndent: Dimensions.w20,
            thickness: 2,
          ),
        ),
        Text(
          "OR",
          style: CustomTextStyle.textRobotoSlabMedium.copyWith(
            fontSize: Dimensions.h20,
            color: AppColors.greyShade.withOpacity(0.6),
            fontWeight: FontWeight.w300,
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.greyShade.withOpacity(0.6),
            indent: Dimensions.w20,
            endIndent: Dimensions.w20,
            thickness: 2,
          ),
        ),
      ],
    );
  }
}
