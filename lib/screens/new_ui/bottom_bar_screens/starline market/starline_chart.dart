import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spllive/components/common_appbar.dart';
import 'package:spllive/controller/starline_market_controller.dart';
import 'package:spllive/helper_files/dimentions.dart';

import '../../../../helper_files/app_colors.dart';
import '../../../../helper_files/custom_text_style.dart';
import '../../../../models/starlinechar_model/new_starlinechart_model.dart';

class StarlineChart extends StatefulWidget {
  const StarlineChart({super.key});

  @override
  State<StarlineChart> createState() => _StarlineChartState();
}

class _StarlineChartState extends State<StarlineChart> {
  final starlineCon = Get.find<StarlineMarketController>();

  @override
  void initState() {
    super.initState();
    starlineCon.callGetStarLineChart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "Starline Chart",
        leading: GestureDetector(
            onTap: () {
              for (var e in starlineCon.starlineButtonList) {
                e.isSelected.value = false;
              }
              Get.back();
            },
            child: Icon(Icons.arrow_back, size: 30)),
      ),
      body: Column(
        children: [
          // SizedBox(height: Dimensions.h10),
          // const Text(
          //   "Starline Chart",
          //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          // ),
          SizedBox(height: Dimensions.h5),
          Obx(
            () => starlineCon.starlineChartDateAndTime.isEmpty
                ? SizedBox(
                    height: Get.height / 2.5,
                    child: Center(
                      child: Text(
                        "There is no Data in Starlin Chart",
                        style: CustomTextStyle.textRobotoSansMedium,
                      ),
                    ),
                  )
                : Expanded(
                    child: SingleChildScrollView(
                      child: Row(
                        children: [
                          Obx(() => DataTable(
                                horizontalMargin: 0,
                                columnSpacing: 0,
                                showBottomBorder: false,
                                headingRowHeight: Dimensions.h30,
                                dataRowHeight: Dimensions.h40,
                                columns: [
                                  DataColumn(
                                    label: SingleChildScrollView(
                                      physics: const NeverScrollableScrollPhysics(),
                                      child: Container(
                                        height: Dimensions.h30,
                                        width: Dimensions.w100,
                                        decoration: BoxDecoration(
                                            color: AppColors.appbarColor, border: Border.all(color: AppColors.white)),
                                        child: Center(
                                          child: Text(
                                            'Date',
                                            style: TextStyle(color: AppColors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: List<DataRow>.generate(
                                  starlineCon.starlineChartDateAndTime.length,
                                  // 10,
                                  (index) {
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          Center(
                                            child: Text(
                                              starlineCon.starlineChartDateAndTime[index].date ?? "",
                                              //"2023-08-13",
                                              textAlign: TextAlign.center,
                                              style: CustomTextStyle.textRobotoMedium.copyWith(
                                                fontSize: 15.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              )),
                          Expanded(
                              child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Obx(
                              () => DataTable(
                                headingRowHeight: Dimensions.h30,
                                dataRowHeight: Dimensions.h40,
                                horizontalMargin: 0,
                                headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white,
                                ),
                                rows: List<DataRow>.generate(
                                  starlineCon.starlineChartDateAndTime.length,
                                  (i) {
                                    return DataRow(
                                        color: MaterialStateColor.resolveWith(
                                          (states) => Colors.white,
                                        ),
                                        cells: List<DataCell>.generate(
                                          starlineCon.starlineChartTime.length,
                                          //13,
                                          (j) {
                                            final time = starlineCon.starlineChartTime[j];
                                            final timeData = starlineCon.starlineChartDateAndTime[i].time?.firstWhere(
                                              (item) => item.marketName == time.marketName,
                                              orElse: () => Time(),
                                            );
                                            return DataCell(
                                              Container(
                                                height: Dimensions.h40,
                                                width: Dimensions.w100,
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: AppColors.grey.withOpacity(0.2)),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(3.0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        height: Dimensions.h13,
                                                        child: FittedBox(
                                                          fit: BoxFit.fitHeight,
                                                          child: Text(
                                                            timeData!.result != null
                                                                ? getResult2(true, timeData.result)
                                                                : "***",
                                                            textAlign: TextAlign.center,
                                                            style: CustomTextStyle.textRobotoSansMedium,
                                                          ),
                                                        ),
                                                      ),
                                                      timeData.result != null
                                                          ? SizedBox(
                                                              height: Dimensions.h2,
                                                            )
                                                          : const SizedBox(),
                                                      Expanded(
                                                        child: Text(
                                                          timeData.result != null
                                                              ? getResult3(true, timeData.result)
                                                              : "*",
                                                          textAlign: TextAlign.center,
                                                          style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                                            fontSize: Dimensions.h14,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ));
                                  },
                                ),
                                columnSpacing: 0,
                                columns: List<DataColumn>.generate(
                                  starlineCon.starlineChartTime.length,
                                  //10,
                                  (index) {
                                    return DataColumn(
                                      label: Container(
                                        height: Dimensions.h30,
                                        width: Dimensions.w100,
                                        decoration: BoxDecoration(
                                            color: AppColors.appbarColor, border: Border.all(color: AppColors.white)),
                                        child: Center(
                                          child: Text(
                                            starlineCon.starlineChartTime[index].marketName ?? "",
                                            // "11:00 AM",
                                            textAlign: TextAlign.center,
                                            style:
                                                CustomTextStyle.textRobotoSansMedium.copyWith(color: AppColors.white),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ))
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  String getResult2(bool resultDeclared, int result) {
    if (resultDeclared) {
      int sum = 0;
      for (int i = result; i > 0; i = (i / 10).floor()) {
        sum += (i % 10);
      }

      return "$result";
    } else {
      return "***";
    }
  }

  String getResult3(bool resultDeclared, int result) {
    if (resultDeclared) {
      int sum = 0;
      for (int i = result; i > 0; i = (i / 10).floor()) {
        sum += (i % 10);
      }
      return "${sum % 10}";
    } else {
      return "*";
    }
  }
}
