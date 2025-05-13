import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:spllive/components/common_appbar.dart';
import 'package:spllive/controller/starline_market_controller.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/constant_image.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/routes/app_routes_name.dart';
import 'package:spllive/screens/new_ui/bottom_bar_screens/starline%20market/starline_chart.dart';
import 'package:spllive/screens/new_ui/bottom_bar_screens/starline%20market/starline_result_history.dart';

class StarlineDailyMarketData extends StatefulWidget {
  const StarlineDailyMarketData({super.key});

  @override
  State<StarlineDailyMarketData> createState() => _StarlineDailyMarketDataState();
}

class _StarlineDailyMarketDataState extends State<StarlineDailyMarketData> {
  final starlineCon = Get.put<StarlineMarketController>(StarlineMarketController());

  @override
  void initState() {
    super.initState();

    starlineCon.getStarlineBanner();
    starlineCon.getUserData();
    starlineCon.getDailyStarLineMarkets();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) async {
        if (value) {
          return;
        }
        print("************************************************");
        for (var e in starlineCon.starlineButtonList) {
          e.isSelected.value = false;
        }
        if (starlineCon.selectedIndex.value == null) {
          Get.offAllNamed(AppRoutName.dashBoardPage);
        }
        starlineCon.selectedFilterMarketList.value = [];
        starlineCon.filterMarketList.forEach((e) => e.isSelected.value = false);
        starlineCon.isSelectedWinStatusIndex.value = null;
        starlineCon.winStatusList.forEach((e) => e.isSelected.value = false);
        // starlineCon.getMarketBidsByUserId();
        // starlineCon.getStarlineBidsByUserId();
        starlineCon.selectedIndex.value = null;
      },
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            starlineCon.getStarlineBanner();
            starlineCon.getDailyStarLineMarkets();
          },
          child: Column(
            children: [
              CommonAppBar(
                title: "SPL Starline",
                leading: GestureDetector(
                    onTap: () {
                      starlineCon.selectedIndex.value = null;
                      for (var e in starlineCon.starlineButtonList) {
                        e.isSelected.value = false;
                      }
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back, size: 30)),
                // walletBalance: "${c.walletBalance ?? " "}",
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // (Result History Tap and back to Banner Not show )
                      // starlineCon.selectedIndex.value != null
                      //                               ? Container()
                      //                               :
                      Obx(() => starlineCon.bannerLoad.value
                              ? Center(child: CircularProgressIndicator(color: AppColors.appbarColor))
                              : Container(
                                  width: double.infinity,
                                  height: 120,
                                  child: Image(
                                    image: NetworkImage(starlineCon.bannerImage.value),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Center(
                                      child: Icon(
                                        Icons.error_outline,
                                        color: AppColors.appbarColor,
                                        size: 35,
                                      ),
                                    ),
                                  ),
                                )
                          // : CarouselSlider(
                          //     items: homeCon.bannerData.map((element) {
                          //       return Builder(
                          //         builder: (context) {
                          //           return Container();
                          //           // return CachedNetworkImage(
                          //           //   imageUrl: element.banner ?? "",
                          //           //   placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          //           //   errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                          //           // );
                          //         },
                          //       );
                          //     }).toList(),
                          //     options: CarouselOptions(
                          //       height: Dimensions.h90,
                          //       enlargeCenterPage: true,
                          //       autoPlay: true,
                          //       aspectRatio: 15 / 4,
                          //       autoPlayCurve: Curves.fastOutSlowIn,
                          //       enableInfiniteScroll: true,
                          //       autoPlayAnimationDuration: const Duration(milliseconds: 600),
                          //       viewportFraction: 1,
                          //     ),
                          //   ),
                          ),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              children: starlineCon.starlineButtonList.map((e) {
                                print("hhhh ${e.isSelected.value}");
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      for (var e in starlineCon.starlineButtonList) {
                                        e.isSelected.value = false;
                                      }
                                      e.isSelected.value = true;
                                      if (e.isSelected.value) {
                                        // if (e.name?.toLowerCase() == "bid history") {
                                        //   starlineCon.selectedIndex.value = 0;
                                        // }
                                        if (e.name?.toLowerCase() == "result history") {
                                          starlineCon.selectedIndex.value = 0;
                                          Get.to(() => StarlineResultHistory());
                                        }
                                        if (e.name?.toLowerCase() == "chart") {
                                          starlineCon.selectedIndex.value = 1;
                                          Get.to(() => StarlineChart());
                                        }
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          border: Border.all(
                                              // color: e.isSelected.value == true ? AppColors.appbarColor : AppColors.black),
                                              color: AppColors.appbarColor),
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              spreadRadius: 0.8722222447395325,
                                              blurRadius: 6.97777795791626,
                                              offset: const Offset(0, 0),
                                              color: AppColors.black.withOpacity(0.25),
                                            )
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              e.image ?? "",
                                              height: Dimensions.h22,
                                              width: Dimensions.w22,
                                              // color: AppColors.appbarColor,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              e.name ?? "",
                                              style: CustomTextStyle.textPTsansMedium.copyWith(
                                                  color: AppColors.appbarColor,
                                                  letterSpacing: 1,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: e.name?.toLowerCase() == "result history"
                                                      ? MediaQuery.of(context).size.width > 360
                                                          ? Dimensions.h10
                                                          : 10.5
                                                      : Dimensions.h10),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Obx(
                            () => GridView.builder(
                              padding: EdgeInsets.all(Dimensions.h5),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: Get.width / 2,
                                mainAxisExtent: Get.width / 2.5,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 10,
                              ),
                              // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              //     maxCrossAxisExtent: Get.width / 2,
                              //     mainAxisExtent: Get.width / 2.5,
                              //     crossAxisSpacing: 7,
                              //     mainAxisSpacing: Dimensions.h10),
                              itemCount: starlineCon.starLineMarketList.length ?? 0,
                              itemBuilder: (context, i) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: Dimensions.h5),
                                  child: InkWell(
                                    onTap: () {
                                      if (starlineCon.starLineMarketList[i].isBidOpen ?? false) {
                                        if (starlineCon.starLineMarketList[i].isBidOpen ?? false) {
                                          Get.toNamed(AppRoutName.starLineGameModesPage, arguments: starlineCon.starLineMarketList[i]);
                                        } else {
                                          AppUtils.showErrorSnackBar(bodyText: "Bidding is Closed!!!!");
                                        }
                                      }
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
                                        borderRadius: BorderRadius.circular(Dimensions.r10),
                                        border: Border.all(color: Colors.red, width: 1),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(height: Dimensions.h8),
                                          Text(
                                            starlineCon.starLineMarketList[i].time ?? "",
                                            style: CustomTextStyle.textRobotoMedium.copyWith(
                                              color: AppColors.black,
                                              fontSize: Dimensions.h15,
                                            ),
                                          ),
                                          SizedBox(height: Dimensions.h5),
                                          buildResult(
                                            isOpenResult: true,
                                            resultDeclared: starlineCon.starLineMarketList[i].isResultDeclared ?? false,
                                            result: starlineCon.starLineMarketList[i].result ?? 0,
                                          ),
                                          SizedBox(height: Dimensions.h5),
                                          Container(
                                            height: Dimensions.h25,
                                            width: Dimensions.w80,
                                            decoration: BoxDecoration(color: AppColors.blueButton, borderRadius: BorderRadius.circular(25)),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                FittedBox(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(left: Dimensions.w15, bottom: 2),
                                                    child: Text("PLAY2".tr,
                                                        style: CustomTextStyle.textRobotoSlabMedium.copyWith(
                                                          color: AppColors.white,
                                                          fontWeight: FontWeight.bold,
                                                        )),
                                                  ),
                                                ),
                                                FittedBox(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 3.0),
                                                    child: Icon(
                                                      Icons.play_circle_fill,
                                                      color: AppColors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(child: SizedBox(height: Dimensions.h2)),
                                          Container(
                                            height: Dimensions.h28,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade400.withOpacity(0.8),
                                              borderRadius: const BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                starlineCon.starLineMarketList[i].isBidOpen ?? false ? "Bidding is Open" : "Bidding is Closed",
                                                style: starlineCon.starLineMarketList[i].isBidOpen ?? false
                                                    ? CustomTextStyle.textRobotoMedium
                                                        .copyWith(color: AppColors.greenShade, fontWeight: FontWeight.w400)
                                                    : CustomTextStyle.textRobotoMedium
                                                        .copyWith(color: AppColors.redColor, fontWeight: FontWeight.w400),
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
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  currentWidget(index) {
    switch (index) {
      /*case 0:
        return const StarlineBidHistory();*/
      case 0:
        return const StarlineResultHistory();
      case 1:
        Get.to(() => StarlineChart());
    }
  }
}
