import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../Custom Controllers/wallet_controller.dart';
import '../../../components/simple_button_with_corner.dart';
import '../../../helper_files/app_colors.dart';
import '../../../helper_files/custom_text_style.dart';
import '../../../helper_files/dimentions.dart';

class WithdrawalPage extends StatefulWidget {
  WithdrawalPage({super.key});

  @override
  State<WithdrawalPage> createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage> {
  WalletController walletController = Get.find();

  @override
  void initState() {
    walletController.getWithdrawalTiming();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("fsdkfjhsdfkjsdhfsdkhfdk");
    print(walletController.getWithdrawalData.value.openTime);
    return PopScope(
      canPop: false,
      onPopInvoked: (value) async {
        if (value) {
          return;
        }
        walletController.selectedIndex.value = null;
      },
      child: Obx(() {
        return walletController.isCheck.value == true
            ? Container(height: Get.height - 150, child: Center(child: CircularProgressIndicator()))
            : walletController.noTiming.value.isNotEmpty
                ? Container(
                    height: Get.height - 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          walletController.noTiming.value ?? "",
                          style: CustomTextStyle.textRamblaBold.copyWith(
                            color: AppColors.appbarColor,
                            fontSize: Dimensions.h20,
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.w20, vertical: Dimensions.h10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SizedBox(height: Dimensions.h5),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 1,
                                blurRadius: 4,
                                color: AppColors.grey.withOpacity(0.5),
                                offset: const Offset(0, 0),
                              )
                            ],
                            borderRadius: BorderRadius.circular(Dimensions.r4),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: Dimensions.h5),
                              Text(
                                "Withdrawal Timing",
                                style: CustomTextStyle.textRamblaBold.copyWith(
                                  color: AppColors.appbarColor,
                                  fontSize: Dimensions.h20,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Obx(
                                          () => walletController.isCheck.value == false
                                              ? Text(
                                                  "${openCloseTime(walletController.getWithdrawalData.value.openTime ?? 0)}",
                                                  style: CustomTextStyle.textRobotoSansBold.copyWith(
                                                    color: AppColors.black,
                                                    fontSize: Dimensions.h14,
                                                  ),
                                                )
                                              : SizedBox(),
                                        ),
                                        Text(
                                          "  to ",
                                          style: CustomTextStyle.textRobotoSansLight.copyWith(
                                            color: AppColors.black,
                                            fontSize: Dimensions.h14,
                                          ),
                                        ),
                                        Obx(
                                          () => walletController.isCheck.value == false
                                              ? Text(
                                                  "${openCloseTime(walletController.getWithdrawalData.value.closeTime ?? 0)}",
                                                  style: CustomTextStyle.textRobotoSansBold.copyWith(
                                                    color: AppColors.black,
                                                    fontSize: Dimensions.h14,
                                                  ),
                                                )
                                              : SizedBox(),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: Dimensions.h5),
                                    Text(
                                      "(Withdrawal Available all days including Sunday & Bank Holidays )",
                                      textAlign: TextAlign.center,
                                      style: CustomTextStyle.textRobotoSansLight.copyWith(
                                        color: AppColors.black,
                                        fontSize: Dimensions.h14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: Dimensions.h5,
                              ),
                              Text(
                                "Minimum Withdrawal",
                                style: CustomTextStyle.textRamblaBold.copyWith(
                                  color: AppColors.appbarColor,
                                  fontSize: Dimensions.h20,
                                ),
                              ),
                              SizedBox(height: Dimensions.h5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Rs.",
                                    style: CustomTextStyle.textRobotoSansBold.copyWith(
                                      color: AppColors.black,
                                      fontSize: Dimensions.h14,
                                    ),
                                  ),
                                  Obx(
                                    () => walletController.isCheck.value == false
                                        ? Text(
                                            " ${walletController.getWithdrawalData.value.minimumAmount}/-",
                                            style: CustomTextStyle.textRobotoSansLight.copyWith(
                                              color: AppColors.black,
                                              fontSize: Dimensions.h14,
                                            ),
                                          )
                                        : SizedBox(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Note :",
                                      textAlign: TextAlign.start,
                                      style: CustomTextStyle.textRamblaBold.copyWith(
                                        color: AppColors.appbarColor,
                                        fontSize: Dimensions.h18,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 5),
                                          Text(
                                            "Withdrawal request processing time minimum 60 min to 24 Hrs",
                                            textAlign: TextAlign.start,
                                            style: CustomTextStyle.textRobotoSansLight.copyWith(
                                              color: AppColors.black,
                                              fontSize: Dimensions.h12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),

                              // Padding(
                              //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              //   child: Row(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     mainAxisAlignment: MainAxisAlignment.start,
                              //     children: [
                              //       Text(
                              //         "Note :",
                              //         textAlign: TextAlign.start,
                              //         style: CustomTextStyle.textRamblaBold.copyWith(
                              //           color: AppColors.appbarColor,
                              //           fontSize: Dimensions.h18,
                              //         ),
                              //       ),
                              //       const SizedBox(width: 10),
                              //       Expanded(
                              //         child: Text(
                              //           textAlign: TextAlign.start,
                              //           "Withdrawal request processing time minimum 60 min to 24 Hrs ",
                              //           style: CustomTextStyle.textRobotoSansLight.copyWith(
                              //             color: AppColors.black,
                              //             fontSize: Dimensions.h13,
                              //           ),
                              //         ),
                              //       ),
                              //       const SizedBox(width: 10),
                              //     ],
                              //   ),
                              // )
                            ],
                          ),
                        ),
                        SizedBox(height: Dimensions.h15),
                        SizedBox(height: Dimensions.h10),
                        Obx(
                          () => walletController.isLoad.value == false
                              ? RoundedCornerButton(
                                  text: "CHECKHISTORY".tr,
                                  color: AppColors.wpColor1,
                                  borderColor: AppColors.wpColor1,
                                  fontSize: Dimensions.h13,
                                  fontWeight: FontWeight.w600,
                                  fontColor: AppColors.black,
                                  letterSpacing: 0.5,
                                  borderRadius: Dimensions.r3,
                                  borderWidth: 0,
                                  textStyle: CustomTextStyle.textRobotoSansLight,
                                  onTap: () {
                                    walletController.getCheckBankDetails();
                                  },
                                  height: Dimensions.h40,
                                  width: Get.width,
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.appBlueColor,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  );
      }),
    );
  }

  openCloseTime(time) {
    DateTime parsedTime = DateFormat("HH:mm:ss").parse(time);
    String formattedTime = DateFormat("h:mm a").format(parsedTime);
    return formattedTime;
  }
}
