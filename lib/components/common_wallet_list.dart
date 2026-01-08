import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../helper_files/app_colors.dart';
import '../helper_files/custom_text_style.dart';
import '../helper_files/dimentions.dart';


class CommonWalletList extends StatelessWidget {
  final String? title;
  final String? image;
  final Function()? onTap;
  const CommonWalletList({super.key, this.title, this.image, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: Dimensions.h50,
          width: Get.width,
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                spreadRadius: 1,
                blurRadius: 4,
                color: AppColors.grey.withOpacity(0.5),
                offset: const Offset(0, 0),
              )
            ],
            borderRadius: BorderRadius.circular(Dimensions.r4),
          ),
          child: Row(
            children: [
              SizedBox(width: Dimensions.w10),
              SvgPicture.asset(
                image ?? "",
                height: Dimensions.h23,
              ),
              SizedBox(width: Dimensions.w15),
              Text(
                title ?? "",
                style: CustomTextStyle.textRobotoMedium.copyWith(fontSize: Dimensions.h18, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
