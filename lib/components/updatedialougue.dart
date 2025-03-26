import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ota_update/ota_update.dart';

import '../api_services/api_urls.dart';
import '../helper_files/app_colors.dart';
import '../helper_files/custom_text_style.dart';
import '../helper_files/dimentions.dart';
import '../helper_files/ui_utils.dart';

class UpdateDialog extends StatelessWidget {
  final RxBool load = false.obs;
  final RxString percentage = "0".obs;

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    return WillPopScope(
      onWillPop: () async => false, // Prevent closing dialog with back button
      child: SafeArea(
        child: Container(
          height: Get.height,
          width: Get.width,
          color: Colors.black.withOpacity(0.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Update App",
                        textAlign: TextAlign.center,
                        style: CustomTextStyle.textRobotoSansMedium.copyWith(color: Colors.black, fontSize: Dimensions.h20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "An update is available! Click here to upgrade.",
                        textAlign: TextAlign.center,
                        style: CustomTextStyle.textRobotoSansMedium.copyWith(fontSize: Dimensions.h14, color: Colors.black),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () async {
                          // launch("https://spl.live");
                          print("fdsfksjfhkfsfkjshfsjdhfkdsfs");
                          // downloadApk(ApiUtils.getApk);
                          try {
                            OtaUpdate().execute(ApiUtils.getApk).listen(
                              (OtaEvent event) {
                                if (event.status == OtaStatus.DOWNLOADING) {
                                  print("fsdfkjdshfksjdfhk");
                                  print(event.value);
                                  percentage.value = event.value!;
                                  load.value = true;
                                } else if (event.status == OtaStatus.CANCELED) {
                                  load.value = false;
                                  AppUtils.showErrorSnackBar(bodyText: "Download Canceled");
                                } else if (event.status == OtaStatus.DOWNLOAD_ERROR) {
                                  load.value = false;
                                  AppUtils.showErrorSnackBar(bodyText: "Download error");
                                } else if (event.status == OtaStatus.INTERNAL_ERROR) {
                                  load.value = false;
                                  AppUtils.showErrorSnackBar(bodyText: "Something went wrong");
                                } else if (event.status == OtaStatus.PERMISSION_NOT_GRANTED_ERROR) {
                                  load.value = false;
                                } else {
                                  load.value = false;
                                }
                              },
                              onDone: () => load.value = false,
                            );
                          } catch (e) {
                            print('Failed to make OTA update. Details: $e');
                          }
                        },
                        child: Container(
                          color: AppColors.appbarColor,
                          height: Dimensions.h40,
                          width: Dimensions.w200,
                          child: Obx(
                            () => Center(
                              child: load.value
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Downloading ${percentage.value}%',
                                          style: CustomTextStyle.textRobotoSansBold.copyWith(
                                            color: AppColors.white,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Container(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: AppColors.white,
                                              strokeWidth: 2,
                                            )),
                                      ],
                                    )
                                  : Text(
                                      'Download',
                                      style: CustomTextStyle.textRobotoSansBold.copyWith(
                                        color: AppColors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
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
}
