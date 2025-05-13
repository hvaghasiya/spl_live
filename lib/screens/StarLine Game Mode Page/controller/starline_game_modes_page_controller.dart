import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:spllive/helper_files/ui_utils.dart';

import '../../../api_services/api_service.dart';
import '../../../helper_files/common_utils.dart';
import '../../../helper_files/constant_variables.dart';
import '../../../models/commun_models/starline_bid_request_model.dart';
import '../../../models/starline_daily_market_api_response.dart';
import '../../../models/starline_game_modes_api_response_model.dart';
import '../../../routes/app_routes_name.dart';

class StarLineGameModesPageController extends GetxController {
  var arguments = Get.arguments;
  var marketData = StarlineMarketData().obs;
  var biddingOpen = true.obs;
  String formattedDate = DateFormat('EEEE, MMMM d, y').format(DateTime.now());
  RxList<StarLineGameMod> gameModesList = <StarLineGameMod>[].obs;
  Rx<StarlineBidRequestModel> requestModel = StarlineBidRequestModel().obs;
  Rx<StarLineGameMod> gameMode = StarLineGameMod().obs;
  RxString totalAmount = "00".obs;
  bool getBidData = false;
  num count = 0;
  // var argument = Get.arguments;
  // RxList<StarLineBids> selectedBidsList = <StarLineBids>[].obs;
  @override
  void onInit() async {
    super.onInit();
    marketData.value = arguments;
    checkBiddingStatus();
    GetStorage().write(ConstantsVariables.starlineConnect, true);
    callGetGameModes();
  }

  onBackButton() async {
    Get.back();
    // Get.offAll(() => const StarlineDailyMarketData());
    requestModel.value.bids?.clear();
    GetStorage().write(ConstantsVariables.starlineBidsList, requestModel.value.bids);
  }

  @override
  void onClose() async {
    requestModel.value.bids?.clear();
    GetStorage().write(ConstantsVariables.playMore, true);
    GetStorage().write(ConstantsVariables.totalAmount, "");
    GetStorage().write(ConstantsVariables.marketName, "");
    super.onClose();
  }

  void _calculateTotalAmount() {
    int tempTotal = 0;
    for (var element in requestModel.value.bids ?? []) {
      tempTotal += int.parse(element.coins.toString());
    }
    totalAmount.value = tempTotal.toString();
  }

  Future<void> onSwipeRefresh() async {
    callGetGameModes();
  }

  void callGetGameModes() async {
    ApiService().getStarLineGameModes(marketID: marketData.value.id ?? 0).then(
      (value) async {
        if (value['status']) {
          StarLineGameModesApiResponseModel gameModeModel = StarLineGameModesApiResponseModel.fromJson(value);
          if (gameModeModel.data != null) {
            biddingOpen.value = gameModeModel.data!.isBidOpen ?? false;
            gameModesList.value = gameModeModel.data!.gameMode ?? <StarLineGameMod>[];
          }
        } else {
          AppUtils.showErrorSnackBar(
            bodyText: value['message'] ?? "",
          );
        }
      },
    );
  }

  void checkBiddingStatus() {
    var timeDiffForOpenBidding =
        CommonUtils().getDifferenceBetweenGivenTimeFromNow(marketData.value.time ?? "00:00 AM");
    timeDiffForOpenBidding < 15 ? biddingOpen.value = false : true;
  }

  void onTapOfGameModeTile(int index) async {
    bool isBulkMode = false;
    switch (gameModesList[index].name) {
      case "Single Ank":
        isBulkMode = false;
        break;
      case "Single Pana":
        isBulkMode = false;
        break;
      case "Double Pana":
        isBulkMode = false;
        break;
      case "Tripple Pana":
        isBulkMode = false;
        break;
      case "Single Ank Bulk":
        isBulkMode = true;
        break;
      case "Jodi Bulk":
        isBulkMode = true;
        break;
      case "Single Pana Bulk":
        isBulkMode = true;
        break;
      case "Double Pana Bulk":
        isBulkMode = true;
        break;

      case "Panel Group":
        isBulkMode = false;
        break;
      case "SP Motor":
        isBulkMode = false;
        break;
      case "DP Motor":
        isBulkMode = false;
        break;
      case "SPDPTP":
        isBulkMode = false;
        break;
      case "Digit Based Jodi":
        isBulkMode = false;
        break;
      case "Choice Pana SPDP":
        isBulkMode = false;
        break;
      case "Two Digits Panel":
        isBulkMode = false;
        break;
      case "Odd Even":
        isBulkMode = false;
        break;

      default:
    }

    if (isBulkMode) {
      Get.toNamed(AppRoutName.starLineGamePage, arguments: {
        "gameMode": gameModesList[index],
        //   "gameModeName": gameModesList[index].name,
        "marketData": marketData.value,
        "getBidData": getBidData,
        "getBIdType": gameModesList[index].name,
      });
    } else {
      Get.toNamed(AppRoutName.newStarlineGames, arguments: {
        "gameMode": gameModesList[index],
        "gameModeName": gameModesList[index].name,
        "marketData": marketData.value,
        "getBidData": getBidData,
        "getBIdType": gameModesList[index].name,
      });
    }
  }

  void onDeleteBids(int index) {
    requestModel.value.bids!.remove(requestModel.value.bids![index]);
    requestModel.refresh();
    _calculateTotalAmount();
    if (requestModel.value.bids!.isEmpty) {
      Get.back();
      Get.back();
    }
  }

  void createMarketBidApi() async {
    ApiService().createStarLineMarketBid(requestModel.value.toJson()).then((value) async {
      if (value['status']) {
        Get.back();
        Get.back();
        if (value['data'] == false) {
          Get.back();
          AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
        } else {
          AppUtils.showSuccessSnackBar(bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
        }
        GetStorage().remove(ConstantsVariables.bidsList);
        GetStorage().remove(ConstantsVariables.marketName);
        GetStorage().remove(ConstantsVariables.biddingType);
      } else {
        AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      }
    });
  }

  // void showConfirmationDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Confirm!'),
  //         content: Text(
  //           'Do you really wish to submit?',
  //           style: CustomTextStyle.textRobotoSansLight.copyWith(
  //             color: AppColors.grey,
  //             fontSize: Dimensions.h14,
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Get.back(),
  //             child: Text(
  //               'CANCLE',
  //               style: CustomTextStyle.textPTsansBold.copyWith(
  //                 color: AppColors.appbarColor,
  //                 fontSize: Dimensions.h13,
  //               ),
  //             ),
  //           ),
  //           TextButton(
  //             onPressed: () => createMarketBidApi(),
  //             child: Text(
  //               'OKAY',
  //               style: CustomTextStyle.textPTsansBold.copyWith(
  //                 color: AppColors.appbarColor,
  //                 fontSize: Dimensions.h13,
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
