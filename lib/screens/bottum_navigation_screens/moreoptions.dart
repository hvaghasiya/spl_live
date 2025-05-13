import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:spllive/Custom%20Controllers/wallet_controller.dart';
import 'package:spllive/controller/home_controller.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/routes/app_routes_name.dart';

import '../../helper_files/constant_image.dart';
import 'controller/bottum_navigation_controller.dart';

class MoreOptions extends StatefulWidget {
  const MoreOptions({super.key});

  @override
  State<MoreOptions> createState() => _MoreOptionsState();
}

class _MoreOptionsState extends State<MoreOptions> {
  final controller = Get.put(MoreListController());
  final homeController = Get.find<HomeController>();
  final walletCon = Get.put<WalletController>(WalletController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppUtils().simpleAppbar(
          appBarTitle: "MORE".tr,
          centerTitle: true,
          appBarTitlestyle: CustomTextStyle.textRobotoMedium.copyWith(
            fontSize: Dimensions.h18,
            color: AppColors.white,
          ),
          // leadingWidht: Dimensions.w200,
          // leading: Row(
          //   children: [
          //     SizedBox(width: Dimensions.w15),
          //     Text(
          //       "MORE".tr,
          //       style: CustomTextStyle.textRobotoSansMedium.copyWith(
          //         fontSize: Dimensions.h18,
          //         color: AppColors.white,
          //       ),
          //     ),
          //   ],
          // ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: InkWell(
                onTap: () => controller.toggleShare(),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.share,
                      size: 13,
                      color: AppColors.appbarColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: Dimensions.h10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: Dimensions.w10),
                    SizedBox(
                      child: Icon(
                        Icons.person_outline,
                        color: AppColors.appbarColor,
                        size: 60,
                      ),
                      // child: Image.asset(
                      //   ConstantImage.splLogo,
                      //   fit: BoxFit.contain,
                      // ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "User Name : ${controller.userData.userName ?? ""}",
                            // style: TextStyle(fontSize: 17, color: AppColors.black),\
                            textAlign: TextAlign.start,
                            style: CustomTextStyle.textRobotoSansMedium.copyWith(
                              fontSize: Dimensions.h15,
                            ),
                          ),
                          Text(
                            "Mobile No : ${controller.userData.phoneNumber ?? ""} ",
                            // style: TextStyle(fontSize: 17, color: AppColors.black),\
                            textAlign: TextAlign.start,
                            style: CustomTextStyle.textRobotoSansMedium.copyWith(
                              fontSize: Dimensions.h15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(color: AppColors.grey, endIndent: 10, indent: 20),
                SizedBox(height: Dimensions.h5),
                listItems(
                    onTap: () => Get.toNamed(AppRoutName.profilePage),
                    iconData: ConstantImage.bankAccountNew,
                    text: "Change Password".tr),
                listItems(
                    onTap: () {
                      homeController.pageWidget.value = 2;

                      walletCon.selectedIndex.value = null;
                    },
                    iconData: ConstantImage.walletAppbar,
                    text: "Wallet".tr),
                listItems(
                    onTap: () {
                      homeController.pageWidget.value = 1;

                      // homeController.marketBidsByUserId();
                    },
                    iconData: ConstantImage.clockIcon,
                    text: "Bid History".tr),
                listItems(
                    onTap: () {
                      homeController.pageWidget.value = 2;

                      walletCon.selectedIndex.value = 2;
                    },
                    iconData: ConstantImage.addBankDeatils,
                    text: "Add Bank Details"),
                listItems(
                    onTap: () {
                      homeController.pageWidget.value = 2;

                      walletCon.selectedIndex.value = 0;
                    },
                    iconData: ConstantImage.plusIcon,
                    text: "ADDFUND".tr),
                listItems(
                    onTap: () => Get.toNamed(AppRoutName.gameRatePage),
                    iconData: ConstantImage.gameRate,
                    text: "GAMERATE".tr),
                listItems(
                    onTap: () => Get.toNamed(AppRoutName.notificationDetailsPage),
                    iconData: ConstantImage.notifiacation,
                    text: "NOTIFICATIONS".tr),
                // listItems(
                //     onTap: () {
                //       GetStorage().write(ConstantsVariables.withDrawal, true);
                //       homeController.pageWidget.value = 2;
                //       homeController.currentIndex.value = 2;
                //       // Get.toNamed(AppRoutName.withdrawalpage);
                //     },
                //     iconData: ConstantImage.withDrawalIcon,
                //     text: "WITHDRAWAL_TXT1".tr),
                // listItems(
                //     onTap: () => Get.toNamed(AppRoutName.transactionPage),
                //     iconData: ConstantImage.addFundIcon,
                //     text: "TRANSACTIONHISTORY".tr),
                listItems(
                  onTap: () => Get.toNamed(AppRoutName.feedBackPage),
                  iconData: ConstantImage.giveFeedbackIcon,
                  text: "GIVEFEEDBACK".tr,
                ),
                listItems(
                  onTap: () => controller.getFeedbackAndRatingsById(),
                  iconData: ConstantImage.rateNew,
                  text: "RATEUS".tr,
                ),
                // listItems(
                //   onTap: () => Get.toNamed(AppRoutName.aboutPage),
                //   iconData: ConstantImage.infoIcon,
                //   text: "ABOUTUS".tr,
                // ),
                listItems(
                  onTap: () => controller.callLogout(),
                  iconData: ConstantImage.logoutNew,
                  text: "Log Out",
                ),
              ],
            ),
          ),
        ),
        Text(
          "Version: 2.0.1",
          textAlign: TextAlign.center,
          style: CustomTextStyle.textRobotoSansMedium
              .copyWith(fontSize: Dimensions.h14, color: AppColors.textColor, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

Widget listItems({required Function() onTap, required String iconData, required String text}) {
  return InkWell(
    onTap: onTap,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: Dimensions.h30,
          child: Row(
            children: [
              SizedBox(width: Dimensions.w20),
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: SizedBox(
                  // color: Colors.amber,
                  height: Dimensions.h20,
                  width: Dimensions.w20,
                  child: SvgPicture.asset(
                    iconData,
                    color: AppColors.appbarColor,
                  ),
                ),
              ),
              SizedBox(
                width: Dimensions.w15,
              ),
              Text(text,
                  style:
                      CustomTextStyle.textRobotoMedium.copyWith(fontSize: Dimensions.h14, fontWeight: FontWeight.w500))
            ],
          ),
        ),
        Divider(
          color: AppColors.grey,
          endIndent: 50,
          indent: 20,
        )
      ],
    ),
  );
}
