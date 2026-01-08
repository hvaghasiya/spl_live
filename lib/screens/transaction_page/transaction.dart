import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helper_files/app_colors.dart';
import '../../helper_files/custom_text_style.dart';
import '../../helper_files/dimentions.dart';
import '../../helper_files/ui_utils.dart';
import 'controller/transaction_controller.dart';

// ignore: must_be_immutable
class TransactionPage extends StatefulWidget {
  TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final controller = Get.put<TransactionHistoryPageController>(TransactionHistoryPageController());
  @override
  void initState() {
    super.initState();
    controller.fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppUtils().simpleAppbar(appBarTitle: "TRANSACTIONS".tr),
      body: SafeArea(
        child: Obx(
          () {
            return controller.transactionModel.value.data?.rows != null
                ? controller.transactionModel.value.data?.rows?.length != 0
                    ? Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(height: 15),
                          shrinkWrap: true,
                          itemCount: controller.transactionModel.value.data?.rows?.length ?? 0,
                          itemBuilder: (context, index) {
                            var data = controller.transactionModel.value.data?.rows?[index];
                            return Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 0.5,
                                    color: AppColors.grey,
                                    blurRadius: 5,
                                    offset: const Offset(2, 4),
                                  ),
                                ],
                                border: Border.all(width: 0.6),
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(data?.transactionType ?? "", style: CustomTextStyle.textGothamBold),
                                            Row(
                                              children: [
                                                Text("PaymentMode : ", style: CustomTextStyle.textGothamMedium),
                                                Text(data?.paymentMode ?? "", style: CustomTextStyle.textGothamMedium),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Text("ClientRefId :", style: CustomTextStyle.textGothamBold),
                                            Text(data?.clientRefId ?? "", style: CustomTextStyle.textGothamMedium),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Text("Amount : ", style: CustomTextStyle.textGothamBold),
                                            Flexible(
                                              child: Text(
                                                "${data?.amount ?? " "}",
                                                style: CustomTextStyle.textGothamMedium
                                                    .copyWith(color: AppColors.appbarColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: AppColors.grey.withOpacity(0.5),
                                    ),
                                    child: Row(
                                      children: [
                                        Text("OrderId :", style: CustomTextStyle.textGothamBold),
                                        Expanded(
                                            child: Text(data?.orderId ?? "", style: CustomTextStyle.textGothamMedium)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : SizedBox(
                        child: Center(
                          child: Text(
                            "There is no Transaction History",
                            style: CustomTextStyle.textRobotoSansLight.copyWith(
                              fontSize: Dimensions.h13,
                            ),
                          ),
                        ),
                      )
                : Container();
          },
        ),
      ),
    );
  }

  // Widget listveiwTransaction(
  //     {required String marketName,
  //     required String openTime,
  //     required String closeTime,
  //     required String gameName,
  //     required String bidNo,
  //     required String ballance,
  //     required String coins,
  //     required String timeDate,
  //     required String bid,
  //     required Color containerColor}) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: Dimensions.h5),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         boxShadow: [
  //           BoxShadow(
  //             spreadRadius: 0.5,
  //             color: AppColors.grey,
  //             blurRadius: 5,
  //             offset: const Offset(2, 4),
  //           ),
  //         ],
  //         border: Border.all(width: 0.6),
  //         color: containerColor,
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //             child: Row(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   bid,
  //                   style: CustomTextStyle.textRobotoSansBold.copyWith(fontSize: Dimensions.h15),
  //                 ),
  //                 Text(
  //                   marketName,
  //                   style: CustomTextStyle.textRobotoSansLight,
  //                 ),
  //               ],
  //             ),
  //           ),
  //           SizedBox(
  //             height: Dimensions.h5,
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   "$openTime | $closeTime",
  //                   style: CustomTextStyle.textRobotoSansLight,
  //                 ),
  //                 Text(
  //                   " $bidNo - ($gameName)",
  //                   style: CustomTextStyle.textRobotoSansLight,
  //                 )
  //               ],
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Row(
  //               children: [
  //                 Text(
  //                   "Points",
  //                   style: CustomTextStyle.textRobotoSansLight,
  //                 ),
  //                 SizedBox(
  //                   width: Dimensions.w5,
  //                 ),
  //                 // Image.asset(
  //                 //   ConstantImage.ruppeeBlueIcon,
  //                 //   height: Dimensions.h25,
  //                 //   width: Dimensions.w25,
  //                 // ),
  //                 SizedBox(
  //                   width: Dimensions.w5,
  //                 ),
  //                 Text(
  //                   coins,
  //                   style: CustomTextStyle.textRobotoSansLight,
  //                 ),
  //                 const Expanded(child: SizedBox()),
  //                 Text(
  //                   "Balance",
  //                   style: CustomTextStyle.textRobotoSansLight,
  //                 ),
  //                 SizedBox(
  //                   width: Dimensions.w5,
  //                 ),
  //                 // Image.asset(
  //                 //   ConstantImage.ruppeeBlueIcon,
  //                 //   height: Dimensions.h25,
  //                 //   width: Dimensions.w25,
  //                 // ),
  //                 SizedBox(
  //                   width: Dimensions.w5,
  //                 ),
  //                 Text(
  //                   ballance,
  //                   style: CustomTextStyle.textRobotoSansLight,
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Container(
  //             height: Dimensions.h30,
  //             width: double.infinity,
  //             decoration: BoxDecoration(
  //               color: AppColors.greywhite,
  //               borderRadius: BorderRadius.only(
  //                 bottomLeft: Radius.circular(Dimensions.r8),
  //                 bottomRight: Radius.circular(Dimensions.r8),
  //               ),
  //             ),
  //             child: Center(
  //               child: Text(
  //                 "Time : $timeDate",
  //                 style: CustomTextStyle.textRobotoSansLight,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
