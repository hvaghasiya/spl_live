import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/models/daily_market_api_response_model.dart';
import 'package:spllive/screens/home_screen/controller/homepage_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../helper_files/app_colors.dart';
import '../../../helper_files/common_utils.dart';
import '../../../helper_files/constant_image.dart';
import '../../../helper_files/dimentions.dart';
import '../../../models/starlinechar_model/new_starlinechart_model.dart';

class HomeScreenUtils {
  var controller = Get.put(HomePageController());
  Widget buildResult({required bool isOpenResult, required bool resultDeclared, required int result}) {
    if (resultDeclared && result != 0 && result.toString().isNotEmpty) {
      int sum = 0;
      for (int i = result; i > 0; i = (i / 10).floor()) {
        sum += (i % 10);
      }
      return Text(
        isOpenResult ? "$result - ${sum % 10}" : "${sum % 10} - $result",
        style: CustomTextStyle.textRobotoSansMedium.copyWith(
          fontSize: Dimensions.h13,
          fontWeight: FontWeight.bold,
          color: AppColors.redColor,
          letterSpacing: 1,
        ),
      );
    } else if (result == 0 && result.toString().isNotEmpty && resultDeclared) {
      return Text(
        isOpenResult ? "000 - $result" : "$result - 000",
        style: CustomTextStyle.textRobotoSansMedium.copyWith(
          fontSize: Dimensions.h13,
          fontWeight: FontWeight.bold,
          color: AppColors.redColor,
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

  Widget listveiwTransaction({
    required String marketName,
    required String bidNumber,
    required String coins,
    required String ballance,
    required String bidTime,
    required String requestId,
    required bool isWin,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.h5),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              spreadRadius: 1,
              color: AppColors.grey,
              blurRadius: 10,
              offset: const Offset(7, 4),
            ),
          ],
          border: Border.all(width: 0.6),
          color: isWin == true ? AppColors.greenAccent : AppColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    marketName,
                    style: CustomTextStyle.textRobotoSansBold.copyWith(fontSize: Dimensions.h14),
                  ),
                  Text(
                    // "446-47-359",
                    bidNumber,
                    style: CustomTextStyle.textRobotoSansBold,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(Dimensions.h8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "RequestId:  $requestId",
                    style: CustomTextStyle.textRobotoSansLight.copyWith(fontSize: Dimensions.h12),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("POINTS  ", style: CustomTextStyle.textRobotoSansLight),
                  SizedBox(width: Dimensions.w5),
                  SizedBox(width: Dimensions.w5),
                  Text(
                    coins,
                    style: CustomTextStyle.textRobotoSansLight.copyWith(
                      fontSize: Dimensions.h14,
                      color: AppColors.balanceCoinsColor,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  // Text(
                  //   "Balance",
                  //   style: CustomTextStyle.textRobotoSansLight,
                  // ),
                  SizedBox(width: Dimensions.w5),
                  // Image.asset(
                  //   ConstantImage.ruppeeBlueIcon,
                  //   height: 25,
                  //   width: 25,
                  // ),
                  SizedBox(width: Dimensions.w5),
                  Text(
                    ballance,
                    style: CustomTextStyle.textRobotoSansLight.copyWith(
                      fontSize: Dimensions.h14,
                      color: AppColors.balanceCoinsColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: Dimensions.h30,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.greyShade.withOpacity(0.4),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(Dimensions.r8),
                  bottomRight: Radius.circular(Dimensions.r8),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(Dimensions.h8),
                child: Row(
                  children: [
                    const Expanded(child: SizedBox()),
                    Text(bidTime, style: CustomTextStyle.textRobotoSansBold),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  marketIcon({required Function() onTap, required String text, required String iconData, required Color iconColor}) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: Dimensions.h22,
              width: Dimensions.w22,
              child: SvgPicture.asset(
                iconData,
                color: iconColor ?? AppColors.iconColorMain,
              ),
            ),
            // Icon(iconData),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: CustomTextStyle.textPTsansMedium.copyWith(
                    color: iconColor ?? AppColors.iconColorMain,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600,
                    fontSize: Dimensions.h11),
              ),
            )
          ],
        ),
      ),
    );
  }

  iconsContainer({
    required Function() onTap1,
    required Function() onTap2,
    required Function() onTap3,
    required Color iconColor1,
    required Color iconColor2,
    required Color iconColor3,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SizedBox(
            // color: Colors.amber,
            width: Dimensions.w100,
            child: marketIcon(
              iconColor: iconColor1,
              onTap: onTap1,
              text: "MARKET".tr,
              iconData: ConstantImage.marketIcon,
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            // color: Colors.amber,
            width: Dimensions.w100,
            child: marketIcon(
                iconColor: iconColor2, onTap: onTap2, text: "STARLINE".tr, iconData: ConstantImage.starLineIcon),
          ),
        ),
        Expanded(
          child: SizedBox(
            // color: Colors.amber,
            width: Dimensions.w100,
            child: marketIcon(
              onTap: onTap3,
              iconColor: iconColor3,
              text: "ADD FUND".tr,
              iconData: ConstantImage.addFundIcon,
            ),
          ),
        ),
      ],
    );
  }

  iconsContainer2({
    required Function() onTap1,
    required Function() onTap2,
    required Function() onTap3,
    required Color iconColor1,
    required Color iconColor2,
    required Color iconColor3,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.h5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              // color: Colors.amber,
              width: Dimensions.w100,
              child: marketIcon(
                  iconColor: iconColor1, onTap: onTap1, text: "BIDHISTORY".tr, iconData: ConstantImage.bidHistoryIcon),
            ),
          ),
          Expanded(
            child: SizedBox(
              // color: Colors.amber,
              width: Dimensions.w100,
              child: marketIcon(
                  onTap: onTap2,
                  iconColor: iconColor2,
                  text: "RESULTHISTORY2".tr,
                  iconData: ConstantImage.resultHistoryIcons),
            ),
          ),
          Expanded(
            child: SizedBox(
              // color: Colors.amber,
              width: Dimensions.w100,
              child: marketIcon(
                onTap: onTap3,
                iconColor: iconColor3,
                text: "CHART2".tr,
                iconData: ConstantImage.chartIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }

  gridColumn(size) {
    return Obx(
      () {
        return controller.normalMarketList.isNotEmpty
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: InkWell(
                      onTap: () {
                        launch(
                          "https://wa.me/+917769826748/?text=hi",
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: Dimensions.h30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: LinearGradient(
                            colors: [AppColors.wpColor1, AppColors.wpColor2],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Image.asset(
                                ConstantImage.whatsaapIcon,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "+91 7769826748",
                              style: CustomTextStyle.textRobotoSansBold.copyWith(color: AppColors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GridView.builder(
                    padding: EdgeInsets.all(Dimensions.h5),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: size.width / 2,
                      mainAxisExtent: size.width / 2.4,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: controller.normalMarketList.length,
                    itemBuilder: (context, index) {
                      MarketData marketData;
                      marketData = controller.normalMarketList[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.h5),
                        child: GestureDetector(
                          onTap: () => marketData.isBidOpenForClose == true
                              ? controller.onTapOfNormalMarket(controller.normalMarketList[index])
                              : null,
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 0.2,
                                  color: AppColors.grey,
                                  blurRadius: 3.5,
                                  offset: const Offset(2, 4),
                                )
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(Dimensions.h10),
                              border: Border.all(color: Colors.red, width: 1),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: Dimensions.h10,
                                ),
                                Text(
                                  "${marketData.openTime ?? " "} | ${marketData.closeTime ?? ""}",
                                  style: CustomTextStyle.textRobotoSansLight.copyWith(fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  controller.normalMarketList[index].market ?? "",
                                  // "MADHUR DAY",
                                  style: CustomTextStyle.textPTsansBold.copyWith(
                                    fontWeight: FontWeight.w800,
                                    fontSize: Dimensions.h14,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    buildResult(
                                        isOpenResult: true,
                                        resultDeclared: marketData.isOpenResultDeclared ?? false,
                                        result: marketData.openResult ?? 0),
                                    buildResult(
                                      isOpenResult: false,
                                      resultDeclared: marketData.isCloseResultDeclared ?? false,
                                      result: marketData.closeResult ?? 0,
                                    )
                                  ],
                                ),
                                playButton(),
                                SizedBox(height: Dimensions.h5),
                                Container(
                                  height: Dimensions.h30,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade400.withOpacity(0.8),
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      marketData.isBidOpenForClose == true ? "Bidding is Open" : "Bidding is Closed",
                                      style: marketData.isBidOpenForClose == true
                                          ? CustomTextStyle.textRobotoMedium.copyWith(
                                              color: AppColors.greenShade,
                                              fontWeight: FontWeight.w400,
                                            )
                                          : CustomTextStyle.textRobotoMedium.copyWith(
                                              color: AppColors.redColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              )
            : const Center(child: Text("No Data Found"));
      },
    );
  }

  Container playButton() {
    return Container(
      height: Dimensions.h25,
      width: Dimensions.w80,
      decoration: BoxDecoration(color: AppColors.blueButton, borderRadius: BorderRadius.circular(25)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FittedBox(
            child: Padding(
              padding: EdgeInsets.only(left: Dimensions.w15, bottom: 2),
              child: Text("PLAY2".tr, style: CustomTextStyle.textRobotoSlabMedium),
            ),
          ),
          FittedBox(
            child: Padding(
              padding: const EdgeInsets.only(right: 3.0),
              child: Icon(
                Icons.play_circle_fill,
                color: AppColors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  banner() {
    return Obx(() => CarouselSlider(
          items: controller.bennerData.map((element) {
            return Builder(
              builder: (context) {
                return imagewidget("${element.banner}");
              },
            );
          }).toList(),
          options: CarouselOptions(
            height: Dimensions.h90,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 15 / 4,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 600),
            viewportFraction: 1,
          ),
        ));
  }

  imagewidget(String imageText) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.h7),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageText),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  /// starline markets ........
  gridColumnForStarLine(size) {
    return Obx(() {
      return GridView.builder(
        padding: EdgeInsets.all(Dimensions.h5),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: size.width / 2,
            mainAxisExtent: size.width / 2.5,
            crossAxisSpacing: 7,
            mainAxisSpacing: Dimensions.h10),
        itemCount: controller.starLineMarketList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              controller.starLineMarketList[index].isBidOpen == true
                  ? controller.onTapOfStarlineMarket(controller.starLineMarketList[index])
                  : null;
            },
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 0.2,
                    color: AppColors.grey,
                    blurRadius: 2.5,
                    offset: const Offset(2, 3),
                  )
                ],
                color: AppColors.white,
                borderRadius: BorderRadius.circular(Dimensions.h10),
                border: Border.all(color: Colors.red, width: 1),
              ),
              child: Column(
                //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: Dimensions.h5),
                  SizedBox(height: Dimensions.h5),
                  Text(
                    controller.starLineMarketList.elementAt(index).time ?? "",
                    style: CustomTextStyle.textRobotoSansMedium.copyWith(
                      color: AppColors.black,
                      fontSize: Dimensions.h15,
                    ),
                  ),
                  SizedBox(height: Dimensions.h5),
                  buildResult(
                    isOpenResult: true,
                    resultDeclared: controller.starLineMarketList[index].isResultDeclared ?? false,
                    result: controller.starLineMarketList[index].result ?? 0,
                  ),
                  SizedBox(height: Dimensions.h5),
                  playButton(),
                  Expanded(child: SizedBox(height: Dimensions.h5)),
                  Container(
                    height: Dimensions.h30,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400.withOpacity(0.8),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        controller.starLineMarketList[index].isBidOpen == true
                            ? "Bidding is Open"
                            : "Bidding is Closed",
                        style: controller.starLineMarketList[index].isBidOpen == true
                            ? CustomTextStyle.textPTsansMedium.copyWith(color: AppColors.greenShade)
                            : CustomTextStyle.textPTsansMedium.copyWith(color: AppColors.redColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  bidHistoryList() {
    return Obx(
      () => controller.marketHistoryList.isEmpty
          ? Center(
              child: Text(
                "NOBIDHISTORY".tr,
                style: CustomTextStyle.textRobotoSansMedium.copyWith(
                  fontSize: Dimensions.h16,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey.shade600,
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: Dimensions.h10),
              itemCount: controller.marketHistoryList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return listveiwTransaction(
                  isWin: controller.marketHistoryList[index].isWin ?? false,
                  requestId: controller.marketHistoryList[index].requestId ?? "",
                  bidTime: CommonUtils().convertUtcToIstFormatStringToDDMMYYYYHHMMA(
                      controller.marketHistoryList[index].bidTime.toString()),
                  ballance: " ${controller.marketHistoryList[index].balance.toString()} ",
                  coins: controller.marketHistoryList[index].coins.toString(),
                  bidNumber:
                      "${controller.marketHistoryList[index].gameMode ?? ""} ${controller.marketHistoryList[index].bidNo ?? ""}",
                  marketName: controller.marketHistoryList[index].marketName ?? "00:00 AM",
                );
              },
            ),
    );
  }

  bidHistory(context) {
    return Column(
      children: [
        SizedBox(height: Dimensions.h11),
        SizedBox(
          height: 45,
          child: TextField(
            style: CustomTextStyle.textRobotoSansMedium.copyWith(color: AppColors.appbarColor),
            controller: controller.dateinput,
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
                  initialDate: controller.startEndDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101));
              if (pickedDate != null) {
                String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                String formattedDate2 = DateFormat('dd-MM-yyyy').format(pickedDate);
                controller.dateinput.text = formattedDate2;

                controller.getMarketBidsByUserId(
                  lazyLoad: false,
                  startDate: formattedDate,
                  endDate: formattedDate,
                );
                controller.startEndDate = pickedDate;
              }
            },
          ),
        ),
        SizedBox(height: Dimensions.h11),
        bidHistoryList(),
      ],
    );
  }

  resultHistory(context) {
    return Obx(
      () => Column(
        children: [
          SizedBox(height: Dimensions.h11),
          SizedBox(
            height: 45,
            child: TextField(
              controller: controller.dateinputForResultHistory,
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
                    initialDate: controller.bidHistotyDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101));

                if (pickedDate != null) {
                  String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                  String formattedDate2 = DateFormat('dd-MM-yyyy').format(pickedDate);
                  controller.dateinputForResultHistory.text = formattedDate2;

                  controller.getDailyStarLineMarkets(formattedDate, formattedDate);
                  controller.bidHistotyDate = pickedDate;
                }
              },
            ),
          ),
          SizedBox(height: Dimensions.h11),
          controller.marketListForResult.isNotEmpty
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.marketListForResult.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        height: Dimensions.h50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.white,
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 0.2,
                              color: AppColors.grey,
                              blurRadius: 1,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: Dimensions.w20),
                            SizedBox(width: Dimensions.w35, child: SvgPicture.asset(ConstantImage.stopWatchIcon)),
                            // Icon(Icons.watch, color: AppColors.black),
                            SizedBox(width: Dimensions.w10),
                            Text(
                              controller.marketListForResult.value[index].time ?? "00:00 AM",
                              style: CustomTextStyle.textRobotoSansBold.copyWith(fontSize: Dimensions.h15),
                            ),
                            Expanded(
                              child: SizedBox(width: Dimensions.w10),
                            ),
                            controller.getResult(
                                      controller.marketListForResult.value[index].isResultDeclared ?? false,
                                      controller.marketListForResult[index].result ?? 0,
                                    ) !=
                                    "***-*"
                                ? Padding(
                                    padding: EdgeInsets.only(right: Dimensions.h50),
                                    child: Text(
                                      controller.getResult(
                                        controller.marketListForResult.value[index].isResultDeclared ?? false,
                                        controller.marketListForResult[index].result ?? 0,
                                      ),
                                      style: CustomTextStyle.textRobotoSansBold.copyWith(fontSize: Dimensions.h15),
                                    ),
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(right: Dimensions.h50),
                                    child: SvgPicture.asset(
                                      ConstantImage.openStarsSvg,
                                      width: Dimensions.w60,
                                    ),
                                  )
                          ],
                        ),
                      ),
                    );
                  },
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
    );
  }

  dateColumn() {
    return Obx(() => DataTable(
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
                  decoration: BoxDecoration(color: AppColors.appbarColor, border: Border.all(color: AppColors.white)),
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
            controller.starlineChartDateAndTime.length,
            // 10,
            (index) {
              return DataRow(
                cells: [
                  DataCell(
                    Center(
                      child: Text(
                        controller.starlineChartDateAndTime[index].date ?? "",
                        //"2023-08-13",
                        textAlign: TextAlign.center,
                        style: CustomTextStyle.textRobotoSansMedium,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ));
  }

  timeColumn() {
    return SingleChildScrollView(
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
            controller.starlineChartDateAndTime.length,
            (i) {
              return DataRow(
                  color: MaterialStateColor.resolveWith(
                    (states) => Colors.white,
                  ),
                  cells: List<DataCell>.generate(
                    controller.starlineChartTime.length,
                    //13,
                    (j) {
                      final time = controller.starlineChartTime[j];
                      final timeData = controller.starlineChartDateAndTime[i].time?.firstWhere(
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
                                      timeData!.result != null ? controller.getResult2(true, timeData.result) : "***",
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
                                    timeData.result != null ? controller.getResult3(true, timeData.result) : "*",
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
            controller.starlineChartTime.length,
            //10,
            (index) {
              return DataColumn(
                label: Container(
                  height: Dimensions.h30,
                  width: Dimensions.w100,
                  decoration: BoxDecoration(color: AppColors.appbarColor, border: Border.all(color: AppColors.white)),
                  child: Center(
                    child: Text(
                      controller.starlineChartTime[index].marketName ?? "",
                      // "11:00 AM",
                      textAlign: TextAlign.center,
                      style: CustomTextStyle.textRobotoSansMedium.copyWith(color: AppColors.white),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  notificationAbout(BuildContext context) {
    return Stack(
      children: [
        Material(
          color: AppColors.black.withOpacity(0.4),
          child: Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: Dimensions.h95, bottom: 60.0),
            child: Container(
              color: AppColors.white,
              width: double.infinity,
              child: Obx(
                () => ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.notificationData.length,
                  itemBuilder: (context, index) {
                    return notificationWidget(
                      notifiactionHeder: controller.notificationData[index].title ?? "",
                      notifiactionSubTitle: controller.notificationData[index].description ?? "",
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        Material(
          color: AppColors.transparent,
          child: Padding(
            padding: EdgeInsets.only(top: Dimensions.h87, bottom: 8.0),
            child: Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  controller.resetNotificationCount();
                  controller.getNotifiactionCount.refresh();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(Dimensions.r10),
                  ),
                  child: Icon(Icons.close, color: AppColors.redColor),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget notificationWidget({required String notifiactionHeder, required String notifiactionSubTitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              spreadRadius: 1,
              color: AppColors.grey.withOpacity(0.5),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.h8),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Dimensions.h5),
              Text(
                notifiactionHeder,
                style: CustomTextStyle.textRobotoSansBold.copyWith(
                  color: AppColors.black,
                  fontSize: Dimensions.h14,
                ),
              ),
              SizedBox(height: Dimensions.h5),
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  child: Text(
                    notifiactionSubTitle,
                    textAlign: TextAlign.start,
                    style: CustomTextStyle.textRobotoSansLight.copyWith(
                      color: AppColors.black,
                      fontSize: Dimensions.h13,
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
}
