import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/constant_image.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? walletBalance;
  final TextStyle? titleTextStyle;
  final List<Widget>? actions;
  Widget? leading;

  CommonAppBar({
    super.key,
    this.title,
    this.actions,
    this.walletBalance,
    this.titleTextStyle,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.appbarColor,
      title: Text(title ?? "", style: CustomTextStyle.textRobotoMedium.copyWith(color: AppColors.white, fontSize: 22)),
      titleTextStyle: titleTextStyle,
      actions: actions,
      automaticallyImplyLeading: false,
      centerTitle: true,
      leadingWidth: leading == null ? Get.width * 0.35 : Get.width * 0.10,
      leading: leading ??
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: Dimensions.w5),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: SizedBox(
                  width: Dimensions.w40,
                  child: SvgPicture.asset(
                    ConstantImage.walletAppbar,
                    color: AppColors.white,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  walletBalance ?? "",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyle.textRobotoSansMedium.copyWith(
                    color: AppColors.white,
                    fontSize: Dimensions.h16,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
