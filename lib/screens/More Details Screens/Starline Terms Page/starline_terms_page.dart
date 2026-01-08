import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../helper_files/app_colors.dart';
import '../../../helper_files/custom_text_style.dart';
import '../../../helper_files/dimentions.dart';
import '../../../helper_files/ui_utils.dart';
import 'controller/starline_terms_page_controller.dart';

class StarlineTermsPage extends StatelessWidget {
  StarlineTermsPage({super.key});
  var controller = Get.put(StarlineTermsPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppUtils().simpleAppbar(appBarTitle: "STARLINETERMSANDCONDITIONS".tr),
      body: Padding(
        padding: EdgeInsets.all(Dimensions.r8),
        child: Column(
          children: [
            SizedBox(
              height: Dimensions.h10,
            ),
            Text(
              "STARLINE_TEXT".tr,
              style: CustomTextStyle.textPTsansMedium.copyWith(
                fontSize: Dimensions.h13,
              ),
            ),
            SizedBox(
              height: Dimensions.h15,
            ),
            Text(
              "STARLINE_TEXT2".tr,
              style: CustomTextStyle.textPTsansMedium.copyWith(
                fontSize: Dimensions.h13,
              ),
            ),
            SizedBox(
              height: Dimensions.h15,
            ),
            Text(
              "STARLINE_TEXT3".tr,
              style: CustomTextStyle.textPTsansMedium.copyWith(
                fontSize: Dimensions.h13,
              ),
            ),
            SizedBox(
              height: Dimensions.h10,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, Dimensions.r100, 0),
              child: Text(
                "STARLINEGAMEWINRATIO2".tr,
                style: CustomTextStyle.textPTsansBold.copyWith(
                  color: AppColors.grey,
                  fontSize: Dimensions.h18,
                ),
              ),
            ),
            const Divider(
              thickness: 1,
            ),
            starlineGameWinRatio()
          ],
        ),
      ),
    );
  }

  Widget starlineGameWinRatio() {
    return Obx(
      () => controller.starlineMarketModel.value.data == null
          ? SizedBox(
              height: 250,
              child: Center(
                child: Text(
                  "There is no Data",
                  style: CustomTextStyle.textRobotoSansMedium,
                ),
              ),
            )
          : Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.starlineMarketModel.value.data?.length,
                itemBuilder: (context, index) {
                  return listTile(
                    titleText: controller.starlineMarketModel.value.data
                            ?.elementAt(index)
                            .name ??
                        '',
                    trailing:
                        "${controller.starlineMarketModel.value.data?.elementAt(index).baseRate ?? ""} KA ${controller.starlineMarketModel.value.data?.elementAt(index).rate ?? ""}",
                  );
                },
              ),
            ),
    );
  }

  Widget listTile({required String titleText, required String trailing}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(Dimensions.h9),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  titleText,
                  style: CustomTextStyle.textPTsansMedium.copyWith(
                    color: AppColors.black,
                    fontSize: Dimensions.h18,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  trailing,
                  style: CustomTextStyle.textPTsansMedium.copyWith(
                    color: AppColors.black,
                    fontSize: Dimensions.h15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
