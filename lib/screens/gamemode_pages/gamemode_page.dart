import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';


import '../../Custom Controllers/wallet_controller.dart';
import '../../helper_files/app_colors.dart';
import '../../helper_files/constant_image.dart';
import '../../helper_files/custom_text_style.dart';
import '../../helper_files/dimentions.dart';
import 'controller/game_pages_controller.dart';

class GameModePage extends StatelessWidget {
  GameModePage({super.key});
  final controller = Get.put(GameModePagesController());
  final walletController = Get.put(WalletController());
  @override
  Widget build(BuildContext context) {
    controller.checkBids();
    Size size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        controller.onBackButton();
        walletController.walletBalance.refresh();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,

        appBar: AppBar(
          backgroundColor: AppColors.appbarColor,
          shadowColor: AppColors.white,
          elevation: 0,
          centerTitle: false,
          title: Text(
            controller.marketValue.value.market ?? "",
            style: CustomTextStyle.textRobotoSansMedium.copyWith(color: AppColors.white),
          ),
          actions: [
            InkWell(
              onTap: () {
                //  Get.offAndToNamed(AppRoutName.transactionPage);
              },
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
                        walletController.walletBalance.toString(),
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
        // appBar: AppUtils().simpleAppbar(
        //   appBarTitle: controller.marketValue.value.market ?? "",
        //   centerTitle: false,
        //   leading: IconButton(
        //     onPressed: () => controller.onBackButton(),
        //     icon: const Icon(Icons.arrow_back),
        //   ),
        //   actions: [
        //     InkWell(
        //       onTap: () {
        //         //  Get.offAndToNamed(AppRoutName.transactionPage);
        //       },
        //       child: Row(
        //         children: [
        //           SizedBox(
        //             height: Dimensions.h20,
        //             width: Dimensions.w25,
        //             child: SvgPicture.asset(
        //               ConstantImage.walletAppbar,
        //               color: AppColors.white,
        //               fit: BoxFit.fill,
        //             ),
        //           ),
        //           Padding(
        //             padding: EdgeInsets.only(
        //               top: Dimensions.r8,
        //               bottom: Dimensions.r5,
        //               left: Dimensions.r10,
        //               right: Dimensions.r10,
        //             ),
        //             child: Obx(
        //               () => Text(
        //                 walletController.walletBalance.toString(),
        //                 style: CustomTextStyle.textRobotoSansMedium.copyWith(
        //                   color: AppColors.white,
        //                   fontSize: Dimensions.h17,
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
        body: Obx(
          () {
            return SizedBox(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => Row(
                      children: [
                        openCloseMarket(
                          textColor:
                              controller.openCloseValue.value == "OPENBID".tr ? AppColors.white : AppColors.black,
                          "${"OPENBID".tr.toUpperCase()} : ${controller.marketValue.value.openTime.toString()}",
                          onTap: () async {
                            if (controller.openBiddingOpen.value && controller.openCloseValue.value != "OPENBID".tr) {
                              controller.openCloseValue.value = "OPENBID".tr;
                              controller.callGetGameModes();
                            }
                          },
                          containerColor: controller.openCloseValue.value == "OPENBID".tr
                              ? AppColors.appbarColor
                              : AppColors.openclose,
                        ),
                        openCloseMarket(
                          "${"CLOSEBID".tr.toUpperCase()} : ${controller.marketValue.value.closeTime.toString()}",
                          onTap: () async {
                            if (controller.openCloseValue.value != "CLOSEBID".tr) {
                              controller.openCloseValue.value = "CLOSEBID".tr;
                              controller.callGetGameModes();
                            }
                            controller.onTapOpenClose;
                          },
                          containerColor: controller.openCloseValue.value == "CLOSEBID".tr
                              ? AppColors.appbarColor
                              : AppColors.openclose,
                          textColor:
                              controller.openCloseValue.value == "CLOSEBID".tr ? AppColors.white : AppColors.black,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  cardWidget(controller, size),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  openCloseMarket(
    String text, {
    required Function() onTap,
    Color? containerColor,
    required Color textColor,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.zero,
            height: Dimensions.h35,
            decoration: BoxDecoration(
              color: containerColor,
              boxShadow: [
                BoxShadow(
                  spreadRadius: 0.2,
                  blurRadius: 0.8,
                  color: AppColors.grey.withOpacity(0.6),
                  offset: const Offset(0, 4),
                )
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    text,
                    style: CustomTextStyle.textRobotoSansMedium.copyWith(color: textColor, fontSize: Dimensions.h10),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget cardWidget(GameModePagesController controller, Size size) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        itemCount: controller.gameModesList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisExtent: Dimensions.h130, crossAxisSpacing: 5, mainAxisSpacing: 2),
        itemBuilder: (context, index) {
          return Padding(
            padding: index % 2 == 0
                ? const EdgeInsets.only(left: 25, top: 10, bottom: 5, right: 7)
                : const EdgeInsets.only(top: 10, bottom: 5, right: 25, left: 7),
            child: InkWell(
              onTap: () => controller.onTapOfGameModeTile(index),
              child: Container(
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
                  borderRadius: BorderRadius.circular(Dimensions.r15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: Dimensions.w55,
                      width: Dimensions.w55,
                      decoration: BoxDecoration(
                        color: AppColors.wpColor1,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(17.0),
                        child: Image.network(
                          controller.gameModesList.elementAt(index).image.toString(),
                          height: Dimensions.h10,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error);
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.h17,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: SizedBox(
                        width: size.width,
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              controller.gameModesList.elementAt(index).name ?? "",
                              style: CustomTextStyle.textRobotoSansBold.copyWith(fontSize: Dimensions.h14),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}
