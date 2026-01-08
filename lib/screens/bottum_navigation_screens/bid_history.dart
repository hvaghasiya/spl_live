import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';


import '../../Custom Controllers/wallet_controller.dart';
import '../../helper_files/app_colors.dart';
import '../../helper_files/common_utils.dart';
import '../../helper_files/constant_image.dart';
import '../../helper_files/custom_text_style.dart';
import '../../helper_files/dimentions.dart';
import '../../helper_files/ui_utils.dart';
import '../home_screen/controller/homepage_controller.dart';
import 'controller/bottum_navigation_controller.dart';

class BidHistory extends StatelessWidget {
  BidHistory({super.key, required this.appbarTitle});
  final String appbarTitle;
  var controller = Get.put(MoreListController());
  var homePageController = Get.put(HomePageController());
  final walletCon = Get.find<WalletController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppUtils().simpleAppbar(
          centerTitle: true,
          appBarTitle: "",
          leadingWidht: Dimensions.w200,
          leading: Row(
            children: [
              SizedBox(width: Dimensions.w10),
              SvgPicture.asset(
                ConstantImage.walletAppbar,
                height: 25,
                width: 30,
                color: AppColors.white,
              ),
              SizedBox(width: Dimensions.w2),
              GetBuilder<WalletController>(
                builder: (con) => Text(
                  con.walletBalance.value,
                  style:
                      CustomTextStyle.textRobotoSansMedium.copyWith(fontSize: Dimensions.h16, color: AppColors.white),
                ),
              ),
              // SizedBox(width: Dimensions.w20),
              Text(
                appbarTitle,
                style: CustomTextStyle.textRobotoSansMedium.copyWith(
                  fontSize: Dimensions.h17,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          // actions: [
          //   InkWell(onTap: () => Get.to(() => const SetFilter()), child: SvgPicture.asset(ConstantImage.filter)),
          //   SizedBox(width: Dimensions.w10),
          // ],
        ),
        Expanded(
          child: bidHistoryList(),
        ),
      ],
    );
  }

  bidHistoryList() {
    return Obx(
      () => homePageController.marketBidHistoryList.isEmpty
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
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: Dimensions.h10),
              itemCount: homePageController.marketBidHistoryList.length,
              itemBuilder: (context, index) {
                var data = homePageController.marketBidHistoryList[index];
                return listveiwTransactionNew(
                  requestId: "RequestId :  ${data.requestId ?? ""}",
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
            ),
    );
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
                spreadRadius: 0.5,
                color: AppColors.grey,
                blurRadius: 2,
                offset: const Offset(2, 4),
              )
            ],
            border: Border.all(width: 0.2),
            color: isWin == true ? AppColors.greenAccent : AppColors.white,
            borderRadius: BorderRadius.circular(Dimensions.r8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$transactiontype :",
                      style: CustomTextStyle.textRobotoSansBold.copyWith(fontSize: Dimensions.h14),
                    ),
                    SizedBox(width: Dimensions.w5),
                    Text(
                      bidNo,
                      style: CustomTextStyle.textRobotoSansMedium
                          .copyWith(color: AppColors.appbarColor, fontSize: Dimensions.h13),
                    ),
                    const Expanded(child: SizedBox()),
                    Row(
                      children: [
                        Text(
                          "Points :",
                          style: CustomTextStyle.textRobotoSansBold.copyWith(fontSize: Dimensions.h14),
                        ),
                        Text(
                          " $coins",
                          style: CustomTextStyle.textRobotoSansMedium
                              .copyWith(fontSize: Dimensions.h14, color: AppColors.appbarColor),
                        ),
                      ],
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
                      requestId,
                      style: CustomTextStyle.textRobotoSansLight.copyWith(fontSize: Dimensions.h12),
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
                      gameMode,
                      style: CustomTextStyle.textRobotoSansLight.copyWith(fontSize: Dimensions.h12),
                    ),
                    // SizedBox(
                    //   width: 180,
                    // ),

                    SvgPicture.asset(
                      ConstantImage.walletAppbar,
                      height: Dimensions.h13,
                    ),
                    SizedBox(width: Dimensions.w8),
                    Flexible(
                      child: Text(
                        ballance,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: CustomTextStyle.textRobotoSansLight.copyWith(fontSize: Dimensions.h12),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(Dimensions.h8),
                decoration: BoxDecoration(
                  color: AppColors.greyShade.withOpacity(0.4),
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
                        style: CustomTextStyle.textRobotoSansBold,
                      ),
                    ),
                    Text(bidType, style: CustomTextStyle.textRobotoSansBold),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
