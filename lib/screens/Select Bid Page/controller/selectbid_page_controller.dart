import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../Custom Controllers/wallet_controller.dart';
import '../../../api_services/api_service.dart';
import '../../../helper_files/app_colors.dart';
import '../../../helper_files/constant_variables.dart';
import '../../../helper_files/custom_text_style.dart';
import '../../../helper_files/dimentions.dart';
import '../../../helper_files/ui_utils.dart';
import '../../../models/commun_models/bid_request_model.dart';
import '../../../models/commun_models/user_details_model.dart';
import '../../../routes/app_routes_name.dart';

class SelectBidPageController extends GetxController {
  var arguments = Get.arguments;

  RxString totalAmount = "0".obs;
  var biddingType = "".obs;
  var gameName = "".obs;
  var marketName = "".obs;
  Rx<BidRequestModel> requestModel = BidRequestModel().obs;
  List<Bids> savedBidsList = <Bids>[];

  final walletController = Get.find<WalletController>();
  RxString bidType = "".obs;

  @override
  void onInit() {
    super.onInit();
    getArguments();
  }

  checkType(index) {
    if (requestModel.value.bids![index].gameModeName!.contains("Ank")) {
      return "Ank";
    } else if (requestModel.value.bids![index].gameModeName!.contains("Jodi")) {
      return "Jodi";
    } else {
      return "Pana";
    }
  }

  Future<void> getArguments() async {
    biddingType.value = arguments["biddingType"];
    marketName.value = arguments["marketName"];
    totalAmount.value = arguments["totalAmount"];
    requestModel.value.bids = arguments["bidsList"];
    final data = GetStorage().read(ConstantsVariables.userData);
    UserDetailsModel userData = UserDetailsModel.fromJson(data);
    // requestModel.value.userId = userData.id;
    requestModel.value.bidType = arguments["biddingType"];
    requestModel.value.dailyMarketId = arguments["marketId"];

    requestModel.refresh();
    gameName.value = arguments["gameName"];
    // GetStorage().write(ConstantsVariables.playMore, false);
    // var hh = GetStorage().read(ConstantsVariables.playMore);

    newBidListreaddata();
    _calculateTotalAmount();
    bidType.value = GetStorage().read(ConstantsVariables.bidType);
  }

  newBidListreaddata() async {
    var newBidList = GetStorage().read(ConstantsVariables.bidsList);
  }

  void onDeleteBids(int index) async {
    requestModel.value.bids!.remove(requestModel.value.bids![index]);
    requestModel.refresh();
    GetStorage().write(ConstantsVariables.bidsList, requestModel.value.bids!);
    // LocalStorage.write(ConstantsVariables.bidsList,
    //     requestModel.value.bids!.map((v) => v.toJson()).toList());
    _calculateTotalAmount();
    if (requestModel.value.bids!.isEmpty) {
      requestModel.value.bids!.clear();
      GetStorage().write(ConstantsVariables.bidsList, requestModel.value.bids!);
      Get.back();
      Get.back();
    }
  }

  void _calculateTotalAmount() async {
    // var getTotalAmount =
    //     GetStorage().read(ConstantsVariables.totalAmount);
    int tempTotal = 0;
    for (var element in requestModel.value.bids ?? []) {
      tempTotal += int.parse(element.coins.toString());
    }
    totalAmount.value = tempTotal.toString();
  }

  void createMarketBidApi() async {
    ApiService().createMarketBid(requestModel.value.toJson()).then(
      (value) async {
        if (value['status']) {
          Get.back();
          Get.back();
          if (value['data'] == false) {
            Get.back();
            AppUtils.showErrorSnackBar(
              bodyText: value['message'] ?? "",
            );
          } else {
            AppUtils.showSuccessSnackBar(bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
          }
          GetStorage().remove(ConstantsVariables.bidsList);
          GetStorage().remove(ConstantsVariables.marketName);
          GetStorage().remove(ConstantsVariables.biddingType);
          //   GetStorage().write(ConstantsVariables.playMore, true);
        } else {
          AppUtils.showErrorSnackBar(
            bodyText: value['message'] ?? "",
          );
        }
        requestModel.value.bids!.clear();
        _calculateTotalAmount();
        walletController.getUserBalance();
        walletController.walletBalance.refresh();
      },
    );
  }

  void playMore() async {
    _calculateTotalAmount();
    GetStorage().write(ConstantsVariables.totalAmount, totalAmount.value);
    // GetStorage().write(ConstantsVariables.marketName, marketName.value);
    Get.offAndToNamed(AppRoutName.gameModePage, arguments: {
      "biddingType": biddingType.value,
      //    "marketName": marketName.value,
      "totalAmount": totalAmount.value,
      "bidsList": requestModel.value.bids,
//      "gameName": gameName.value,
      //  "marketId": requestModel.value.dailyMarketId,
    });
    // getArguments();
  }

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm!'),
          content: Text(
            'Do you really wish to submit?',
            style: CustomTextStyle.textRobotoSansLight.copyWith(
              color: AppColors.grey,
              fontSize: Dimensions.h14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Handle cancel button press
                Get.back();
              },
              child: Text(
                'CANCLE',
                style: CustomTextStyle.textPTsansBold.copyWith(
                  color: AppColors.appbarColor,
                  fontSize: Dimensions.h13,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                createMarketBidApi();
                // requestModel.value.bids!.clear();
                // requestModel.refresh();
              },
              child: Text(
                'OKAY',
                style: CustomTextStyle.textPTsansBold.copyWith(
                  color: AppColors.appbarColor,
                  fontSize: Dimensions.h13,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
