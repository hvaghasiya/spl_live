import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spllive/controller/starline_market_controller.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/common_utils.dart';
import 'package:spllive/helper_files/constant_image.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';

import '../../../../components/common_appbar.dart';
import '../../../../helper_files/ui_utils.dart';

class StarlineBidHistory extends StatefulWidget {
  const StarlineBidHistory({super.key});

  @override
  State<StarlineBidHistory> createState() => _StarlineBidHistoryState();
}

class _StarlineBidHistoryState extends State<StarlineBidHistory> {
  final starlineCon = Get.find<StarlineMarketController>();

  @override
  void initState() {
    super.initState();
    print("fsdjfgsdkjfhsdkf");
    SchedulerBinding.instance.addPostFrameCallback((_) {
      starlineCon.getMarketBidsByUserId();
      starlineCon.getDailyStarLineMarkets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) {
            return;
          }
          starlineCon.restStartLineBidHistory();
        },
        child: Scaffold(
            appBar: CommonAppBar(
              title: "Starline Bid History",
              leading: GestureDetector(
                  onTap: () {
                    starlineCon.restStartLineBidHistory();
                  },
                  child: Icon(Icons.arrow_back, size: 30)),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => {
                      starlineCon.date = DateFormat('yyyy-MM-dd').format(DateTime.now()),
                      Get.dialog(
                        barrierDismissible: false,
                        ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: Get.width, minWidth: Get.width - 30),
                          child: Dialog(
                            insetPadding: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(
                                      color: AppColors.appbarColor,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0))),
                                  child: Text(
                                    "SET FILTER",
                                    textAlign: TextAlign.center,
                                    style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    style: CustomTextStyle.textRobotoSansMedium.copyWith(color: AppColors.appbarColor),
                                    controller: starlineCon.dateinput,
                                    decoration: InputDecoration(
                                      hintText: DateFormat('dd-MM-yyyy').format(DateTime.now()).toString(),
                                      hintStyle: CustomTextStyle.textRobotoSansMedium.copyWith(
                                        color: AppColors.appbarColor,
                                      ),
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: Dimensions.w8, vertical: Dimensions.h10),
                                      filled: true,
                                      fillColor: AppColors.grey.withOpacity(0.15),
                                      prefixIcon: Icon(Icons.calendar_month_sharp, color: AppColors.appbarColor),
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: starlineCon.startEndDate,
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime.now());
                                      if (pickedDate != null) {
                                        starlineCon.startEndDate = pickedDate;
                                        starlineCon.date = DateFormat('yyyy-MM-dd').format(pickedDate);
                                        starlineCon.dateinput.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                                      }
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    // height: Get.height / 1.2,
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                    decoration: BoxDecoration(color: AppColors.white),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Winning Status",
                                            textAlign: TextAlign.center,
                                            style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                              color: AppColors.black,
                                              fontSize: 20,
                                            ),
                                          ),
                                          Obx(
                                            () => Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: starlineCon.winStatusList
                                                  .map(
                                                    (e) => InkWell(
                                                      onTap: () {
                                                        starlineCon.winStatusList
                                                            .forEach((j) => j.isSelected.value = false);
                                                        e.isSelected.value = !e.isSelected.value;
                                                        if (e.isSelected.value) {
                                                          starlineCon.isSelectedWinStatusIndex.value = e.id;
                                                        } else {
                                                          starlineCon.isSelectedWinStatusIndex.value = null;
                                                        }
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Checkbox(
                                                            activeColor: AppColors.appbarColor,
                                                            value: e.isSelected.value,
                                                            onChanged: (bool? value) {
                                                              starlineCon.winStatusList
                                                                  .forEach((e) => e.isSelected.value = false);
                                                              e.isSelected.value = value ?? false;
                                                              if (e.isSelected.value) {
                                                                starlineCon.isSelectedWinStatusIndex.value = e.id;
                                                              } else {
                                                                starlineCon.isSelectedWinStatusIndex.value = null;
                                                              }
                                                            },
                                                          ),
                                                          Text(
                                                            e.name ?? "",
                                                            style: CustomTextStyle.textRobotoSansMedium
                                                                .copyWith(color: AppColors.black),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          ),
                                          Text(
                                            "Markets",
                                            textAlign: TextAlign.center,
                                            style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                              color: AppColors.black,
                                              fontSize: 20,
                                            ),
                                          ),
                                          starlineCon.filterMarketList.isEmpty
                                              ? const Text("No market find")
                                              : Obx(
                                                  () => ScrollbarTheme(
                                                    data: ScrollbarThemeData(
                                                      thumbColor:
                                                          MaterialStateProperty.all<Color>(AppColors.appbarColor),
                                                      trackColor:
                                                          MaterialStateProperty.all<Color>(AppColors.appbarColor),
                                                    ),
                                                    child: Scrollbar(
                                                      trackVisibility: true,
                                                      thickness: 5,
                                                      radius: const Radius.circular(20),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(10.0),
                                                        child: ListView(
                                                          shrinkWrap: true,
                                                          physics: const BouncingScrollPhysics(),
                                                          children: starlineCon.filterMarketList
                                                              .map(
                                                                (e) => Padding(
                                                                  padding: const EdgeInsets.symmetric(
                                                                      vertical: 5.0, horizontal: 5.0),
                                                                  child: InkWell(
                                                                    onTap: () {
                                                                      e.isSelected.value = !e.isSelected.value;
                                                                      if (e.isSelected.value) {
                                                                        starlineCon.selectedFilterMarketList
                                                                            .add(e.id ?? 0);
                                                                      } else {
                                                                        starlineCon.selectedFilterMarketList.clear();
                                                                      }
                                                                    },
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(10),
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                              blurRadius: 6.97777795791626,
                                                                              spreadRadius: 0.8722222447395325,
                                                                              offset: const Offset(0, 0),
                                                                              color: AppColors.black.withOpacity(0.25))
                                                                        ],
                                                                        color: AppColors.white,
                                                                      ),
                                                                      child: Row(
                                                                        children: [
                                                                          Checkbox(
                                                                            activeColor: AppColors.appbarColor,
                                                                            value: e.isSelected.value,
                                                                            onChanged: (bool? value) {
                                                                              e.isSelected.value = value ?? false;
                                                                              if (e.isSelected.value) {
                                                                                starlineCon.selectedFilterMarketList
                                                                                    .add(e.id ?? 0);
                                                                              } else {
                                                                                starlineCon.selectedFilterMarketList
                                                                                    .clear();
                                                                              }
                                                                            },
                                                                          ),
                                                                          Text(
                                                                            e.name ?? "",
                                                                            style: CustomTextStyle.textRobotoSansMedium
                                                                                .copyWith(color: AppColors.black),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                              .toList(),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  if (starlineCon.isSelectedWinStatusIndex.value != null ||
                                                      starlineCon.selectedFilterMarketList.isNotEmpty) {
                                                    starlineCon.getMarketBidsByUserId();
                                                  } else {
                                                    AppUtils.showErrorSnackBar(bodyText: "Please select any filter");
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColors.appbarColor,
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  padding: const EdgeInsets.all(10),
                                                  child: Center(
                                                    child: Text(
                                                      "SUBMIT",
                                                      style: CustomTextStyle.textRobotoSansMedium
                                                          .copyWith(color: AppColors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  starlineCon.restStartLineBidHistory();
                                                  // starlineCon.selectedFilterMarketList.value = [];
                                                  // starlineCon.filterMarketList
                                                  //     .forEach((e) => e.isSelected.value = false);
                                                  // starlineCon.isSelectedWinStatusIndex.value = null;
                                                  // starlineCon.winStatusList.forEach((e) => e.isSelected.value = false);
                                                  // Get.back();
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColors.appbarColor,
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  padding: const EdgeInsets.all(10),
                                                  child: Center(
                                                    child: Text(
                                                      "CANCEL",
                                                      style: CustomTextStyle.textRobotoSansMedium
                                                          .copyWith(color: AppColors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20)
                              ],
                            ),
                          ),
                        ),
                      )
                    },
                    child: Obx(
                      () => starlineCon.selectedFilterMarketList.isNotEmpty ||
                              starlineCon.isSelectedWinStatusIndex.value != null
                          ? InkWell(
                              onTap: () {
                                starlineCon.selectedFilterMarketList.value = [];
                                starlineCon.filterMarketList.forEach((e) => e.isSelected.value = false);
                                starlineCon.isSelectedWinStatusIndex.value = null;
                                starlineCon.winStatusList.forEach((e) => e.isSelected.value = false);
                                starlineCon.date = null;
                                starlineCon.dateinput.clear();
                                starlineCon.getMarketBidsByUserId();
                              },
                              child: Stack(
                                children: [
                                  SvgPicture.asset(ConstantImage.filter),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.redColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: AppColors.white,
                                      size: 10,
                                    ),
                                  )
                                ],
                              ),
                            )
                          : SvgPicture.asset(ConstantImage.filter),
                    ),
                  ),
                )
              ],
            ),
            body: Obx(
              () => starlineCon.isStarlineBidHistory.value == false
                  ? starlineCon.marketHistoryList.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "NOBIDHISTORY".tr,
                              style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                fontSize: Dimensions.h16,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: Dimensions.h5),
                            Obx(
                              () => Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                  itemCount: starlineCon.marketHistoryList.length,
                                  shrinkWrap: true,
                                  // physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return listveiwTransaction(
                                      isWin: starlineCon.marketHistoryList[index].isWin ?? false,
                                      requestId: starlineCon.marketHistoryList[index].requestId ?? "",
                                      // bidTime: DateFormat('dd/MM/yyyy hh:mm:ss a')
                                      //     .format(DateTime.parse(starlineCon.marketHistoryList[index].bidTime.toString()))
                                      //     .toString(),
                                      bidTime: CommonUtils().convertUtcToIstFormatStringToDDMMYYYYHHMMA(
                                          starlineCon.marketHistoryList[index].bidTime.toString()),
                                      ballance: " ${starlineCon.marketHistoryList[index].balance.toString()} ",
                                      coins: starlineCon.marketHistoryList[index].coins.toString(),
                                      bidNumber:
                                          "${starlineCon.marketHistoryList[index].gameMode ?? ""}: ${starlineCon.marketHistoryList[index].bidNo ?? ""}",
                                      marketName: starlineCon.marketHistoryList[index].marketName ?? "00:00 AM",
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
                        )
                  : Expanded(child: Center(child: CircularProgressIndicator(color: AppColors.appBlueColor))),
            )),
      ),
    );
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
              spreadRadius: 0.4,
              color: AppColors.grey,
              blurRadius: 2,
              offset: const Offset(1, 1),
            ),
          ],
          border: Border.all(width: 0.87),
          color: isWin == true ? AppColors.greenAccent : AppColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Dimensions.h10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.h10,
              ),
              child: Row(
                children: [
                  Text(
                    marketName,
                    style: CustomTextStyle.textRobotoMedium.copyWith(fontSize: Dimensions.h14),
                  ),
                  const Expanded(child: SizedBox()),
                  SizedBox(width: Dimensions.w5),
                  SizedBox(width: Dimensions.w5),
                  Text("Points : ", style: CustomTextStyle.textRobotoMedium),
                  Text(
                    coins,
                    style: CustomTextStyle.textRobotoSansLight.copyWith(
                      fontSize: Dimensions.h14,
                      color: AppColors.appBlueColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Dimensions.h10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.h10,
              ),
              child: Row(
                children: [
                  Text(
                    bidNumber,
                    style: CustomTextStyle.textRobotoSansLight.copyWith(fontSize: Dimensions.h14),
                    textAlign: TextAlign.left,
                  ),
                  const Expanded(child: SizedBox()),
                  // SizedBox(width: Dimensions.w5),
                  // SizedBox(width: Dimensions.w5),
                  // SvgPicture.asset(
                  //   ConstantImage.walletAppbar,
                  //   height: Dimensions.h13,
                  // ),
                  // Text(
                  //   ballance,
                  //   style: CustomTextStyle.textRobotoSansLight.copyWith(
                  //     fontSize: Dimensions.h14,
                  //     color: AppColors.black,
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: Dimensions.h10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.h10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bid Id  : $requestId",
                    style:
                        CustomTextStyle.textRobotoSansLight.copyWith(fontSize: Dimensions.h12, color: AppColors.black),
                  ),
                  const Expanded(child: SizedBox()),
                  SizedBox(width: Dimensions.w5),
                  SizedBox(width: Dimensions.w5),
                  SvgPicture.asset(
                    ConstantImage.walletAppbar,
                    height: Dimensions.h15,
                  ),
                  Flexible(
                    child: Text(
                      ballance,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyle.textRobotoSansLight.copyWith(
                        fontSize: Dimensions.h14,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Dimensions.h10,
            ),
            Container(
              height: Dimensions.h30,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.greyShade.withOpacity(0.2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(Dimensions.r8),
                  bottomRight: Radius.circular(Dimensions.r8),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(Dimensions.h8),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      ConstantImage.clockSvg,
                      height: Dimensions.h14,
                    ),
                    SizedBox(width: Dimensions.w8),
                    Text(bidTime, style: CustomTextStyle.textRobotoSansBold),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
