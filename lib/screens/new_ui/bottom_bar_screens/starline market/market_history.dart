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

class MarketHistory extends StatefulWidget {
  const MarketHistory({super.key});

  @override
  State<MarketHistory> createState() => _MarketHistoryState();
}

class _MarketHistoryState extends State<MarketHistory> {
  final controller = Get.find<StarlineMarketController>();

  @override
  void initState() {
    print("fsdkjfhsdkjfhdk");
    controller.starlineMarketDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    controller.dateInputForResultHistory.text = DateFormat('dd-MM-yyyy').format(DateTime.now());

    controller.update();
    controller.getDailyMarketsResults();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CommonAppBar(
          title: "Market Results",
          leading: GestureDetector(
              onTap: () {
                controller.marketHistoryListt.clear();
                Get.back();
              },
              child: const Icon(Icons.arrow_back, size: 30)),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Dimensions.h11),
                SizedBox(
                  height: 45,
                  child: TextField(
                    controller: controller.dateInputForResultHistory,
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
                          initialDate: controller.bidHistoryDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now());

                      if (pickedDate != null) {
                        controller.bidHistoryDate = pickedDate;
                        controller.dateInputForResultHistory.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                        controller.starlineMarketDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                        controller.getDailyMarketsResults();
                      }
                    },
                  ),
                ),
                SizedBox(height: Dimensions.h11),
                Obx(
                  () => controller.isMarketResults.value == false
                      ? Obx(
                          () => controller.marketHistoryListt.isEmpty
                              ? const Expanded(
                                  child: Center(
                                    child: Align(alignment: Alignment.center, child: Text("Market result not found")),
                                  ),
                                )
                              : Expanded(
                                  child: Obx(
                                    () => ListView.builder(
                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                      shrinkWrap: true,
                                      physics: const ScrollPhysics(),
                                      itemCount: controller.marketHistoryListt.value.length,
                                      itemBuilder: (context, index) {
                                        return Obx(
                                          () => Padding(
                                            padding: const EdgeInsets.only(bottom: 18.0),
                                            child: Container(
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
                                                children: [
                                                  SizedBox(width: Dimensions.w10),
                                                  // Icon(Icons.watch, color: AppColors.black),
                                                  Text(
                                                    "${controller.marketHistoryListt.value[index].name}",
                                                    style: CustomTextStyle.textRobotoSansBold.copyWith(
                                                      fontSize: Dimensions.h15,
                                                      color: AppColors.appbarColor,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: SizedBox(width: Dimensions.w10),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      buildResult(
                                                          isOpenResult: true,
                                                          resultDeclared: controller.marketHistoryListt.value[index]
                                                                  .IsOpenResultDeclared ??
                                                              false,
                                                          result:
                                                              controller.marketHistoryListt.value[index].openResult ??
                                                                  0),
                                                      buildResult(
                                                        isOpenResult: false,
                                                        resultDeclared: controller.marketHistoryListt.value[index]
                                                                .IsCloseResultDeclared ??
                                                            false,
                                                        result:
                                                            controller.marketHistoryListt.value[index].closeResult ?? 0,
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(width: Dimensions.w10),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                        )
                      : Expanded(child: Center(child: CircularProgressIndicator(color: AppColors.appBlueColor))),
                )
              ],
            )),
      ),
    );
  }
}

String getResult(bool isOpenClose, int result) {
  if (isOpenClose) {
    int sum = 0;
    for (int i = result; i > 0; i = (i / 10).floor()) {
      sum += (i % 10);
    }
    return "$result - ${sum % 10}";
  } else {
    return "***-*";
  }
}

Widget buildResult({required bool isOpenResult, required bool resultDeclared, required int result}) {
  if (resultDeclared && result != 0 && result.toString().isNotEmpty) {
    int sum = 0;
    for (int i = result; i > 0; i = (i / 10).floor()) {
      sum += (i % 10);
    }
    return Text(
      isOpenResult ? "$result - ${sum % 10}" : "${sum % 10} - $result",
      style: CustomTextStyle.textRobotoMedium.copyWith(
        fontSize: Dimensions.h13,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
        letterSpacing: 1,
      ),
    );
  } else if (result == 0 && result.toString().isNotEmpty && resultDeclared) {
    return Text(
      isOpenResult ? "000 - $result" : "$result - 000",
      style: CustomTextStyle.textRobotoMedium.copyWith(
        fontSize: Dimensions.h13,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
        letterSpacing: 1,
      ),
    );
  } else {
    return SvgPicture.asset(
      isOpenResult ? ConstantImage.openStarsSvg : ConstantImage.closeStarsSvg,
      width: Dimensions.w60,
    );
  }
}
