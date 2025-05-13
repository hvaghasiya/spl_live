import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Custom Controllers/wallet_controller.dart';
import '../../components/common_appbar.dart';
import '../../components/common_wallet_list.dart';
import '../../helper_files/app_colors.dart';
import '../../helper_files/custom_text_style.dart';
import '../../helper_files/dimentions.dart';
import '../More Details Screens/Withdrawal Page/withdrawal_page.dart';
import '../fund_deposit_history.dart';
import '../home_screen/add_fund.dart';
import '../new_ui/bottom_bar_screens/home_screens/add_bank_details.dart';
import '../new_ui/bottom_bar_screens/home_screens/fund_withdrawal_history.dart';

class SPLWallet extends StatefulWidget {
  const SPLWallet({super.key, this.selectedIndex});

  final selectedIndex;

  @override
  State<SPLWallet> createState() => _SPLWalletState();
}

class _SPLWalletState extends State<SPLWallet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(
        init: WalletController()..init(widget.selectedIndex),
        builder: (controller) {
          return Scaffold(
            body: Column(
              children: [
                Obx(
                  () => controller.selectedIndex.value == null
                      ? CommonAppBar(
                          walletBalance: controller.walletBalance.value,
                          title: "WALLET".tr,
                          titleTextStyle: CustomTextStyle.textRobotoSansMedium.copyWith(
                            fontSize: Dimensions.h16,
                            color: AppColors.white,
                          ),
                        )
                      : appbarWidget(controller),
                ),
                Obx(
                  () => controller.selectedIndex.value != null
                      ? currentWidget(controller.selectedIndex.value)
                      : Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: controller.filterDateList.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) => CommonWalletList(
                                title: controller.filterDateList[index].name,
                                image: controller.filterDateList[index].image,
                                onTap: () {
                                  // if (walletCon.filterDateList[index].name == "Withdrawal Fund") {
                                  //   homeCon.pageWidget.value = 5;
                                  //   homeCon.currentIndex.value = 5;
                                  // } else {
                                  controller.selectedIndex.value = index;
                                  // }
                                },
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          );
        });
  }

  currentWidget(index) {
    switch (index) {
      case 0:
        return const AddFund();
      case 1:
        return WithdrawalPage();
      case 2:
        return const AddBankDetails();
      case 3:
        return FundDipositHistory();
      case 4:
        return const FundWithdrawalHistory();
      /* case 5:
       return const BankChangeHistory();*/
    }
  }

  appbarWidget(controller) {
    return Container(
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
                    onTap: () {
                      controller.selectedIndex.value = null;
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back, color: AppColors.white)),
                const SizedBox(width: 5),
              ],
            ),
            const Expanded(child: SizedBox()),
            Text(
              textAlign: TextAlign.center,
              controller.selectedIndex.value == 0
                  ? "Add Fund"
                  : controller.selectedIndex.value == 1
                      ? "Withdrawal Fund"
                      : controller.selectedIndex.value == 2
                          ? "Add Bank Details"
                          : controller.selectedIndex.value == 3
                              ? "Fund Deposit History"
                              : controller.selectedIndex.value == 4
                                  ? "Fund Withdrawal History"
                                  : "",
              style: CustomTextStyle.textRobotoMedium.copyWith(
                color: AppColors.white,
                fontSize: Dimensions.h17,
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
