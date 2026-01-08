import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../api_services/api_service.dart';
import '../../../../helper_files/constant_variables.dart';
import '../../../../helper_files/ui_utils.dart';
import '../../../../models/bank_details_model.dart';
import '../../../../models/commun_models/user_details_model.dart';

class MyAccountPageController extends GetxController {
  TextEditingController bankNameController = TextEditingController();
  TextEditingController accHolderNameController = TextEditingController();
  TextEditingController accNoController = TextEditingController();
  TextEditingController ifscCodeController = TextEditingController();
  UserDetailsModel userDetailsModel = UserDetailsModel();
  RxBool isEditDetails = false.obs;
  RxBool isEditDetailsButton = false.obs;
  RxString accountName = "".obs;
  RxString bankName = "".obs;
  RxString accountNumber = "".obs;
  RxString ifcsCode = "".obs;
  RxString userId = "".obs;
  int bankId = 0;

  Future<void> fetchStoredUserDetailsAndGetBankDetailsByUserId() async {
    final data = GetStorage().read(ConstantsVariables.userData);
    UserDetailsModel userData = UserDetailsModel.fromJson(data);
    userId.value = userData.id.toString();
    if (userId.isNotEmpty) {
      callGetBankDetails();
    } else {
      AppUtils.showErrorSnackBar(bodyText: "SOMETHINGWENTWRONG".tr);
    }
  }

  void validationFied() {
    String accNo = accNoController.value.text.trim();
    String ifscCode = ifscCodeController.value.text.trim().replaceAll(RegExp(r'\s+'), ' ');
    String accHolderName = accHolderNameController.value.text.trim().replaceAll(RegExp(r'\s+'), ' ');
    String bankName = bankNameController.value.text.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (accNo.isEmpty) {
      AppUtils.showErrorSnackBar(bodyText: "Enter Account Number");
    } else if (ifscCode.isEmpty) {
      AppUtils.showErrorSnackBar(bodyText: "Enter IFSC Code");
    } else if (accHolderName.isEmpty) {
      AppUtils.showErrorSnackBar(bodyText: "Enter Account Holder Name");
    } else if (bankName.isEmpty) {
      AppUtils.showErrorSnackBar(bodyText: "Enter name of the bank");
    } else {
      accNoController.value = TextEditingValue(text: accNo);
      ifscCodeController.value = TextEditingValue(text: ifscCode);
      accHolderNameController.value = TextEditingValue(text: accHolderName);
      bankNameController.value = TextEditingValue(text: bankName);
      onTapOfEditDetails();
      Get.back();
    }
  }

  void onTapOfEditDetails() async {
    if (isEditDetails.value) {
      callEditBankDetailsApi();
    } else {
      AppUtils.showErrorSnackBar(bodyText: "CONTACTADMINTOEDITDETAILS".tr);
    }
  }

  RxBool loadGetBalance = false.obs;

  Future<void> callGetBankDetails() async {
    loadGetBalance.value = true;

    ApiService().getBankDetails().then((value) async {
      if (value['status']) {
        loadGetBalance.value = false;
        BankDetailsResponseModel model = BankDetailsResponseModel.fromJson(value);
        if (model.message!.isNotEmpty) {
          AppUtils.showSuccessSnackBar(bodyText: model.message, headerText: "SUCCESSMESSAGE".tr);
        }
        bankNameController.clear();
        accHolderNameController.clear();
        accNoController.clear();
        ifscCodeController.clear();
        isEditDetails.value = model.data?.isEditPermission ?? false;
        bankNameController.text = model.data?.bankName ?? "";
        accHolderNameController.text = model.data?.accountHolderName ?? "";
        accNoController.text = model.data?.accountNumber ?? "";
        ifscCodeController.text = model.data?.iFSCCode ?? "";
        bankId = model.data!.id ?? 0;
        if (model.data != null) {
          if (model.data!.isEditPermission ?? false) {
            isEditDetailsButton.value = false;
          } else {
            isEditDetailsButton.value = true;
          }
        } else {
          if (model.data!.isEditPermission ?? false) {
            isEditDetailsButton.value = false;
          } else {
            isEditDetailsButton.value = true;
          }
        }
      } else {
        loadGetBalance.value = false;
        isEditDetails.value = true;
      }
    });
  }

  void callEditBankDetailsApi() async {
    ApiService().editBankDetails(await ediBankDetailsBody()).then((value) async {
      if (value['status']) {
        BankDetailsResponseModel model = BankDetailsResponseModel.fromJson(value);
        isEditDetails.value = model.data?.isEditPermission ?? false;
        bankNameController.text = model.data!.bankName ?? "";
        accHolderNameController.text = model.data!.accountHolderName ?? "";
        accNoController.text = model.data!.accountNumber ?? "";
        ifscCodeController.text = model.data!.iFSCCode ?? "";
        bankId = model.data!.id ?? 0;
        if (model.data?.isEditPermission ?? false) {
          isEditDetailsButton.value = false;
        } else {
          isEditDetailsButton.value = true;
        }
        AppUtils.showSuccessSnackBar(bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
      } else {
        isEditDetails.value = true;
        AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      }
    });
  }

  Future<Map> ediBankDetailsBody() async {
    var ediBankDetailsBody = {
      //  "id": bankId,
      "userId": int.parse(userId.value),
      "bankName": bankNameController.text,
      "accountHolderName": accHolderNameController.text,
      "accountNumber": accNoController.text,
      "ifscCode": ifscCodeController.text,
      // "gpayNumber": gPayNumberController.text,
      // "paytmNumber": paytmNumberController.text,
      // "bhimUPI": bhimUpiController.text,
    };
    if (bankId != 0) {
      ediBankDetailsBody["id"] = bankId;
    }
    // ediBankDetailsBody.addIf(bankId != 0, "id", bankId);
    //  debugPrint(ediBankDetailsBody.toString());

    return ediBankDetailsBody;
  }
}
