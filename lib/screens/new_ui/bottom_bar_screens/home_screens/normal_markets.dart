import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../helper_files/app_colors.dart';
import '../../../../helper_files/constant_image.dart';
import '../../../../helper_files/custom_text_style.dart';
import '../../../../helper_files/dimentions.dart';
import '../../../../helper_files/ui_utils.dart';
import '../../../../models/daily_market_api_response_model.dart';
import '../../../../routes/app_routes_name.dart';

class NormalMarketsList extends StatelessWidget {
  final RxList<MarketData>? normalMarketList;
  const NormalMarketsList({super.key, this.normalMarketList});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => normalMarketList != null
          ? normalMarketList!.isNotEmpty
              ? Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: InkWell(
                        onTap: () => launch("https://wa.me/+917769826748/?text=hi"),
                        child: Container(
                          width: double.infinity,
                          height: Dimensions.h30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            gradient: LinearGradient(
                              colors: [AppColors.wpColor1, AppColors.wpColor2],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Image.asset(
                                  ConstantImage.whatsaapIcon,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "+91 7769826748",
                                style: CustomTextStyle.textRobotoMedium.copyWith(color: AppColors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.h5),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: Get.width / 2,
                        mainAxisExtent: Get.width / 2.4,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: normalMarketList?.length ?? 0,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.h5),
                          child: GestureDetector(
                            onTap: () => normalMarketList![i].isBidOpenForClose == true
                                ? normalMarketList![i].isBidOpenForClose ?? false
                                    ? Get.toNamed(AppRoutName.gameModePage, arguments: normalMarketList?[i])
                                    : AppUtils.showErrorSnackBar(bodyText: "Bidding is Closed!!!!")
                                : null,
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 0.2,
                                    color: AppColors.grey,
                                    blurRadius: 3.5,
                                    offset: const Offset(2, 4),
                                  )
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(Dimensions.h10),
                                border: Border.all(color: Colors.red, width: 1),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: Dimensions.h10),
                                  Text(
                                    "${normalMarketList![i].openTime ?? " "} | ${normalMarketList![i].closeTime ?? ""}",
                                    style: CustomTextStyle.textRobotoMedium.copyWith(fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    normalMarketList?[i].market ?? "",
                                    // "MADHUR DAY",
                                    style: CustomTextStyle.textRobotoMedium.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Dimensions.h14,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      buildResult(
                                          isOpenResult: true,
                                          resultDeclared: normalMarketList![i].isOpenResultDeclared ?? false,
                                          result: normalMarketList![i].openResult ?? 0),
                                      buildResult(
                                        isOpenResult: false,
                                        resultDeclared: normalMarketList![i].isCloseResultDeclared ?? false,
                                        result: normalMarketList![i].closeResult ?? 0,
                                      )
                                    ],
                                  ),
                                  Container(
                                    height: Dimensions.h25,
                                    width: Dimensions.w80,
                                    decoration: BoxDecoration(
                                        color: AppColors.blueButton, borderRadius: BorderRadius.circular(25)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        FittedBox(
                                          child: Padding(
                                            padding: EdgeInsets.only(left: Dimensions.w15, bottom: 2),
                                            child: Text(
                                              "PLAY2".tr,
                                              style: TextStyle(
                                                color: AppColors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        FittedBox(
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 3.0),
                                            child: Icon(Icons.play_circle_fill, color: AppColors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: Dimensions.h5),
                                  Container(
                                    height: Dimensions.h30,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade400.withOpacity(0.8),
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        normalMarketList![i].isBidOpenForClose == true
                                            ? "Bidding is Open"
                                            : "Bidding is Closed",
                                        style: normalMarketList![i].isBidOpenForClose == true
                                            ? CustomTextStyle.textPTsansMedium.copyWith(
                                                color: AppColors.greenShade,
                                                fontWeight: FontWeight.w500,
                                              )
                                            : CustomTextStyle.textPTsansMedium.copyWith(
                                                color: AppColors.redColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 5),
                  ],
                )
              : const Center(child: Text("No Data Found"))
          : const SizedBox(),
    );
  }

  Widget buildResult({required bool isOpenResult, required bool resultDeclared, required int result}) {
    if (resultDeclared && result != 0 && result.toString().isNotEmpty) {
      int sum = 0;
      for (int i = result; i > 0; i = (i / 10).floor()) {
        sum += (i % 10);
      }
      return Text(
        isOpenResult ? "$result - ${sum % 10}" : "${sum % 10} - $result",
        style: CustomTextStyle.textRobotoMedium.copyWith(
          fontSize: Dimensions.h13,
          fontWeight: FontWeight.bold,
          color: AppColors.redColor,
          letterSpacing: 1,
        ),
      );
    } else if (result == 0 && result.toString().isNotEmpty && resultDeclared) {
      return Text(
        isOpenResult ? "000 - $result" : "$result - 000",
        style: CustomTextStyle.textRobotoMedium.copyWith(
          fontSize: Dimensions.h13,
          fontWeight: FontWeight.bold,
          color: AppColors.redColor,
          letterSpacing: 1,
        ),
      );
    } else {
      return SvgPicture.asset(
        isOpenResult ? ConstantImage.openStarsSvg : ConstantImage.closeStarsSvg,
        width: Dimensions.w60,
      );
    }
  }
}
