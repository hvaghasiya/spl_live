import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../components/common_appbar.dart';
import '../../../controller/home_controller.dart';
import '../../../helper_files/app_colors.dart';
import '../../../helper_files/common_utils.dart';
import '../../../helper_files/constant_image.dart';
import '../../../helper_files/custom_text_style.dart';
import '../../../helper_files/dimentions.dart';
import '../../../helper_files/ui_utils.dart';

class BidHistoryNew extends StatefulWidget {
  const BidHistoryNew({super.key});

  @override
  State<BidHistoryNew> createState() => _BidHistoryNewState();
}

class _BidHistoryNewState extends State<BidHistoryNew> {
  final homeCon = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    print("fsdkfjhsdkfjdhf");

    SchedulerBinding.instance.addPostFrameCallback((_) {
      homeCon.bidsHistoryByUserId();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        homeCon.resetAllBidHistoryData();
      },
      canPop: false,
      child: Scaffold(
        body: Column(
          children: [
            CommonAppBar(
              title: "Bid History",
              titleTextStyle: CustomTextStyle.textRobotoSansMedium.copyWith(
                fontSize: Dimensions.h17,
                color: AppColors.white,
              ),
              leading: GestureDetector(
                  onTap: () {
                    homeCon.resetAllBidHistoryData();
                  },
                  child: Icon(Icons.arrow_back, size: 28)),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => {
                      // homeCon.date = DateFormat('yyyy-MM-dd').format(DateTime.now()),
                      Get.dialog(
                        barrierDismissible: false,
                        ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: Get.height, minWidth: Get.width - 30),
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
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0))),
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
                                  padding: const EdgeInsets.all(4.0),
                                  child: TextField(
                                    controller: homeCon.dateInputForResultHistory,
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
                                      print(homeCon.date);
                                      print("fsdlfkjsdfklj");
                                      DateTime? pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: homeCon.date != null ? DateTime.parse(homeCon.date!) : DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime.now());

                                      if (pickedDate != null) {
                                        homeCon.bidHistoryDate = pickedDate;

                                        homeCon.dateInputForResultHistory.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                                        homeCon.date = DateFormat('yyyy-MM-dd').format(pickedDate);
                                      }
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(color: AppColors.white),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Game Type",
                                            textAlign: TextAlign.center,
                                            style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                              color: AppColors.black,
                                              fontSize: 20,
                                            ),
                                          ),
                                          Obx(
                                            () => Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: homeCon.gameTypeList
                                                  .map(
                                                    (e) => InkWell(
                                                      onTap: () {
                                                        homeCon.gameTypeList.forEach((e) => e.isSelected.value = false);
                                                        e.isSelected.value = !e.isSelected.value;
                                                        if (e.isSelected.value) {
                                                          homeCon.isSelectedGameIndex.value = e.id;
                                                        } else {
                                                          homeCon.isSelectedGameIndex.value = null;
                                                        }
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Checkbox(
                                                            activeColor: AppColors.appbarColor,
                                                            value: e.isSelected.value,
                                                            onChanged: (bool? value) {
                                                              homeCon.gameTypeList.forEach((e) => e.isSelected.value = false);
                                                              e.isSelected.value = value ?? false;
                                                              if (e.isSelected.value) {
                                                                homeCon.isSelectedGameIndex.value = e.id;
                                                              } else {
                                                                homeCon.isSelectedGameIndex.value = null;
                                                              }
                                                            },
                                                          ),
                                                          Text(
                                                            e.name ?? "",
                                                            style: CustomTextStyle.textRobotoSansMedium.copyWith(color: AppColors.black),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          ),
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
                                              children: homeCon.winStatusList
                                                  .map(
                                                    (e) => InkWell(
                                                      onTap: () {
                                                        homeCon.winStatusList.forEach((e) => e.isSelected.value = false);
                                                        e.isSelected.value = !e.isSelected.value;
                                                        if (e.isSelected.value) {
                                                          homeCon.isSelectedWinStatusIndex.value = e.id;
                                                        } else {
                                                          homeCon.isSelectedWinStatusIndex.value = null;
                                                        }
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Checkbox(
                                                            activeColor: AppColors.appbarColor,
                                                            value: e.isSelected.value,
                                                            onChanged: (bool? value) {
                                                              homeCon.winStatusList.forEach((e) => e.isSelected.value = false);
                                                              e.isSelected.value = value ?? false;
                                                              if (e.isSelected.value) {
                                                                homeCon.isSelectedWinStatusIndex.value = e.id;
                                                              } else {
                                                                homeCon.isSelectedWinStatusIndex.value = null;
                                                              }
                                                            },
                                                          ),
                                                          Text(
                                                            e.name ?? "",
                                                            style: CustomTextStyle.textRobotoSansMedium.copyWith(color: AppColors.black),
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
                                          homeCon.filterMarketList.isEmpty
                                              ? const Text("No market find")
                                              : Obx(
                                                  () => ScrollbarTheme(
                                                    data: ScrollbarThemeData(
                                                      thumbColor: MaterialStateProperty.all<Color>(AppColors.appbarColor),
                                                      trackColor: MaterialStateProperty.all<Color>(AppColors.appbarColor),
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
                                                          children: homeCon.filterMarketList
                                                              .map(
                                                                (e) => Padding(
                                                                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
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
                                                                    child: InkWell(
                                                                      onTap: () {
                                                                        e.isSelected.value = !e.isSelected.value;
                                                                        if (e.isSelected.value) {
                                                                          homeCon.selectedFilterMarketList.add(e.id ?? 0);
                                                                        } else {
                                                                          homeCon.selectedFilterMarketList.clear();
                                                                        }
                                                                      },
                                                                      child: Row(
                                                                        children: [
                                                                          Checkbox(
                                                                            activeColor: AppColors.appbarColor,
                                                                            value: e.isSelected.value,
                                                                            onChanged: (bool? value) {
                                                                              e.isSelected.value = value ?? false;
                                                                              if (e.isSelected.value) {
                                                                                homeCon.selectedFilterMarketList.add(e.id ?? 0);
                                                                              } else {
                                                                                homeCon.selectedFilterMarketList.clear();
                                                                              }
                                                                            },
                                                                          ),
                                                                          Text(
                                                                            e.name ?? "",
                                                                            style:
                                                                                CustomTextStyle.textRobotoSansMedium.copyWith(color: AppColors.black),
                                                                          ),
                                                                          SizedBox(
                                                                            height: 5.0,
                                                                          )
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
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  if (homeCon.isSelectedGameIndex.value != null ||
                                                      homeCon.isSelectedWinStatusIndex.value != null ||
                                                      homeCon.selectedFilterMarketList.isNotEmpty) {
                                                    homeCon.marketBidHistoryList.clear();
                                                    homeCon.bidsHistoryByUserId();
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
                                                      style: CustomTextStyle.textRobotoSansMedium.copyWith(color: AppColors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  homeCon.resetAllBidHistoryData();
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
                                                      style: CustomTextStyle.textRobotoSansMedium.copyWith(color: AppColors.white),
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
                      () => homeCon.selectedFilterMarketList.isNotEmpty ||
                              homeCon.isSelectedWinStatusIndex.value != null ||
                              homeCon.isSelectedGameIndex.value != null
                          ? InkWell(
                              onTap: () {
                                homeCon.selectedFilterMarketList.value = [];
                                homeCon.filterMarketList.forEach((e) => e.isSelected.value = false);
                                homeCon.isSelectedWinStatusIndex.value = null;
                                homeCon.isSelectedGameIndex.value = null;
                                homeCon.gameTypeList.forEach((e) => e.isSelected.value = false);
                                homeCon.winStatusList.forEach((e) => e.isSelected.value = false);
                                homeCon.bidsHistoryByUserId();
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
            Expanded(
              child: Obx(
                () => homeCon.isBidHistory.value == false
                    ? homeCon.marketBidHistoryList.isEmpty
                        ? Center(
                            child: Text(
                              "NOHISTORYAVAILABLEFORLAST7DAYS".tr,
                              style: CustomTextStyle.textPTsansMedium.copyWith(
                                fontSize: Dimensions.h13,
                                color: AppColors.black,
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: Dimensions.h10),
                            itemCount: homeCon.marketBidHistoryList.length,
                            itemBuilder: (context, index) {
                              var data = homeCon.marketBidHistoryList[index];
                              return listveiwTransactionNew(
                                requestId: "Bid Id  : ${data.requestId ?? ""}",
                                isWin: data.isWin ?? false,
                                bidNo: data.bidNo.toString(),
                                ballance: data.balance.toString(),
                                coins: data.coins.toString(),
                                closeTime: CommonUtils().formatStringToHHMMA(data.closeTime ?? ""),
                                openTime: CommonUtils().formatStringToHHMMA(data.openTime ?? ""),
                                transactiontype: data.marketName.toString(),
                                timeDate: CommonUtils().convertUtcToIstFormatStringToDDMMYYYYHHMMA(data.bidTime.toString()),
                                marketName: data.transactionType ?? "",
                                gameMode: data.gameMode ?? "",
                                bidType: data.bidType ?? "",
                              );
                            },
                          )
                    : Center(child: CircularProgressIndicator(color: AppColors.appBlueColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget listveiwTransactionNew({
  required String marketName,
  required String openTime,
  required String closeTime,
  required String coins,
  required String ballance,
  required String transactiontype,
  required String timeDate,
  required String gameMode,
  required String bidType,
  required String bidNo,
  required String requestId,
  required bool isWin,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: Dimensions.h5),
    child: InkWell(
      // onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              spreadRadius: 0.4,
              color: AppColors.grey,
              blurRadius: 2,
              offset: const Offset(1, 2),
            )
          ],
          border: Border.all(width: 0.2),
          color: isWin == true ? AppColors.greenAccent : AppColors.white,
          borderRadius: BorderRadius.circular(Dimensions.r8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: Dimensions.h10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.h10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$transactiontype :",
                    style: CustomTextStyle.textRobotoMedium.copyWith(fontSize: Dimensions.h14),
                  ),
                  SizedBox(width: Dimensions.w5),
                  Column(
                    children: [
                      const SizedBox(height: 2),
                      Text(
                        bidNo,
                        style: CustomTextStyle.textRobotoMedium.copyWith(color: AppColors.appbarColor, fontSize: Dimensions.h13),
                      ),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  Row(
                    children: [
                      Text(
                        "Points :",
                        style: CustomTextStyle.textRobotoMedium.copyWith(fontSize: Dimensions.h14),
                      ),
                      Text(
                        " $coins",
                        style: CustomTextStyle.textRobotoMedium.copyWith(fontSize: Dimensions.h14, color: AppColors.appbarColor),
                      ),
                    ],
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    gameMode,
                    style: CustomTextStyle.textRobotoMedium.copyWith(fontSize: Dimensions.h12, fontWeight: FontWeight.w500),
                  ),

                  // Row(
                  //   children: [
                  //     SvgPicture.asset(
                  //       ConstantImage.walletAppbar,
                  //       height: Dimensions.h13,
                  //     ),
                  //     SizedBox(width: Dimensions.w8),
                  //     Text(ballance, style: CustomTextStyle.textRobotoMedium.copyWith(fontSize: Dimensions.h12)),
                  //     SizedBox(height: Dimensions.h8),
                  //   ],
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
                    requestId,
                    style: CustomTextStyle.textRobotoMedium.copyWith(fontSize: Dimensions.h12, fontWeight: FontWeight.w500),
                  ),
                  const Expanded(child: SizedBox()),
                  SvgPicture.asset(
                    ConstantImage.walletAppbar,
                    height: Dimensions.h15,
                  ),
                  SizedBox(width: Dimensions.w8),
                  Flexible(
                    child: Text(ballance,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: CustomTextStyle.textRobotoMedium.copyWith(fontSize: Dimensions.h12, fontWeight: FontWeight.w500)),
                  ),
                  SizedBox(height: Dimensions.h8),
                ],
              ),
            ),
            SizedBox(
              height: Dimensions.h10,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(Dimensions.h8),
              decoration: BoxDecoration(
                color: AppColors.greyShade.withOpacity(0.2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(Dimensions.r8),
                  bottomRight: Radius.circular(Dimensions.r8),
                ),
              ),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    ConstantImage.clockSvg,
                    height: Dimensions.h14,
                  ),
                  SizedBox(width: Dimensions.w8),
                  Expanded(
                    child: Text(
                      timeDate,
                      style: CustomTextStyle.textRobotoMedium,
                    ),
                  ),
                  Text(bidType, style: CustomTextStyle.textRobotoMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
