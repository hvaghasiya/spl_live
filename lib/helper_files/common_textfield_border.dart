import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/custom_text_style.dart';

import 'dimentions.dart';

class CommonTextFieldBorder extends StatelessWidget {
  final String? hintText;
  final String? headerLabel;

  final EdgeInsetsGeometry? contentPadding;
  final Color? hintTextColor;
  final FontWeight? hintTextFontWeight;
  final double? hintTextFontSize;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final Color? borderColor;
  final TextInputType? keyBoardType;
  final TextEditingController? con;
  final bool? readOnly;
  final void Function()? onTap;
  final Widget? prefix;
  final Widget? suffix;
  final int? maxLine;
  final List<TextInputFormatter>? inputFormatters;
  final bool? obscureText;
  final String? labelText;
  final int? maxLength;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;

  const CommonTextFieldBorder({
    Key? key,
    this.hintText,
    this.headerLabel,
    this.contentPadding,
    this.hintTextColor,
    this.hintTextFontWeight,
    this.hintTextFontSize,
    this.fillColor,
    this.borderColor,
    this.keyBoardType,
    this.con,
    this.maxLength,
    this.validator,
    this.readOnly,
    this.onTap,
    this.prefix,
    this.suffix,
    this.inputFormatters,
    this.maxLine,
    this.obscureText,
    this.labelText,
    this.onChanged,
    this.onFieldSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.w10),
      child: TextFormField(
        style: CustomTextStyle.textRobotoSansBold,
        maxLines: maxLine ?? 1,
        controller: con,
        keyboardType: keyBoardType,
        validator: validator,
        readOnly: readOnly ?? false,
        onTap: onTap,
        maxLength: maxLength,
        onChanged: onChanged,
        enabled: true,
        obscureText: obscureText ?? false,
        inputFormatters: inputFormatters,
        cursorColor: AppColors.black,
        onFieldSubmitted: onFieldSubmitted,
        decoration: InputDecoration(
          filled: true,
          isDense: true,
          hintText: hintText,
          contentPadding: contentPadding,
          prefixIcon: prefix,
          labelText: labelText,
          suffixIcon: suffix,
          labelStyle: CustomTextStyle.textRobotoMedium.copyWith(
            color: hintTextColor ?? AppColors.black,
            fontWeight: hintTextFontWeight ?? FontWeight.w700,
            fontSize: hintTextFontSize ?? 16,
          ),
          hintStyle: CustomTextStyle.textRobotoMedium.copyWith(
            color: hintTextColor ?? AppColors.black,
            fontWeight: hintTextFontWeight ?? FontWeight.w600,
            fontSize: hintTextFontSize ?? 20,
          ),
          fillColor: fillColor ?? AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: borderColor ?? AppColors.black, width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: borderColor ?? AppColors.black, width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: AppColors.black,
            ),
          ),
        ),
      ),
    );
  }
}
