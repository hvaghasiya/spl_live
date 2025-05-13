import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helper_files/app_colors.dart';
import '../../../helper_files/custom_text_style.dart';
import '../../../helper_files/dimentions.dart';
import '../../../helper_files/ui_utils.dart';
import 'controller/game_rate_page_controller.dart';

class GameRatePage extends StatefulWidget {
  GameRatePage({super.key});

  @override
  State<GameRatePage> createState() => _GameRatePageState();
}

class _GameRatePageState extends State<GameRatePage> {
  final controller = Get.put(GameRatePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppUtils().simpleAppbar(appBarTitle: "Game Rates"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(Dimensions.r5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.25),
                      offset: const Offset(0, 0),
                      blurRadius: 5,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        "MARKETGAMEWINRATIO".tr,
                        textAlign: TextAlign.center,
                        style: CustomTextStyle.textPTsansMedium.copyWith(
                          color: AppColors.appbarColor,
                          fontSize: Dimensions.h18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Obx(
                      () => ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => Row(
                          children: [
                            Expanded(
                              child: Text(
                                controller.normalMarketModel.value.data?[index].name ?? "",
                                style: CustomTextStyle.textAllerta.copyWith(
                                  color: AppColors.black,
                                  fontSize: Dimensions.h14,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${controller.normalMarketModel.value.data?[index].baseRate ?? ""} = ${controller.normalMarketModel.value.data?.elementAt(index).rate ?? ""}",
                                textAlign: TextAlign.start,
                                style: CustomTextStyle.textAllerta.copyWith(
                                  color: AppColors.black,
                                  fontSize: Dimensions.h14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                        itemCount: controller.normalMarketModel.value.data?.length ?? 0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(Dimensions.r5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.25),
                      offset: const Offset(0, 0),
                      blurRadius: 5,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "STARLINEGAMEWINRATIO".tr,
                        textAlign: TextAlign.center,
                        style: CustomTextStyle.textPTsansMedium.copyWith(
                            color: AppColors.appbarColor, fontSize: Dimensions.h18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Obx(
                      () => ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Row(
                          children: [
                            Expanded(
                              child: Text(
                                controller.starlineMarketModel.value.data?[index].name ?? "",
                                style: CustomTextStyle.textAllerta.copyWith(
                                  color: AppColors.black,
                                  fontSize: Dimensions.h14,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${controller.starlineMarketModel.value.data?[index].baseRate ?? ""} = ${controller.normalMarketModel.value.data?.elementAt(index).rate ?? ""}",
                                textAlign: TextAlign.start,
                                style: CustomTextStyle.textAllerta.copyWith(
                                  color: AppColors.black,
                                  fontSize: Dimensions.h14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                        itemCount: controller.starlineMarketModel.value.data?.length ?? 0,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget marketWinRatio() {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.normalMarketModel.value.data?.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(Dimensions.h9),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    controller.normalMarketModel.value.data?.elementAt(index).name ?? "",
                    style: CustomTextStyle.textAllerta.copyWith(
                      color: AppColors.black,
                      fontSize: Dimensions.h14,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${controller.normalMarketModel.value.data?.elementAt(index).baseRate ?? ""} = ${controller.normalMarketModel.value.data?.elementAt(index).rate ?? ""}",
                    style: CustomTextStyle.textAllerta.copyWith(
                      color: AppColors.black,
                      fontSize: Dimensions.h14,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget starlineGameWinRatio() {
  //   return Obx(
  //     () => ListView.builder(
  //       physics: const NeverScrollableScrollPhysics(),
  //       itemCount: controller.starlineMarketModel.value.data?.length,
  //       itemBuilder: (context, index) {
  //         return listTile(
  //           titleText: controller.starlineMarketModel.value.data?[index].name ?? '',
  //           trailing:
  //               "${controller.starlineMarketModel.value.data?[index].baseRate ?? ""} KA ${controller.starlineMarketModel.value.data?.elementAt(index).rate ?? ""}",
  //         );
  //       },
  //     ),
  //   );
  // }

  // Widget listTile({required String titleText, required String trailing}) {
  //   return Padding(
  //     padding: EdgeInsets.all(Dimensions.h9),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: Text(
  //             titleText,
  //             style: CustomTextStyle.textAllerta.copyWith(
  //               color: AppColors.black,
  //               fontSize: Dimensions.h14,
  //             ),
  //           ),
  //         ),
  //         Expanded(
  //           child: Text(
  //             trailing,
  //             style: CustomTextStyle.textAllerta.copyWith(
  //               color: AppColors.black,
  //               fontSize: Dimensions.h14,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
