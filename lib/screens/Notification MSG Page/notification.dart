import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helper_files/app_colors.dart';
import '../../helper_files/custom_text_style.dart';
import '../../helper_files/dimentions.dart';
import '../../helper_files/ui_utils.dart';
import 'controller/notification_controller.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({super.key});
  var verticalSpace = SizedBox(
    height: Dimensions.h10,
  );
  var controller = Get.put(NotificationController());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppUtils().simpleAppbar(appBarTitle: "NOTIFICATIONS".tr),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                verticalSpace,
                Expanded(
                    child: Obx(
                  () => ListView.builder(
                    itemCount: controller.notificationData.length,
                    itemBuilder: (context, index) {
                      return notificationWidget(size,
                          notifiactionHeder: controller.notificationData[index].title ?? "",
                          notifiactionSubTitle: controller.notificationData[index].description ?? "");
                    },
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget notificationWidget(Size size, {required String notifiactionHeder, required String notifiactionSubTitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              spreadRadius: 1,
              color: AppColors.grey.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 0),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                gradient: LinearGradient(
                  colors: [AppColors.wpColor1, AppColors.wpColor2],
                ),
              ),
              child: Center(
                child: Text(
                  notifiactionHeder,
                  style: CustomTextStyle.textRobotoSansBold.copyWith(
                    color: AppColors.white,
                    fontSize: Dimensions.h14,
                  ),
                ),
              ),
            ),
            SizedBox(height: Dimensions.h5),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dear Players,",
                    textAlign: TextAlign.start,
                    style: CustomTextStyle.textRobotoSansLight.copyWith(
                      color: AppColors.black,
                      fontSize: Dimensions.h13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Dimensions.h5),
                  Text(
                    notifiactionSubTitle.trim(),
                    textAlign: TextAlign.start,
                    style: CustomTextStyle.textRobotoSansLight.copyWith(
                      color: AppColors.black,
                      fontSize: Dimensions.h13,
                    ),
                  ),
                  SizedBox(height: Dimensions.h5),
                  Text(
                    "Regards",
                    textAlign: TextAlign.start,
                    style: CustomTextStyle.textRobotoSansLight.copyWith(
                      color: AppColors.black,
                      fontSize: Dimensions.h13,
                    ),
                  ),
                  Text(
                    "SPL ADMIN",
                    textAlign: TextAlign.start,
                    style: CustomTextStyle.textRobotoSansLight.copyWith(
                      color: AppColors.black,
                      fontSize: Dimensions.h13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
