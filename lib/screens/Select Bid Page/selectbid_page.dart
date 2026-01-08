import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';


import '../../components/bidList_for_market.dart';
import '../../components/simple_button_with_corner.dart';
import '../../helper_files/app_colors.dart';
import '../../helper_files/constant_image.dart';
import '../../helper_files/custom_text_style.dart';
import '../../helper_files/dimentions.dart';
import '../../helper_files/ui_utils.dart';
import 'controller/selectbid_page_controller.dart';

class SelectedBidsPage extends StatelessWidget {
  SelectedBidsPage({super.key});
  final controller = Get.put(SelectBidPageController());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Obx(
      () => Scaffold(
        appBar: AppUtils().simpleAppbar(
          appBarTitle: controller.marketName.value,
          actions: [
            InkWell(
              onTap: () {},
              child: Row(
                children: [
                  SizedBox(
                    height: Dimensions.h20,
                    width: Dimensions.w25,
                    child: SvgPicture.asset(
                      ConstantImage.walletAppbar,
                      color: AppColors.white,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: Dimensions.r8,
                      bottom: Dimensions.r5,
                      left: Dimensions.r10,
                      right: Dimensions.r10,
                    ),
                    child: Obx(
                      () => Text(
                        controller.walletController.walletBalance.toString(),
                        style: CustomTextStyle.textRobotoSansMedium.copyWith(
                          color: AppColors.white,
                          fontSize: Dimensions.h17,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SizedBox(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.requestModel.value.bids!.length,
                    itemBuilder: (context, index) {
                      return BidHistoryList(
                        marketName: controller.checkType(index),
                        bidType: controller.bidType.toString(),
                        bidCoin: controller.requestModel.value.bids![index].coins.toString(),
                        bidNo: controller.requestModel.value.bids![index].bidNo.toString(),
                        onDelete: () => controller.onDeleteBids(index),
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    /*Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(Dimensions.w5),
                        child: RoundedCornerButton(
                          text: "PLAYMORE".tr,
                          color: AppColors.white,
                          borderColor: AppColors.redColor,
                          fontSize: Dimensions.h14,
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.redColor,
                          letterSpacing: 0,
                          borderRadius: Dimensions.r5,
                          borderWidth: 2,
                          textStyle: CustomTextStyle.textRobotoSansMedium,
                          onTap: () => controller.playMore(),
                          height: Dimensions.h30,
                          width: double.infinity,
                        ),
                      ),
                    ),*/
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(Dimensions.w10),
                        child: RoundedCornerButton(
                          text: "SUBMIT".tr,
                          color: AppColors.appbarColor,
                          borderColor: AppColors.appbarColor,
                          fontSize: Dimensions.h14,
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.white,
                          letterSpacing: 0,
                          borderRadius: Dimensions.r5,
                          borderWidth: 1,
                          textStyle: CustomTextStyle.textRobotoSansMedium,
                          onTap: () {
                            controller.showConfirmationDialog(context);
                          },
                          //onTap: () {},
                          height: Dimensions.h30,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: bottombar(size, context),
        // bottomNavigationBar: bottomNavigationBar(controller.totalAmount.value),
      ),
    );
  }

  bottomNavigationBar(String totalAmount) {
    return SafeArea(
      child: Container(
        height: Dimensions.h50,
        color: AppColors.appbarColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.commonPaddingForScreen,
              ),
              child: Text(
                "TOTALCOIN".tr,
                style: CustomTextStyle.textRobotoSansMedium.copyWith(color: AppColors.white, fontSize: Dimensions.h18),
                // style: TextStyle(
                // color: AppColors.white,
                // fontSize: Dimensions.h18,
                // // ),
              ),
            ),
            Row(
              children: [
                Container(
                  height: Dimensions.h30,
                  width: Dimensions.w30,
                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(25)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      ConstantImage.rupeeImage,
                      fit: BoxFit.contain,
                      color: AppColors.appbarColor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.commonPaddingForScreen,
                  ),
                  child: Text(
                    totalAmount,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: Dimensions.h18,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  bottombar(Size size, context) {
    return Obx(
      () => Container(
        width: size.width,
        color: AppColors.appbarColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            nameColumn(
                titleText: "Bids",
                subText: controller.requestModel.value.bids!.length.toString(),
                textColor: AppColors.white,
                textColor2: AppColors.white),
            nameColumn(
                titleText: "Points",
                subText: controller.totalAmount.toString(),
                textColor: AppColors.white,
                textColor2: AppColors.white),
          ],
        ),
      ),
    );
  }

  Widget nameColumn(
      {required String titleText, required String subText, required Color textColor, required Color textColor2}) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 2),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                textAlign: TextAlign.center,
                titleText,
                style: CustomTextStyle.textRobotoSansBold.copyWith(
                  color: textColor,
                  fontSize: Dimensions.h13,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  textAlign: TextAlign.center,
                  subText,
                  style: CustomTextStyle.textRobotoSansBold.copyWith(
                    color: textColor2,
                    fontSize: Dimensions.h13,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
