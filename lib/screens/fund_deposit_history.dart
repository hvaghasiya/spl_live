import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../Custom Controllers/wallet_controller.dart';
import '../controller/home_controller.dart';
import '../helper_files/app_colors.dart';
import '../helper_files/common_utils.dart';
import '../helper_files/constant_image.dart';
import '../helper_files/custom_text_style.dart';
import '../helper_files/dimentions.dart';

class FundDipositHistory extends StatefulWidget {
  const FundDipositHistory({super.key});

  @override
  State<FundDipositHistory> createState() => _FundDipositHistoryState();
}

class _FundDipositHistoryState extends State<FundDipositHistory> {
  final walletCon = Get.find<WalletController>();
  final homeCon = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    walletCon.fundTransactionList.value.clear();
    walletCon.getTransactionHistory(false);
  }

  @override
  Widget build(BuildContext context) {
    print(walletCon.isLoading.value);
    print("fsdlfhsdkjf");
    return PopScope(
      canPop: false,
      onPopInvoked: (value) async {
        if (value) {
          return;
        }
        walletCon.selectedIndex.value = null;
      },
      child: Expanded(
        child: Material(
          child: Stack(
            children: [
              Column(
                children: [
                  Obx(
                    () => Expanded(
                      child: walletCon.isLoading.value == true
                          ? Container()
                          : walletCon.fundTransactionList.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: ListView.separated(
                                    controller: walletCon.fundDepositeHistoryScrollController,
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    separatorBuilder: (context, index) => const SizedBox(height: 20),
                                    itemCount: walletCon.fundTransactionList.length,
                                    itemBuilder: (context, i) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: AppColors.black),
                                          boxShadow: [
                                            BoxShadow(
                                              spreadRadius: 0.8722222447395325,
                                              blurRadius: 6.97777795791626,
                                              offset: const Offset(0, 0),
                                              color: AppColors.black.withOpacity(0.25),
                                            )
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          "₹ ${walletCon.fundTransactionList[i].amount}",
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                          style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                                            color: AppColors.appbarColor,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        "Deposit",
                                                        style: CustomTextStyle.textRobotoSansMedium
                                                            .copyWith(fontSize: 15, fontWeight: FontWeight.w600),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          "Order Id",
                                                          style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                                            color: AppColors.textColor,
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          ": ${walletCon.fundTransactionList[i].orderId ?? ""}",
                                                          style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                                              color: AppColors.black, fontWeight: FontWeight.w400),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          "Payment Mode",
                                                          style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                                            color: AppColors.textColor,
                                                            fontSize: Get.width > 410 ? Dimensions.h13 : Dimensions.h12,
                                                            fontWeight: FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          ":  ${walletCon.fundTransactionList[i].paymentMode}",
                                                          style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                                              color: AppColors.black, fontWeight: FontWeight.w400),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 2),
                                                  walletCon.fundTransactionList[i].clientRefId == null
                                                      ? Container(
                                                          height: Dimensions.h13,
                                                        )
                                                      : Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 1,
                                                              child: Text(
                                                                "Transaction ID",
                                                                style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                                                  color: AppColors.textColor,
                                                                  fontSize:
                                                                      Get.width > 410 ? Dimensions.h13 : Dimensions.h12,
                                                                  fontWeight: FontWeight.w400,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(width: 10),
                                                            Expanded(
                                                              flex: 2,
                                                              child: Text(
                                                                ":  ${walletCon.fundTransactionList[i].clientRefId}",
                                                                style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                                                    color: AppColors.black,
                                                                    fontWeight: FontWeight.w400),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: AppColors.greyShade.withOpacity(0.2),
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(Dimensions.r8),
                                                  bottomRight: Radius.circular(Dimensions.r8),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(ConstantImage.clockSvg, height: 18),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        CommonUtils().convertUtcToIstFormatStringToDDMMYYYYHHMMA2(
                                                            walletCon.fundTransactionList[i].createdAt.toString()),
                                                        style:
                                                            CustomTextStyle.textRobotoSansBold.copyWith(fontSize: 15),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        walletCon.fundTransactionList[i].paymentMode == "Manual" ||
                                                                walletCon.fundTransactionList[i].status == "Success"
                                                            ? Icon(Icons.check_circle, color: AppColors.green)
                                                            : walletCon.fundTransactionList[i].status == "Pending"
                                                                ? SvgPicture.asset(ConstantImage.sendWatchIcon,
                                                                    height: 15)
                                                                : Container(
                                                                    padding: const EdgeInsets.all(2.0),
                                                                    decoration: BoxDecoration(
                                                                      color: AppColors.redColor,
                                                                      shape: BoxShape.circle,
                                                                    ),
                                                                    child: Center(
                                                                      child: Icon(
                                                                        Icons.close,
                                                                        color: AppColors.white,
                                                                        size: 15,
                                                                      ),
                                                                    ),
                                                                  ),
                                                        const SizedBox(width: 5),
                                                        Text(
                                                          walletCon.fundTransactionList[i].paymentMode == "Manual" ||
                                                                  walletCon.fundTransactionList[i].status
                                                                          ?.toLowerCase() ==
                                                                      "Success"
                                                              ? "Success"
                                                              : walletCon.fundTransactionList[i].status
                                                                          ?.toLowerCase() ==
                                                                      "f"
                                                                  ? "Failed"
                                                                  : walletCon.fundTransactionList[i].status ?? "",
                                                          style: CustomTextStyle.textRobotoSansBold.copyWith(
                                                            fontSize: 15,
                                                            color: walletCon.fundTransactionList[i].paymentMode ==
                                                                        "Manual" ||
                                                                    walletCon.fundTransactionList[i].status == "Success"
                                                                ? AppColors.green
                                                                : walletCon.fundTransactionList[i].status == "Pending"
                                                                    ? AppColors.appbarColor
                                                                    : AppColors.redColor,
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
                                      );
                                    },
                                  ),
                                )
                              : Center(
                                  child: Text("No History Available", style: CustomTextStyle.textRobotoSansLight),
                                ),
                    ),
                  ),
                  Obx(() => walletCon.isMoreLoading.value == true ? CircularProgressIndicator() : Container())
                ],
              ),
              Obx(() => walletCon.isLoading.value == true ? Center(child: CircularProgressIndicator()) : Container())
            ],
          ),
        ),
      ),
    );
  }
}
