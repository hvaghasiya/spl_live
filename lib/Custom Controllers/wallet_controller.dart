import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:spllive/components/simple_button_with_corner.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/constant_image.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/models/BankHistory.dart';
import 'package:spllive/models/FundTransactionModel.dart';
import 'package:spllive/models/filter_model.dart';
import 'package:spllive/models/get_withdrawal_time.dart';
import 'package:spllive/routes/app_routes_name.dart';

import '../api_services/api_service.dart';

class WalletController extends GetxController {
  RxString walletBalance = "00".obs;
  var selectedIndex = Rxn<int>();
  RxBool isCallDialog = false.obs;

  RxBool isCheckBankDetails = false.obs;
  RxBool isLoad = false.obs;

  Rx<GetWithdrawalData> getWithdrawalData = GetWithdrawalData().obs;
  final RxList<FilterModel> filterDateList = [
    FilterModel(
      image: ConstantImage.addFundIconInWallet,
      name: "Add Fund",
    ),
    FilterModel(
      image: ConstantImage.withDrawalFundIcon,
      name: "Withdrawal Fund",
    ),
    FilterModel(
      image: ConstantImage.addBankDeatils,
      name: "Add Bank Details",
    ),
    FilterModel(
      image: ConstantImage.fundDepositIcon,
      name: "Fund Deposit History",
    ),
    FilterModel(
      image: ConstantImage.fundWithdrawalHistory,
      name: "Fund Withdrawal History",
    ),
    // FilterModel(
    //   image: ConstantImage.bankChangeDeatils,
    //   name: "Bank Changes History",
    // ),
  ].obs;

  ScrollController fundDepositeHistoryScrollController = ScrollController();
  RxInt totalPage = 0.obs;
  RxInt currentPage = 0.obs;
  RxBool isMoreLoading = false.obs;
  RxBool isLoading = false.obs;

  var addFundID;

  @override
  void onInit() {
    getUserBalance();
    fundDepositeHistoryScrollController.addListener(homeScrollListener);
    super.onInit();
  }

  init(index) {
    print(index);
    print("Fsdkfjdhskfjshdfkjd");
    selectedIndex.value = index;

    selectedIndex.refresh();
    print(selectedIndex.value);
    print("Fsdkfjdhskfjshdfkjd");
  }

  homeScrollListener() {
    print("fksdfgdjksggf");
    if ((fundDepositeHistoryScrollController.position.pixels ==
            fundDepositeHistoryScrollController.position.maxScrollExtent) &&
        isMoreLoading.value == false &&
        (totalPage.value > fundTransactionList.value.length)) {
      getTransactionHistory(false);
    }
  }

  Future<void> getTransactionHistory(bool view) async {
    if (fundTransactionList.value.length == 0) {
      isLoading.value = true;
    } else {
      isMoreLoading.value = true;
    }

    ApiService().getTransactionHistory(10, fundTransactionList.value.length).then((value) async {
      print("fsdkfjhsdkjfhdsj");
      print(value);
      if (value != null) {
        if (value.status ?? false) {
          value.fundTransactionList?.forEach((element) {
            fundTransactionList.value.add(element);
          });
          fundTransactionList.refresh();

          totalPage.value = value.count!;
          isMoreLoading.value = false;
          isLoading.value = false;
          if (view) {
            if (isCallDialog.value) {
              if (fundTransactionList[0].status == "Ok") {
                isCallDialog.value = false;
                Get.defaultDialog(
                  barrierDismissible: false,
                  onWillPop: () async => false,
                  title: "",
                  titleStyle: CustomTextStyle.textRobotoSansBold.copyWith(
                    color: AppColors.appbarColor,
                    fontSize: 0,
                  ),
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.check_rounded,
                            color: AppColors.white,
                            size: 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Payment Successful",
                        style: CustomTextStyle.textRobotoSansBold.copyWith(
                          color: AppColors.green,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "We have received the payment of",
                        style: CustomTextStyle.textRobotoSansMedium,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "\n₹ ${fundTransactionList[0].amount}",
                        style: CustomTextStyle.textRobotoSansBold.copyWith(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RoundedCornerButton(
                          text: "OK".tr,
                          color: AppColors.appbarColor,
                          borderColor: AppColors.appbarColor,
                          fontSize: Dimensions.h15,
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.white,
                          letterSpacing: 0,
                          borderRadius: Dimensions.r5,
                          borderWidth: 0,
                          textStyle: CustomTextStyle.textGothamMedium,
                          onTap: () {
                            getUserBalance();
                            walletBalance.refresh();
                            Get.offAllNamed(AppRoutName.dashBoardPage);
                          },
                          height: 40,
                          width: Get.width / 2.8,
                        ),
                      )
                    ],
                  ),
                );
              }
              if (fundTransactionList[0].status == "F") {
                isCallDialog.value = false;
                Get.defaultDialog(
                  barrierDismissible: false,
                  onWillPop: () async => false,
                  title: "",
                  titleStyle: CustomTextStyle.textRobotoSansBold.copyWith(
                    color: AppColors.appbarColor,
                    fontSize: 0,
                  ),
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: AppColors.redColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.close_rounded,
                            color: AppColors.white,
                            size: 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Payment Failed",
                        style: CustomTextStyle.textRobotoSansBold.copyWith(
                          color: AppColors.redColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Your payment was not successfully processed",
                        style: CustomTextStyle.textRobotoSansMedium,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Please try again",
                        style: CustomTextStyle.textRobotoSansBold.copyWith(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RoundedCornerButton(
                          text: "OK".tr,
                          color: AppColors.appbarColor,
                          borderColor: AppColors.appbarColor,
                          fontSize: Dimensions.h15,
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.white,
                          letterSpacing: 0,
                          borderRadius: Dimensions.r5,
                          borderWidth: 0,
                          textStyle: CustomTextStyle.textGothamMedium,
                          onTap: () {
                            Get.back();
                            Get.offAllNamed(AppRoutName.dashBoardPage);
                          },
                          height: 40,
                          width: Get.width / 2.8,
                        ),
                      )
                    ],
                  ),
                );
              }
            }
          }
        } else {
          isMoreLoading.value = false;
          isLoading.value = false;
          AppUtils.showErrorSnackBar(bodyText: value.message ?? "");
        }
      } else {
        isMoreLoading.value = false;
        isLoading.value = false;
        AppUtils.showErrorSnackBar(bodyText: "Something went wrong");
      }
    });
  }

  void getUserBalance() {
    ApiService().getBalance().then((value) async {
      if (value['status']) {
        if (value['data'] != null) {
          var tempBalance = value['data']['Amount'] ?? 00;
          walletBalance.value = tempBalance.toString();
        }
      } else {
        AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      }
    });
  }

  void getCheckBankDetails() {
    isLoad.value = true;
    ApiService().getWithBankDetails().then((value) async {
      if (value['status']) {
        if (value['data'] != null) {
          var isDetail = value['data']['hasBankDetail'] ?? false;
          isCheckBankDetails.value = isDetail;
          if (isCheckBankDetails.value == true) {
            isLoad.value = false;
            Get.toNamed(AppRoutName.createWithDrawalPage);
          } else {
            isLoad.value = false;
            Get.dialog(
              barrierDismissible: false,
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: Get.width, minWidth: Get.width - 30),
                child: AlertDialog(
                  insetPadding: EdgeInsets.zero,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 55, vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  content: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(ConstantImage.close, height: Dimensions.h60, width: Dimensions.w60),
                        const SizedBox(height: 20),
                        Text(
                          "Please Add Bank Details",
                          style: CustomTextStyle.textRobotoSansMedium.copyWith(
                            color: AppColors.appbarColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            Get.back();
                            selectedIndex.value = 2;
                          },
                          child: Container(
                            decoration:
                                BoxDecoration(color: AppColors.appbarColor, borderRadius: BorderRadius.circular(8)),
                            height: Dimensions.h40,
                            width: Dimensions.w150,
                            child: Center(
                              child: Text(
                                'OK',
                                style:
                                    CustomTextStyle.textRobotoSansBold.copyWith(color: AppColors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        }
      }
    });
  }

  RxList<BankHistoryData> bankHistoryData = <BankHistoryData>[].obs;
  RxBool isCheck = false.obs;

  void getBankHistory() async {
    ApiService().getBankHistory().then((value) async {
      if (value?.status ?? false) {
        bankHistoryData.value = value?.data ?? [];
      } else {
        AppUtils.showErrorSnackBar(bodyText: value?.message ?? "");
      }
    });
  }

  RxString noTiming = "".obs;
  void getWithdrawalTiming() async {
    isCheck.value = true;
    ApiService().getWithDrawalTime().then((value) async {
      if (value?.status ?? false) {
        getWithdrawalData.value = value!.data!;
        noTiming.value = "";
        isCheck.value = false;
      } else {
        noTiming.value = value?.message ?? "";
        isCheck.value = false;

        // AppUtils.showErrorSnackBar(bodyText: value?.message ?? "");
      }
    });
  }

  // transaction

  RxList<FundTransactionList> fundTransactionList = <FundTransactionList>[].obs;

  void paymentStatus(paymentId) {
    ApiService().getPaymentStatus(paymentId).then((value) async {
      if (value['data']['Status'] != null) {
        Get.defaultDialog(
          barrierDismissible: false,
          onWillPop: () async => false,
          title: "",
          titleStyle: CustomTextStyle.textRobotoSansBold.copyWith(
            color: AppColors.appbarColor,
            fontSize: 0,
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: value['data']['Status'] == "Pending" || value['data']['Status'] == "InProcess"
                      ? Colors.yellow.shade600
                      : value['data']['Status'] == "Success"
                          ? Colors.green
                          : Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    value['data']['Status'] == "Pending"
                        ? Icons.pending_actions
                        : value['data']['Status'] == "Success"
                            ? Icons.check_rounded
                            : value['data']['Status'] == "InProcess"
                                ? Icons.check_rounded
                                : Icons.close,
                    color: AppColors.white,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Payment ${value['data']['Status'] == "Pending" ? "Pending" : value['data']['Status'] == "Success" ? "Successful" : value['data']['Status'] == "InProcess" ? "Processing" : "Failed"}",
                style: CustomTextStyle.textRobotoSansBold.copyWith(
                  color: value['data']['Status'] == "Pending" || value['data']['Status'] == "InProcess"
                      ? Colors.yellow.shade600
                      : value['data']['Status'] == "Success"
                          ? Colors.green
                          : Colors.red,
                ),
              ),
              Visibility(visible: value['data']['Status'] == "Success", child: const SizedBox(height: 10)),
              Visibility(
                visible: value['data']['Status'] == "Success",
                child: Text(
                  "We have received the payment of",
                  style: CustomTextStyle.textRobotoSansMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Visibility(
                visible: value['data']['Amount'] != null,
                child: Text(
                  "\n₹ ${value['data']['Amount']}",
                  style: CustomTextStyle.textRobotoSansBold.copyWith(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RoundedCornerButton(
                  text: "OK".tr,
                  color: AppColors.appbarColor,
                  borderColor: AppColors.appbarColor,
                  fontSize: Dimensions.h15,
                  fontWeight: FontWeight.w500,
                  fontColor: AppColors.white,
                  letterSpacing: 0,
                  borderRadius: Dimensions.r5,
                  borderWidth: 0,
                  textStyle: CustomTextStyle.textGothamMedium,
                  onTap: () {
                    getUserBalance();
                    walletBalance.refresh();
                    Get.offAllNamed(AppRoutName.dashBoardPage);
                  },
                  height: 40,
                  width: Get.width / 2.8,
                ),
              )
            ],
          ),
        );
      } else {
        AppUtils.showErrorSnackBar(bodyText: value["message"]);
      }
    });
  }
}
