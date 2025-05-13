import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:spllive/Push%20Notification/notificationservices.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/routes/app_routes_name.dart';

import '../../../api_services/api_service.dart';
import '../../../components/DeviceInfo/device_info.dart';
import '../../../components/DeviceInfo/device_information_model.dart';
import '../../../helper_files/constant_variables.dart';
import '../../../models/commun_models/user_details_model.dart';
import '../model/user_details_model.dart';

class SetMPINPageController extends GetxController {
  var arguments = Get.arguments;
  RxString mpin = "".obs;
  RxString confirmMpin = "".obs;
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  UserDetails userDetails = UserDetails();
  UserDetailsModel userData = UserDetailsModel();
  Timer? cursorTimer;
  bool _fromLoginPage = false;
  RxString city = ''.obs;
  RxString country = ''.obs;
  RxString state = ''.obs;
  RxString street = ''.obs;
  RxString postalCode = ''.obs;

  @override
  void onInit() {
    getArguments();
    super.onInit();
  }

  @override
  void dispose() {
    focusNode1.dispose();
    focusNode2.dispose();
    super.dispose();
  }

  void getArguments() {
    GetStorage().write(ConstantsVariables.starlineConnect, false);
    userDetails = arguments ?? UserDetails();
    if (userDetails.authToken != null && userDetails.userName != null) {
      userDetails = arguments;
      _fromLoginPage = false;
    } else {
      _fromLoginPage = true;
    }
  }

  void onTapOfContinue() {
    if (mpin.isEmpty) {
      AppUtils().accountFlowDialog(msg: "ENTERMPIN".tr);
      // AppUtils.showErrorSnackBar(bodyText: "ENTERMPIN".tr);
    } else if (mpin.value.length < 4) {
      AppUtils().accountFlowDialog(msg: "ENTERVALIDMPIN".tr);
      // AppUtils.showErrorSnackBar(bodyText: "ENTERVALIDMPIN".tr);
    } else if (confirmMpin.isEmpty) {
      AppUtils().accountFlowDialog(msg: "ENTERCONFIRMMPIN".tr);
      // AppUtils.showErrorSnackBar(bodyText: "ENTERCONFIRMMPIN".tr);
    } else if (confirmMpin.value.length < 4) {
      AppUtils().accountFlowDialog(msg: "ENTERVALIDCONFIRMMPIN".tr);
      // AppUtils.showErrorSnackBar(bodyText: "ENTERVALIDCONFIRMMPIN".tr);
    } else if (mpin.value != confirmMpin.value) {
      AppUtils().accountFlowDialog(msg: "MPINDOWSNTMATCHED".tr);
      // AppUtils.showErrorSnackBar(bodyText: "MPINDOWSNTMATCHED".tr);
    } else {
      _fromLoginPage ? callSetMpinApi() : callSetUserDetailsApi();
    }
  }

  callSetUserDetailsApi({String? userName}) async {
    try {
      ApiService()
          .setUserDetails(
              userDetails.userName == null ? await userDetailsBody2(userName: userName) : await userDetailsBody())
          .then((value) async {
        if (value != null && value['status']) {
          var userData = value['data'];
          if (userData != null) {
            String authToken = userData['Token'] ?? "Null From API";
            bool isActive = userData['IsActive'] ?? false;
            bool isVerified = userData['IsVerified'] ?? false;
            bool isMpinSet = userData['IsMPinSet'] ?? false;
            bool isUserDetailSet = userData['IsUserDetailSet'] ?? false;
            GetStorage().write(ConstantsVariables.authToken, authToken);
            GetStorage().write(ConstantsVariables.isActive, isActive);
            GetStorage().write(ConstantsVariables.isVerified, isVerified);
            GetStorage().write(ConstantsVariables.isMpinSet, isMpinSet);
            GetStorage().write(ConstantsVariables.userData, userData);
            GetStorage().write(ConstantsVariables.isUserDetailSet, isUserDetailSet);
            GetStorage().write(ConstantsVariables.id, userData["Id"]);
            print(
                "ConstantsVariables.fcmTokenConstantsVariables.fcmToken ${GetStorage().read(ConstantsVariables.fcmToken)}");
            callFcmApi(userData["Id"]);
          } else {
            AppUtils.showErrorSnackBar(bodyText: "Something went wrong!!!");
          }
          Get.offAllNamed(AppRoutName.dashBoardPage);
          //  userDetails.userName == null ? null : Get.offAllNamed(AppRoutName.dashBoardPage);
        } else {
          AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
        }
      });
    } catch (e) {
      // print(e);
    }
  }

  callFcmApi(userId) async {
    var token = GetStorage().read(ConstantsVariables.fcmToken);
    Timer(const Duration(seconds: 2), () {
      fsmApiCall(userId, token);
    });
  }

  fcmBody(userId, fcmToken) async {
    var token = await NotificationServices().getDeviceToken();
    var a = {
      "id": userId,
      "fcmToken": token,
    };
    return a;
  }

  void fsmApiCall(userId, fcmToken) async {
    ApiService().fcmToken(await fcmBody(userId, fcmToken)).then((value) async {
      if (value['status']) {
        print("ConstantsVariables.fcmTokenConstantsVariables.fcmToken ${ConstantsVariables.fcmToken}");
        // AppUtils.showSuccessSnackBar(
        //     bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
      } else {
        AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      }
    });
  }

  Future<Map> userDetailsBody() async {
    DeviceInformationModel deviceInfo = await DeviceInfo().initPlatformState();
    final userDetailsBody = {
      "userName": userDetails.userName,
      "fullName": userDetails.fullName,
      "mPin": mpin.value,
      "password": userDetails.password,
      "oSVersion": deviceInfo.osVersion,
      "appVersion": deviceInfo.appVersion,
      "brandName": deviceInfo.brandName,
      "model": deviceInfo.model,
      "os": deviceInfo.deviceOs,
      "manufacturer": deviceInfo.manufacturer,
      "ipAddress": ip.value
    };

    return userDetailsBody;
  }

  userDetailsBody2({String? userName}) async {
    DeviceInformationModel deviceInfo = await DeviceInfo().initPlatformState();
    final userDetailsBody = {
      "oSVersion": deviceInfo.osVersion,
      "appVersion": deviceInfo.appVersion,
      "brandName": deviceInfo.brandName,
      "model": deviceInfo.model,
      "os": deviceInfo.deviceOs,
      "manufacturer": deviceInfo.manufacturer,
      "userName": userName ?? "",
      "ipAddress": ip.value
    };

    return userDetailsBody;
  }

  RxString ip = ''.obs;
  Future<String?> getPublicIpAddress() async {
    try {
      final response = await GetConnect(timeout: const Duration(seconds: 15)).get('https://api.ipify.org?format=json');
      if (response.statusCode == 200) {
        final data = response.body['ip'];
        ip.value = data;
        return data;
      } else {
        throw Exception('Failed to load IP address');
      }
    } catch (e) {
      // print('Error fetching IP address: $e');
      return null;
    }
  }

  // Future<void> getLocation() async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high);
  //     List<Placemark> placemarks =
  //         await placemarkFromCoordinates(position.latitude, position.longitude);

  //     if (placemarks.isNotEmpty) {
  //       Placemark placemark = placemarks[0];
  //       city.value = placemark.locality ?? 'Unknown';
  //       country.value = placemark.country ?? 'Unknown';
  //       state.value = placemark.administrativeArea ?? 'Unknown';
  //       street.value =
  //           "${placemark.street ?? 'Unknown'} ${placemark.subLocality ?? 'Unknown'}";
  //       postalCode.value = placemark.postalCode ?? 'Unknown';
  //       print(
  //           "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@${placemark.subAdministrativeArea}");
  //       inspect(placemarks[0]);

  //       getArguments();
  //       print(
  //           "city : ${city.value} +++  Contry: ${country.value}  +++ State:  ${state.value}   State:  ${street.value}");
  //     }
  //   } catch (e) {
  //     print('Error getting location: $e');
  //   }
  // }

  Future<void> callSetMpinApi() async {
    ApiService().setMPIN({"mPin": mpin.value, "ipAddress": ip.value}).then((value) async {
      if (value != null && value['status']) {
        var userData = value['data'];
        if (userData != null) {
          String authToken = userData['Token'] ?? "Null From API";
          bool isActive = userData['IsActive'] ?? false;
          bool isVerified = userData['IsVerified'] ?? false;
          bool isMpinSet = userData['IsMPinSet'] ?? false;
          GetStorage().write(ConstantsVariables.authToken, authToken);
          GetStorage().write(ConstantsVariables.isActive, isActive);
          GetStorage().write(ConstantsVariables.isVerified, isVerified);
          GetStorage().write(ConstantsVariables.isMpinSet, isMpinSet);
          GetStorage().write(ConstantsVariables.userData, userData);

          callSetUserDetailsApi(userName: userData['UserName'] ?? "");
        } else {
          AppUtils.showErrorSnackBar(bodyText: "Something went wrong!!!");
        }
      } else {
        AppUtils().accountFlowDialog(msg: value['message']);
        // AppUtils.showErrorSnackBar(
        //   bodyText: value['message'] ?? "",
        // );
      }
    });
  }
}
