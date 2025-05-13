import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:spllive/Custom%20Controllers/wallet_controller.dart';
import 'package:spllive/components/simple_button_with_corner.dart';
import 'package:spllive/screens/More%20Details%20Screens/Create%20Withdrawal%20Page/controller/create_withdrawal_page_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../helper_files/app_colors.dart';
import '../../../helper_files/constant_image.dart';
import '../../../helper_files/custom_text_style.dart';
import '../../../helper_files/dimentions.dart';
import '../../../helper_files/ui_utils.dart';

// ignore: must_be_immutable
class CreatewithDrawalPage extends StatefulWidget {
  CreatewithDrawalPage({super.key});

  @override
  State<CreatewithDrawalPage> createState() => _CreatewithDrawalPageState();
}

class _CreatewithDrawalPageState extends State<CreatewithDrawalPage> {
  final controller = Get.put<CreateWithDrawalPageController>(CreateWithDrawalPageController());
  final walletCon = Get.put<WalletController>(WalletController());

  @override
  void initState() {
    super.initState();
    controller.fetchStoredUserDetailsAndGetBankDetailsByUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppUtils().simpleAppbar(
        appBarTitle: "Withdrawal Fund",
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.h5),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Obx(
              () => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(height: Dimensions.h10),
                    Container(
                      // height: Dimensions.h100,
                      width: Get.width,
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "WALLETBALANCE".tr,
                            style: CustomTextStyle.textRobotoMedium.copyWith(fontSize: Dimensions.h22),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: Dimensions.w40,
                                  width: Dimensions.w40,
                                  child: SvgPicture.asset(
                                    ConstantImage.walletAppbar,
                                    color: AppColors.appbarColor,
                                  ),
                                ),
                                SizedBox(width: Dimensions.w10),
                                Expanded(
                                  child: Text(
                                    walletCon.walletBalance.value ?? "",
                                    textAlign: TextAlign.center,
                                    style: CustomTextStyle.textRobotoMedium
                                        .copyWith(fontSize: Dimensions.h28, color: AppColors.appbarColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: controller.amountTextController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                      ],
                      keyboardType: TextInputType.number,
                      style: CustomTextStyle.textRobotoMedium,
                      cursorColor: AppColors.appbarColor,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: "Enter Amount",
                        hintStyle: CustomTextStyle.textRobotoMedium,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Dimensions.r10),
                          borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Dimensions.r10),
                          borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Dimensions.r10),
                          borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: RoundedCornerButton(
                        text: "SUBMIT",
                        color: AppColors.appbarColor,
                        borderColor: AppColors.appbarColor,
                        fontSize: Dimensions.h15,
                        fontWeight: FontWeight.w500,
                        fontColor: AppColors.white,
                        letterSpacing: 0,
                        borderRadius: Dimensions.r5,
                        borderWidth: 1,
                        textStyle: CustomTextStyle.textRobotoMedium,
                        onTap: () {
                          if (controller.amountTextController.text.isNotEmpty) {
                            controller.createWithdrawalRequest();
                          } else {
                            AppUtils.showErrorSnackBar(bodyText: "Please Enter Amount");
                          }
                        },
                        height: Dimensions.h35,
                        width: Get.width / 2.5,
                      ),
                    ),
                    const SizedBox(height: 100),
                    InkWell(
                      onTap: () => launch("https://wa.me/+917769826748/?text=hi"),
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: LinearGradient(
                            colors: [AppColors.wpColor1, AppColors.wpColor2],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  ConstantImage.whatsaapIcon,
                                  fit: BoxFit.contain,
                                  width: 24,
                                  height: 24,
                                ),
                                Text(
                                  "+91 7769826748",
                                  style: CustomTextStyle.textRobotoMedium.copyWith(color: AppColors.white),
                                ),
                              ],
                            ),
                            Text(
                              "Whatsapp for any queries",
                              style: CustomTextStyle.textRobotoMedium.copyWith(color: AppColors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: RoundedCornerEditTextWithIcon(
                    //         height: Dimensions.h40,
                    //         controller: controller.amountTextController,
                    //         keyboardType: TextInputType.phone,
                    //         hintText: "Enter Amount",
                    //         imagePath: "",
                    //         maxLines: 1,
                    //         minLines: 1,
                    //         isEnabled: true,
                    //         maxLength: 10,
                    //         formatter: [FilteringTextInputFormatter.digitsOnly],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(height: Dimensions.h10),
                    // listTileDetails(text: "BANK_TEXT".tr, value: controller.bankName.value),
                    // listTileDetails(text: "ACNAME_TEXT".tr, value: controller.accountName.value),
                    // listTileDetails(text: "ACNO_TEXT".tr, value: controller.accountNumber.value),
                    // listTileDetails(text: "IFSC_TEXT".tr, value: controller.ifcsCode.value),
                    // SizedBox(height: Dimensions.h10),
                    // SizedBox(height: Dimensions.h10),
                    // if (controller.bankName.value != "")
                    //   Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    //     child: RoundedCornerButton(
                    //       text: "CONTINUE".tr,
                    //       color: AppColors.appbarColor,
                    //       borderColor: AppColors.appbarColor,
                    //       fontSize: Dimensions.h15,
                    //       fontWeight: FontWeight.w500,
                    //       fontColor: AppColors.white,
                    //       letterSpacing: 0,
                    //       borderRadius: Dimensions.r25,
                    //       borderWidth: 1,
                    //       textStyle: CustomTextStyle.textRobotoSlabBold,
                    //       onTap: () => controller.createWithdrawalRequest(),
                    //       height: Dimensions.h35,
                    //       width: double.infinity,
                    //     ),
                    //   )
                    // else
                    //   Container(),
                    // SizedBox(height: Dimensions.h30),
                    // Obx(
                    //   () => controller.bankName.value == "" || controller.bankName.value.isEmpty
                    //       ? SizedBox(
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               Text(
                    //                 "To Add Bank Detaiils ",
                    //                 style: CustomTextStyle.textRobotoSansMedium.copyWith(
                    //                   fontSize: Dimensions.h13,
                    //                 ),
                    //               ),
                    //               InkWell(
                    //                 onTap: () => Get.offAndToNamed(AppRoutName.myAccountPage),
                    //                 child: Text(
                    //                   "Click Here",
                    //                   style: CustomTextStyle.textRobotoSansMedium.copyWith(
                    //                     fontSize: Dimensions.h13,
                    //                     color: AppColors.redColor,
                    //                     decoration: TextDecoration.underline,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         )
                    //       : const SizedBox(),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  //
  // void _showExitDialog() {
  //   Get.defaultDialog(
  //     barrierDismissible: false,
  //     title: "Contact Admin",
  //     onWillPop: () async => false,
  //     titleStyle: CustomTextStyle.textRobotoSansMedium,
  //     content: Column(
  //       children: [Text("SNACKMSG_TEXT".tr, style: CustomTextStyle.textRobotoSansMedium)],
  //     ),
  //     actions: [
  //       InkWell(
  //         onTap: () async {
  //           Get.back();
  //         },
  //         child: Container(
  //           color: AppColors.appbarColor,
  //           height: Dimensions.h40,
  //           width: Dimensions.w150,
  //           child: Center(
  //             child: Text(
  //               'OK',
  //               style: CustomTextStyle.textRobotoSansBold.copyWith(
  //                 color: AppColors.white,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // AlertDialog onExitAlert(BuildContext context,
  Padding listTileDetails({required String text, required String value}) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.w8),
      child: Container(
        height: Dimensions.h60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.grey, width: 0.5),
          borderRadius: BorderRadius.circular(Dimensions.r5),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: Dimensions.w10),
          child: Row(
            children: [
              Expanded(
                child: Text(text,
                    style: CustomTextStyle.textPTsansBold.copyWith(
                      color: AppColors.black,
                      fontSize: Dimensions.h16,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Expanded(
                child: Text(
                  value,
                  style: CustomTextStyle.textRobotoSansMedium.copyWith(
                    fontSize: Dimensions.h14,
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
