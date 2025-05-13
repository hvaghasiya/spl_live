import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ota_update/ota_update.dart';
import 'package:spllive/components/DeviceInfo/device_info.dart';
import 'package:spllive/routes/app_routes_name.dart';

import '../../../api_services/api_service.dart';
import '../../../api_services/api_urls.dart';
import '../../../components/DeviceInfo/device_information_model.dart';
import '../../../helper_files/app_colors.dart';
import '../../../helper_files/constant_variables.dart';
import '../../../helper_files/custom_text_style.dart';
import '../../../helper_files/dimentions.dart';
import '../../../helper_files/ui_utils.dart';
import '../../../models/commun_models/user_details_model.dart';

class SplashController extends GetxController {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  UserDetailsModel _userDetailsModel = UserDetailsModel();
  DeviceInformationModel? deviceInfo;
  String appVersion = "";
  RxString city = ''.obs;
  RxString country = ''.obs;
  RxString state = ''.obs;
  RxString street = ''.obs;
  RxString postalCode = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // getLocation();
    checkLogin();
    getDeviceInfo();
    // Timer(Duration(milliseconds: 700), () {});
  }

  // Future<void> getLocation() async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //     List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
  //
  //     if (placemarks.isNotEmpty) {
  //       Placemark placemark = placemarks[0];
  //       city.value = placemark.locality ?? 'Unknown';
  //       country.value = placemark.country ?? 'Unknown';
  //       state.value = placemark.administrativeArea ?? 'Unknown';
  //       street.value = "${placemark.street ?? 'Unknown'} ${placemark.subLocality ?? 'Unknown'}";
  //       postalCode.value = placemark.postalCode ?? 'Unknown';
  //       List<PlaceMark> letestLocation = [
  //         PlaceMark(
  //           name: 'Place 1',
  //           location: LocationModel(
  //               city: city.value,
  //               country: country.value,
  //               state: state.value,
  //               street: street.value,
  //               postalCode: postalCode.value),
  //         ),
  //       ];
  //       List<Map<String, dynamic>> placeMarkJsonList = letestLocation
  //           .map((placeMark) => {
  //                 'name': placeMark.name,
  //                 'location': placeMark.location?.toJson(),
  //               })
  //           .toList();
  //       GetStorage().write(ConstantsVariables.locationData, placeMarkJsonList);
  //       var storedPlaceMarkJsonList = GetStorage().read(ConstantsVariables.locationData) ?? [];
  //     }
  //   } catch (e) {
  //     print('Error getting location: $e');
  //   }
  // }

  callFcmApi(userId) {
    var token = GetStorage().read(ConstantsVariables.fcmToken);
    Timer(const Duration(milliseconds: 500), () {
      fsmApiCall(userId, token);
    });
  }

  fcmBody(userId, fcmToken) {
    var a = {
      "id": userId,
      "fcmToken": fcmToken,
    };
    return a;
  }

  void fsmApiCall(userId, fcmToken) async {
    ApiService().fcmToken(await fcmBody(userId, fcmToken)).then((value) async {
      if (value['status']) {
        // AppUtils.showSuccessSnackBar(
        //     bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  getDeviceInfo() async {
    DeviceInformationModel deviceInfo = await DeviceInfo().initPlatformState();
    appVersion = deviceInfo.appVersion.toString();
  }

  void appVersionCheck() async {
    ApiService().getAppVersion().then((value) async {
      print(appVersion);
      print(value);
      if (value != null) {
        if (value['status']) {
          if (value['data'] != appVersion) {
            // print(value['data']);
            _showExitDialog();
          }
        } else {
          AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
        }
      }
    });
  }

  Future<void> checkLogin() async {
    print(GetStorage().read(ConstantsVariables.authToken));
    print("Fsdljkfhsdfsdjflk");
    bool alreadyLoggedIn = await getStoredUserData();
    bool isActive = GetStorage().read(ConstantsVariables.isActive) ?? false;
    bool isVerified = GetStorage().read(ConstantsVariables.isVerified) ?? false;
    bool hasMPIN = GetStorage().read(ConstantsVariables.isMpinSet) ?? false;
    bool isUserDetailSet = GetStorage().read(ConstantsVariables.isUserDetailSet) ?? false;

    if (alreadyLoggedIn) {
      // if (isActive && isVerified) {
      //   //   callFcmApi(_userDetailsModel.id);
      //   Future.delayed(const Duration(seconds: 2), () {
      //     Get.offAllNamed(AppRoutName.verifyOTPPage);
      //     Timer(const Duration(milliseconds: 500), () {
      //       appVersionCheck();
      //       //   requestLocationPermission();
      //     });
      //   });
      // } else
      // if (!hasMPIN && !isUserDetailSet) {
      //   //   callFcmApi(_userDetailsModel.id);
      //   Future.delayed(const Duration(seconds: 2), () {
      //     Get.offAllNamed(AppRoutName.userDetailsPage);
      //     Timer(const Duration(milliseconds: 500), () {
      //       appVersionCheck();
      //       //  requestLocationPermission();
      //     });
      //   });
      // } else {
      if (hasMPIN && isActive && isVerified && isUserDetailSet) {
        callFcmApi(_userDetailsModel.id);
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAllNamed(AppRoutName.mPINPage, arguments: {"id": _userDetailsModel.id});
          Timer(const Duration(milliseconds: 500), () => appVersionCheck());
        });
      } else {
        Future.delayed(const Duration(seconds: 2), () {
          // Get.offAllNamed(AppRoutes.dashboardPage);
          Get.offAllNamed(AppRoutName.walcomeScreen);
          Timer(const Duration(milliseconds: 500), () => appVersionCheck());
        });
      }
      // } else {
      //   Future.delayed(const Duration(seconds: 2), () {
      //     Get.offAllNamed(AppRoutName.signInPage, arguments: {"id": _userDetailsModel.id});
      //     Timer(const Duration(milliseconds: 500), () {
      //       appVersionCheck();
      //       //  requestLocationPermission();
      //     });
      //   });
      // }
      // }
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        // Get.offAllNamed(AppRoutes.dashboardPage);
        Get.offAllNamed(AppRoutName.walcomeScreen);
        Timer(const Duration(milliseconds: 500), () => appVersionCheck());
      });
    }
  }

  Future<bool> getStoredUserData() async {
    String? authToken = GetStorage().read(ConstantsVariables.authToken);
    final userData = GetStorage().read(ConstantsVariables.userData);
    if (authToken != null && authToken.isNotEmpty) {
      if (userData != null) {
        _userDetailsModel = UserDetailsModel.fromJson(userData);
      }
      return true;
    } else {
      return false;
    }
  }

  RxBool load = false.obs;

  void _showExitDialog() {
    Get.defaultDialog(
      barrierDismissible: false,
      title: "Update App",
      onWillPop: () async => false,
      titleStyle: CustomTextStyle.textRobotoSansMedium,
      content: Column(
        children: [
          Text(
            "An update is available! Click here to upgrade.",
            textAlign: TextAlign.center,
            style: CustomTextStyle.textRobotoSansMedium.copyWith(
              fontSize: Dimensions.h14,
            ),
          )
        ],
      ),
      actions: [
        InkWell(
          onTap: () async {
            load.value = true;
            // launch("https://spl.live");
            try {
              OtaUpdate().execute(ApiUtils.getApk).listen(
                (OtaEvent event) {
                  if (event.status == OtaStatus.DOWNLOADING) {
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
                  update();
                },
                onDone: () => load.value = false,
              );
            } catch (e) {
              print('Failed to make OTA update. Details: $e');
            }
            update();
          },
          child: Container(
            color: AppColors.appbarColor,
            height: Dimensions.h40,
            width: Dimensions.w200,
            child: Obx(
              () => Center(
                child: load.value
                    ? CircularProgressIndicator(color: AppColors.white)
                    : Text(
                        'OK',
                        style: CustomTextStyle.textRobotoSansBold.copyWith(
                          color: AppColors.white,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
