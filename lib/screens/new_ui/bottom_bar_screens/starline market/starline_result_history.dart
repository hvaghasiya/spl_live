import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spllive/controller/starline_market_controller.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/constant_image.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';

import '../../../../components/common_appbar.dart';

class StarlineResultHistory extends StatefulWidget {
  const StarlineResultHistory({super.key});

  @override
  State<StarlineResultHistory> createState() => _StarlineResultHistoryState();
}

class _StarlineResultHistoryState extends State<StarlineResultHistory> {
  final starlineCon = Get.find<StarlineMarketController>();

  @override
  void initState() {
    starlineCon.dateResultHistory.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    starlineCon.getResultHistory(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: CommonAppBar(
          title: "Starline Result History",
          leading: GestureDetector(
              onTap: () {
                for (var e in starlineCon.starlineButtonList) {
                  e.isSelected.value = false;
                }
                Get.back();
              },
              child: Icon(Icons.arrow_back, size: 30)),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SizedBox(height: Dimensions.h11),
              SizedBox(
                height: 45,
                child: TextField(
                  controller: starlineCon.dateResultHistory,
                  style: CustomTextStyle.textRobotoSansMedium.copyWith(color: AppColors.appbarColor),
                  decoration: InputDecoration(
                    hintText: DateFormat('dd-MM-yyyy').format(DateTime.now()).toString(),
                    hintStyle: CustomTextStyle.textRobotoSansMedium.copyWith(
                      color: AppColors.appbarColor,
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: Dimensions.w8, vertical: Dimensions.h10),
                    filled: true,
                    fillColor: AppColors.grey.withOpacity(0.15),
                    prefixIcon: Icon(Icons.calendar_month_sharp, color: AppColors.appbarColor),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: starlineCon.bidHistoryDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now());

                    if (pickedDate != null) {
                      starlineCon.dateResultHistory.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                      starlineCon.getResultHistory(DateFormat('yyyy-MM-dd').format(pickedDate));
                    }
                  },
                ),
              ),
              SizedBox(height: 10.0),
              starlineCon.marketListForResult.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5.0),
                        shrinkWrap: true,
                        itemCount: starlineCon.marketListForResult.length,
                        itemBuilder: (context, index) {
                          print(starlineCon.marketListForResult[index].time);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              height: Dimensions.h50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.white,
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 0.2,
                                    color: AppColors.black,
                                    blurStyle: BlurStyle.outer,
                                    blurRadius: 2.5,
                                    offset: const Offset(2, 2),
                                  )
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                          width: Dimensions.w35,
                                          child: SvgPicture.asset(
                                            clockIcon(starlineCon.marketListForResult[index].time?.split(":")[0] ??
                                                "00:00 AM"),
                                            color: AppColors.appbarColor,
                                          )),
                                      SizedBox(width: Dimensions.w10),
                                      Text(
                                        starlineCon.marketListForResult[index].time ?? "00:00 AM",
                                        style: CustomTextStyle.textRobotoSansBold.copyWith(
                                          fontSize: Dimensions.h15,
                                          color: AppColors.appbarColor,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Expanded(
                                  //   child: SizedBox(width: Dimensions.w10),
                                  // ),
                                  getResult(
                                            starlineCon.marketListForResult[index].isResultDeclared ?? false,
                                            starlineCon.marketListForResult[index].result ?? 0,
                                          ) !=
                                          "***-*"
                                      ? Text(
                                          getResult(
                                            starlineCon.marketListForResult[index].isResultDeclared ?? false,
                                            starlineCon.marketListForResult[index].result ?? 0,
                                          ),
                                          style: CustomTextStyle.textRobotoSansBold.copyWith(fontSize: Dimensions.h15),
                                        )
                                      : SvgPicture.asset(
                                          ConstantImage.openStarsSvg,
                                          width: Dimensions.w60,
                                        )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Container(
                      height: Dimensions.h35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.shade300,
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 0.2,
                            color: AppColors.grey,
                            blurRadius: 1,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "NORESULTHISTORY".tr,
                          style: CustomTextStyle.textRobotoSansMedium.copyWith(
                            fontSize: Dimensions.h16,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  clockIcon(time) {
    switch (time) {
      case "01":
        return ConstantImage.stopWatch_1;
      case "02":
        return ConstantImage.stopWatch_2;
      case "03":
        return ConstantImage.stopWatch_3;
      case "04":
        return ConstantImage.stopWatch_4;
      case "05":
        return ConstantImage.stopWatch_5;
      case "06":
        return ConstantImage.stopWatch_6;
      case "07":
        return ConstantImage.stopWatch_7;
      case "08":
        return ConstantImage.stopWatch_8;
      case "09":
        return ConstantImage.stopWatch_9;
      case "10":
        return ConstantImage.stopWatch_10;
      case "11":
        return ConstantImage.stopWatch_11;
      case "12":
        return ConstantImage.stopWatch_12;
    }
  }

  String getResult(bool resultDeclared, int result) {
    if (resultDeclared) {
      int sum = 0;
      for (int i = result; i > 0; i = (i / 10).floor()) {
        sum += (i % 10);
      }
      return "$result - ${sum % 10}";
    } else {
      return "***-*";
    }
  }
}
