import 'package:flutter/material.dart';
import 'package:spllive/helper_files/app_colors.dart';

class SetFilter extends StatefulWidget {
  const SetFilter({super.key});

  @override
  State<SetFilter> createState() => _SetFilterState();
}

class _SetFilterState extends State<SetFilter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: AppColors.appbarColor,
        title: Text(
          "Set Filter",
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
