import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../Custom Controllers/wallet_controller.dart';
import '../../../helper_files/app_colors.dart';
import '../../../helper_files/common_utils.dart';
import '../../../helper_files/constant_image.dart';
import '../../../helper_files/custom_text_style.dart';
import '../../../helper_files/dimentions.dart';
import '../../../helper_files/ui_utils.dart';
import '../../home_screen/controller/homepage_controller.dart';
import 'controller/check_withdrawal_history_controller.dart';

class CheckWithdrawalPage extends StatefulWidget {
  CheckWithdrawalPage({super.key});

  @override
  State<CheckWithdrawalPage> createState() => _CheckWithdrawalPageState();
}

class _CheckWithdrawalPageState extends State<CheckWithdrawalPage> {
  final controller = Get.put<CheckWithdrawalPageController>(CheckWithdrawalPageController());
  final walletController = Get.put<WalletController>(WalletController());
  final homeCon = Get.find<HomePageController>();
  @override
  void initState() {
    controller.getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppUtils().simpleAppbar(
        appBarTitle: "Withdrawal",
        centerTitle: true,
        actions: [IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close))],
        leadingWidht: Dimensions.w130,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: Dimensions.w36,
              child: Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 8.0),
                child: SvgPicture.asset(
                  ConstantImage.walletAppbar,
                  color: AppColors.white,
                ),
              ),
            ),
            SizedBox(width: Dimensions.w5),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  walletController.walletBalance.toString(),
                  style: CustomTextStyle.textRobotoSansMedium.copyWith(
                    fontSize: Dimensions.h16,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => controller.getUserData(),
        child: withdrawalHistoryList2(),
      ),
    );
  }

  withdrawalHistoryList() {
    return Obx(
      () => controller.withdrawalRequestList.isEmpty
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
              itemCount: controller.withdrawalRequestList.length,
              itemBuilder: (context, index) {
                // var data = controller.marketHistoryList.elementAt(index);
                // print(")))))))))))))))))))))))))))))))))))))))))))))))))) $data");
                return listveiwTransaction(
                  requestId: controller.withdrawalRequestList[index].requestId.toString(),
                  requestProcessedAt: controller.withdrawalRequestList[index].requestProcessedAt.toString(),
                  requestTime: CommonUtils()
                      .formatStringToDDMMMYYYYHHMMSSA(controller.withdrawalRequestList[index].requestTime.toString()),
                  requestedAmount: controller.withdrawalRequestList[index].requestedAmount.toString(),
                  status: controller.withdrawalRequestList[index].status.toString(),
                );
              },
            ),
    );
  }

  withdrawalHistoryList2() {
    return Obx(
      () => controller.withdrawalRequestList.isEmpty
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
              itemCount: controller.withdrawalRequestList.length,
              itemBuilder: (context, index) {
                // var data = controller.marketHistoryList.elementAt(index);
                // print(")))))))))))))))))))))))))))))))))))))))))))))))))) $data");
                return withDrawalHistoryDetails(
                  remarkTitle:
                      controller.withdrawalRequestList[index].remarks == null ? "Withdrawal Status" : "Remarks",
                  remarks: controller.withdrawalRequestList[index].remarks ?? "Pending for Approval",
                  requestTimeColor: AppColors.white,
                  onStatusContainerColor: controller.checkColor(index),
                  statusColor: controller.withdrawalRequestList[index].status.toString() == "Pending"
                      ? AppColors.appbarColor
                      : AppColors.white,
                  coins: "",
                  marketName: "",
                  requestId: controller.withdrawalRequestList[index].requestId.toString(),
                  // requestProcessedAt: controller
                  //     .withdrawalRequestList[index].requestProcessedAt
                  //     .toString(),
                  requestTime: CommonUtils().convertUtcToIstFormatStringToDDMMYYYYHHMMA(
                      controller.withdrawalRequestList[index].requestTime.toString()),
                  requestedAmount: controller.withdrawalRequestList[index].requestedAmount.toString(),
                  status: controller.withdrawalRequestList[index].status.toString() == "Pending"
                      ? ""
                      : controller.withdrawalRequestList[index].status.toString(),
                );
              },
            ),
    );
  }

  Widget withDrawalHistoryDetails({
    required String marketName,
    required String coins,
    required String requestTime,
    required String requestId,
    required String status,
    required String requestedAmount,
    required Color statusColor,
    required Color onStatusContainerColor,
    required Color requestTimeColor,
    required String remarks,
    required String remarkTitle,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.h5),
      child: InkWell(
        // onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                spreadRadius: 1,
                color: AppColors.white,
                blurRadius: 10,
                offset: const Offset(7, 4),
              ),
            ],
            border: Border.all(width: 0.2),
            color: AppColors.white,
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
                      "RequestId : $requestId",
                      style: CustomTextStyle.textRobotoSansBold.copyWith(fontSize: Dimensions.h14),
                    ),
                    SizedBox(
                      width: Dimensions.w5,
                    ),
                    const Expanded(child: SizedBox()),
                    Text(
                      requestedAmount,
                      style: CustomTextStyle.textRobotoSansBold
                          .copyWith(color: AppColors.appbarColor, fontSize: Dimensions.h13),
                    ),
                    // Text(
                    //   requestedAmount,
                    //   style: CustomTextStyle.textRobotoSansBold,
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(Dimensions.h8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$remarkTitle : ",
                      style: CustomTextStyle.textRobotoSansBold,
                    ),
                    Expanded(
                      child: Text(
                        remarks.trim(),
                        style: CustomTextStyle.textRobotoSansLight,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: Dimensions.h30,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: onStatusContainerColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(Dimensions.r8),
                    bottomRight: Radius.circular(Dimensions.r8),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.h8),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        ConstantImage.clockSvg,
                        height: Dimensions.h14,
                      ),
                      SizedBox(
                        width: Dimensions.w8,
                      ),
                      Text(
                        requestTime,
                        style: CustomTextStyle.textRobotoSansLight.copyWith(color: requestTimeColor),
                      ),
                      // SizedBox(
                      //   width: Dimensions.w8,
                      // ),

                      const Expanded(child: SizedBox()),
                      Text(
                        status,
                        style: CustomTextStyle.textRobotoSansLight.copyWith(
                          color: statusColor,
                        ),
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

  Widget listveiwTransaction({
    required String requestedAmount,
    required String requestId,
    required String status,
    required String requestProcessedAt,
    required String requestTime,
    // required String closeResult,
    // required Function() onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.h5),
      child: InkWell(
        // onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                spreadRadius: 1,
                color: AppColors.grey,
                blurRadius: 10,
                offset: const Offset(7, 4),
              ),
            ],
            border: Border.all(width: 0.2),
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "RequestId : $requestId",
                      style: CustomTextStyle.textRobotoSansLight.copyWith(fontSize: Dimensions.h14),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(
                        children: [
                          Text(
                            requestedAmount,
                            style: CustomTextStyle.textRobotoSansLight,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Status",
                      style: CustomTextStyle.textRobotoSansBold,
                    ),
                    Text(
                      "Request On",
                      style: CustomTextStyle.textRobotoSansBold,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      status,
                      style: CustomTextStyle.textRobotoSansLight,
                    ),
                    SizedBox(
                      width: Dimensions.w5,
                    ),
                    const Expanded(child: SizedBox()),
                    SizedBox(
                      width: Dimensions.w5,
                    ),
                    SizedBox(
                      width: Dimensions.w5,
                    ),
                    Text(
                      requestTime,
                      style: CustomTextStyle.textRobotoSansLight,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AlertDialog onExitAlert(BuildContext context, {required Function() onExit, required Function() onCancel}) {
    return AlertDialog(
      title: Text(
        'Exit App',
        style: CustomTextStyle.textRobotoSansBold,
      ),
      content: Text('Are you sure you want to exit the app?', style: CustomTextStyle.textRobotoSansMedium),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(
            'Cancel',
            style: CustomTextStyle.textRobotoSansBold.copyWith(
              color: AppColors.appbarColor,
            ),
          ),
        ),
        TextButton(
          onPressed: onExit,
          child: Text(
            'Exit',
            style: CustomTextStyle.textRobotoSansBold.copyWith(
              color: AppColors.redColor,
            ),
          ),
        ),
      ],
    );
  }
}
