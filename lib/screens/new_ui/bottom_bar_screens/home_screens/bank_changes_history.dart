import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../Custom Controllers/wallet_controller.dart';
import '../../../../helper_files/app_colors.dart';
import '../../../../helper_files/common_utils.dart';
import '../../../../helper_files/constant_image.dart';
import '../../../../helper_files/custom_text_style.dart';
import '../../../../helper_files/dimentions.dart';

class BankChangeHistory extends StatefulWidget {
  const BankChangeHistory({super.key});

  @override
  State<BankChangeHistory> createState() => _BankChangeHistoryState();
}

class _BankChangeHistoryState extends State<BankChangeHistory> {
  final walletCon = Get.find<WalletController>();
  @override
  void initState() {
    super.initState();
    walletCon.getBankHistory();
  }

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              Container(
                color: AppColors.appbarColor,
                padding: const EdgeInsets.all(10),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                              onTap: () => walletCon.selectedIndex.value = null,
                              child: Icon(Icons.arrow_back, color: AppColors.white)),
                          const SizedBox(width: 5),
                        ],
                      ),
                      const Expanded(child: SizedBox()),
                      Text(
                        textAlign: TextAlign.center,
                        "Bank Change History",
                        style: CustomTextStyle.textRobotoSansMedium.copyWith(
                          color: AppColors.white,
                          fontSize: Dimensions.h17,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ),
              ),
              Obx(
                () => Expanded(
                  child: walletCon.bankHistoryData.isEmpty
                      ? Center(
                          child: Text(
                            "NOHISTORYAVAILABLEFORLAST7DAYS".tr,
                            style: CustomTextStyle.textPTsansMedium.copyWith(
                              fontSize: Dimensions.h13,
                              color: AppColors.black,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, index) => const SizedBox(height: 20),
                              itemCount: walletCon.bankHistoryData.length,
                              itemBuilder: (context, i) {
                                return Stack(
                                  children: [
                                    Container(
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
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "Account no.",
                                                        style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                                          color: AppColors.textColor,
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        ": ${walletCon.bankHistoryData[i].accountNumber ?? ""}",
                                                        // ":  ${walletCon.fundTransactionList[i].paymentMode}",
                                                        style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                                            color: AppColors.black, fontWeight: FontWeight.w400),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                // SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "IFSC code",
                                                        style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                                          color: AppColors.textColor,
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        ": ${walletCon.bankHistoryData[i].iFSCCode ?? ""}",
                                                        // ":  ${walletCon.fundTransactionList[i].paymentMode}",
                                                        style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                                            color: AppColors.black, fontWeight: FontWeight.w400),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "Account holder name",
                                                        style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                                          color: AppColors.textColor,
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        ": ${walletCon.bankHistoryData[i].accountHolderName ?? " "}",
                                                        style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                                            color: AppColors.black, fontWeight: FontWeight.w400),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "Bank name",
                                                        style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                                          color: AppColors.textColor,
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        ": ${walletCon.bankHistoryData[i].bankName ?? " "}",
                                                        style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                                            color: AppColors.black, fontWeight: FontWeight.w400),
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
                                              color: AppColors.greyShade.withOpacity(0.4),
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
                                                          walletCon.bankHistoryData[i].createdAt ?? ""),
                                                      style: CustomTextStyle.textRobotoSansBold.copyWith(fontSize: 15),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    walletCon.bankHistoryData[i].isPrimary ?? false
                                        ? Align(
                                            alignment: Alignment.topRight,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  color: AppColors.green,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.check,
                                                    size: 15,
                                                    color: AppColors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container()
                                  ],
                                );
                              },
                            ),
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
