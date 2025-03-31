import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ota_update/ota_update.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../api_services/api_service.dart';
import '../../../api_services/api_urls.dart';
import '../../../components/DeviceInfo/device_info.dart';
import '../../../components/DeviceInfo/device_information_model.dart';
import '../../../helper_files/app_colors.dart';
import '../../../helper_files/constant_variables.dart';
import '../../../helper_files/custom_text_style.dart';
import '../../../helper_files/dimentions.dart';
import '../../../helper_files/ui_utils.dart';
import '../../../models/commun_models/user_details_model.dart';
import '../../../routes/app_routes_name.dart';

class SplashController extends GetxController {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  UserDetailsModel _userDetailsModel = UserDetailsModel();
  DeviceInformationModel? deviceInfo;

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
    appVersion.value = deviceInfo.appVersion.toString();
  }

  void appVersionCheck() async {
    print("fsdfsdjkfsdkjfhskjfdf");
    ApiService().getAppVersion().then((value) async {
      print(appVersion.value);
      print(value);
      if (value != null) {
        if (value['status']) {
          if (value['data'] != appVersion.value) {
            // _showExitDialog();
            // print(value['data']);
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
  requestStoragePermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.manageExternalStorage, // Needed for Android 10+
      Permission.requestInstallPackages, // Required for APK installation
    ].request();
    print("fsdkfghskfjhsfkfskfdfsdf");
    print(statuses[Permission.storage]!.isGranted);
    print(statuses[Permission.manageExternalStorage]!.isGranted);
    print(statuses[Permission.requestInstallPackages]!.isGranted);
    if (statuses[Permission.storage]!.isGranted ||
        statuses[Permission.manageExternalStorage]!.isGranted ||
        statuses[Permission.requestInstallPackages]!.isGranted) {
      print("Storage permission granted.");
      return true;
    } else {
      print("Storage permission denied.");
      openAppSettings();
      return false;
    }
  }

  RxString percentage = "0.0".obs;
  downloadApk(String url) async {
    // requestStoragePermission();
    var res = await requestStoragePermission();
    print("skfjsfhksfjhsdkfjshdfkj");
    print(res);
    // final dir = Directory("/storage/emulated/0/Download");
    if (res) {
      load.value = true;
      final dir = await getTemporaryDirectory();
      final file = File('${dir!.path}/update.apk');
      print("djfhsgjhfsdf");
      print("djfhsgjhfsdf${file.path}");
      try {
        await Dio().download(url, file.path, onReceiveProgress: (value, value1) {
          print(value);
          print("fdsfjdsfdsfsfgjsdfh");
          print(value1);
          percentage.value = ((value / value1) * 100).toInt().toString();
        });

        const platform = MethodChannel("com.example.spllive/install_apk");
        final result = await platform.invokeMethod("installApk", {"apkPath": file.path});
        print(result);
      } on DioException catch (e) {
        print("ffjkdsfhskjfhskjfhsdf");
        print(e.response);
      }
      print("sdfsdfkjhsfkjhfkjsd");
    } else {
      print("fsdjfghfjshfgjsdfhgsdjf");
    }

    // installApkUsingPackageInstaller(file.path);
    // installApk(file.path);
    // return file.path;
  }

  void installApkUsingPackageInstaller(String filePath) async {
    final uri = 'content://com.example.spllive.fileprovider/cache/update.apk';

    // final intent = AndroidIntent(
    //   action: 'android.intent.action.VIEW',
    //   data: uri,
    //   type: 'application/vnd.android.package-archive',
    //   flags: <int>[Flag.FLAG_GRANT_READ_URI_PERMISSION, Flag.FLAG_ACTIVITY_NEW_TASK],
    // );
    // intent.launch();
  }

  // Future<void> installApk(String filePath) async {
  //   print("sdfsdfkjhsfkjhfkjsd");
  //   final result = await OpenFilex.open(filePath);
  //   print("fdsfkjsdhfksdjfhskjfhkfshkjf${result.type}");
  //   if (result.type == ResultType.done) {
  //     print("fsdjfgsjfs");
  //     load.value = false;
  //     // File file = File(filePath);
  //     // if (await file.exists()) {
  //     //   await file.delete();
  //     //   print("File deleted successfully: $filePath");
  //     // } else {
  //     //   print("File not found: $filePath");
  //     // }
  //     // Handle the error accordingly
  //   }
  // }

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
            // launch("https://spl.live");
            // downloadApk(ApiUtils.getApk);
            try {
              OtaUpdate().execute(ApiUtils.getApk).listen(
                (OtaEvent event) {
                  if (event.status == OtaStatus.DOWNLOADING) {
                    print("fsdfkjdshfksjdfhk");
                    print(event.value);
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
      ],
    );
  }
}
