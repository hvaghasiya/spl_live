import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../api_services/api_service.dart';
import '../../../helper_files/constant_variables.dart';
import '../../../helper_files/ui_utils.dart';
import '../../../routes/app_routes_name.dart';

class ForgotPasswordController extends GetxController {
  var mobileNumberController = TextEditingController();
  var countryCode = '+91'.obs;

  @override
  void dispose() {
    mobileNumberController.dispose();
    super.dispose();
  }

  void onChangeCountryCode(String code) {
    countryCode.value = code;
  }

  void callForgotPasswordApi() async {
    ApiService().forgotPassword({"phoneNumber": mobileNumberController.text, "countryCode": "+91"}).then((value) async {
      if (value['status']) {
        String authToken = value['data']['Token'] ?? "Null From API";
        GetStorage().write(ConstantsVariables.authToken, authToken);
        if (value['data']['IsUserDetailSet'] == true) {
          AppUtils.showSuccessSnackBar(bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
          Get.toNamed(AppRoutName.resetPasswordPage, arguments: {
            ConstantsVariables.phoneNumber: mobileNumberController.text,
            ConstantsVariables.countryCode: countryCode.value
          });
          // print(value);
        } else {
          Get.toNamed(AppRoutName.userDetailsPage);
        }
      } else {
        // AppUtils.showErrorSnackBar(
        //   bodyText: value['message'] ?? "",
        // );
        AppUtils().accountFlowDialog(msg: value['message']);
      }
    });
  }

  void onTapOfContinue() {
    if (mobileNumberController.text.isEmpty) {
      AppUtils().accountFlowDialog(msg: "ENTERMOBILENUMBER".tr);
      // AppUtils.showErrorSnackBar(bodyText: "ENTERMOBILENUMBER".tr);
    } else if (mobileNumberController.text.length < 10) {
      AppUtils().accountFlowDialog(msg: "ENTERVALIDNUMBER".tr);
      // AppUtils.showErrorSnackBar(bodyText: "ENTERVALIDNUMBER".tr);
    } else {
      callForgotPasswordApi();
    }
  }
}
