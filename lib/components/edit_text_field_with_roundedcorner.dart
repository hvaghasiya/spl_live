import 'package:flutter/material.dart';
import 'package:spllive/helper_files/app_colors.dart';

import '../helper_files/custom_text_style.dart';
import '../helper_files/dimentions.dart';

class RoundedCornerEditText extends StatelessWidget {
  RoundedCornerEditText(
      {Key? key,
      required this.controller,
      required this.maxLines,
      required this.minLines,
      required this.hintText,
      this.isEnabled = true,
      required this.keyboardType,
      this.validateValue,
      this.maxLength})
      : super(key: key);

  final TextEditingController controller;
  int? maxLength;
  int? maxLines;
  int? minLines;
  String hintText;
  bool isEnabled;
  TextInputType keyboardType;
  Function(bool, String)? validateValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      enabled: isEnabled,
      controller: controller,
      validator: (value) {
        validateValue!(false, value.toString());
        return null;
      },
      maxLength: maxLength,
      maxLines: maxLines,
      minLines: minLines,
      keyboardType: keyboardType,
      cursorColor: AppColors.appbarColor,
      style: CustomTextStyle.textPTsansMedium.copyWith(
          color: AppColors.black,
          fontWeight: FontWeight.normal,
          fontSize: Dimensions.h16),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(Dimensions.h10),
        focusColor: AppColors.black,
        filled: true,
        fillColor: AppColors.white,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        counterText: "",
        border: InputBorder.none,
        errorMaxLines: 4,
        hintText: hintText,
        hintStyle: CustomTextStyle.textPTsansBold.copyWith(
          color: AppColors.grey,
          fontSize: Dimensions.h15,
        ),
      ),
    );
  }
}
