import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../../Custom Controllers/wallet_controller.dart';
import '../../../api_services/api_service.dart';
import '../../../helper_files/common_utils.dart';
import '../../../helper_files/constant_variables.dart';
import '../../../helper_files/ui_utils.dart';
import '../../../models/commun_models/bid_request_model.dart';
import '../../../models/commun_models/digit_list_model.dart';
import '../../../models/commun_models/user_details_model.dart';
import '../../../models/daily_market_api_response_model.dart';
import '../../../models/game_modes_api_response_model.dart';
import '../../../routes/app_routes_name.dart';

class GameModePagesController extends GetxController {
  RxBool containerChange = false.obs;
  var arguments = Get.arguments;
  Rx<GameModesApiResponseModel> gameModeList = GameModesApiResponseModel().obs;
  var marketValue = MarketData().obs;
  var openBiddingOpen = true.obs;
  var openCloseValue = "OPENBID".tr.obs;
  var closeBiddingOpen = true.obs;
  RxBool isBulkMode = false.obs;
  var playmore;
  RxList<Bids> selectedBidsList = <Bids>[].obs;
  RxList<GameMode> gameModesList = <GameMode>[].obs;
  Rx<BidRequestModel> requestModel = BidRequestModel().obs;
  var biddingType = "".obs;
  RxString totalAmount = "0".obs;
  RxString totalBidsAmount = "0".obs;
  RxString marketNameForPlayMore = "".obs;
  var marketName = "".obs;
  RxString gameName = "".obs;
  var digitRow = [
    DigitListModelOffline(value: "0", isSelected: false),
    DigitListModelOffline(value: "1", isSelected: false),
    DigitListModelOffline(value: "2", isSelected: false),
    DigitListModelOffline(value: "3", isSelected: false),
    DigitListModelOffline(value: "4", isSelected: false),
    DigitListModelOffline(value: "5", isSelected: false),
    DigitListModelOffline(value: "6", isSelected: false),
    DigitListModelOffline(value: "7", isSelected: false),
    DigitListModelOffline(value: "8", isSelected: false),
    DigitListModelOffline(value: "9", isSelected: false),
  ].obs;

  String removeTimeStampFromDateString(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(dateTime);
  }

  @override
  void onInit() {
    marketValue.value = arguments;
    checkBiddingStatus();
    callGetGameModes();
    getArguments();
    checkBids();
    super.onInit();
  }

  @override
  void onClose() async {
    requestModel.value.bids?.clear();
    // GetStorage().write(ConstantsVariables.playMore, true);
    GetStorage().write(ConstantsVariables.totalAmount, "");
    GetStorage().write(ConstantsVariables.marketName, "");
    super.onClose();
  }

  onTapOpenClose() {
    if (openBiddingOpen.value && openCloseValue.value != "OPENBID".tr) {
      openCloseValue.value = "OPENBID".tr;
      callGetGameModes();
    } else {
      callGetGameModes();
    }
  }

  void setSelectedRadioValue(String value) {
    openCloseValue.value = value;
  }

  void checkBiddingStatus() {
    var timeDiffForOpenBidding =
        CommonUtils().getDifferenceBetweenGivenTimeFromNow(marketValue.value.openTime ?? "00:00 AM");
    var timeDiffForCloseBidding =
        CommonUtils().getDifferenceBetweenGivenTimeFromNow(marketValue.value.closeTime ?? "00:00 AM");
    timeDiffForOpenBidding < 2 ? openBiddingOpen.value = false : true;
    timeDiffForCloseBidding < 2 ? closeBiddingOpen.value = false : true;
    if (!openBiddingOpen.value) {
      openCloseValue.value = "CLOSEBID".tr;
    }
  }

  onBackButton() async {
    print("kdskdjdskjskd");
    // var hh = GetStorage().read(ConstantsVariables.playMore);
    // if (!hh) {
    // var bidList = GetStorage().read(ConstantsVariables.bidsList);
    // totalBidsAmount.value =
    //     GetStorage().read(ConstantsVariables.totalAmount);

    // arguments['totalAmount'] = totalAmount.value;
    // arguments['marketName'] = marketName.value;
    // arguments['gameName'] = gameName.value;
    // if (bidList.length != 0) {
    //   Get.toNamed(AppRoutName.selectedBidsPage, arguments: {
    //     "bidsList": bidList,
    //     "biddingType": biddingType.value,
    //     "gameName": gameName.value,
    //     "marketName": marketNameForPlayMore.value,
    //     "marketId": requestModel.value.dailyMarketId,
    //     "totalAmount": totalBidsAmount.value,
    //   });
    // } else {
    selectedBidsList.clear();
    GetStorage().write(ConstantsVariables.bidsList, selectedBidsList);
    final walletController = Get.find<WalletController>();
    walletController.getUserBalance();
    walletController.walletBalance.refresh();
    Get.offAllNamed(AppRoutName.dashBoardPage);
    // }
    // } else {
    //   selectedBidsList.clear();
    //   GetStorage().write(ConstantsVariables.bidsList, selectedBidsList);
    //   final walletController = Get.find<WalletController>();
    //   walletController.getUserBalance();
    //   walletController.walletBalance.refresh();
    //   Get.offAllNamed(AppRoutName.dashBoardPage);
    // }
  }

  void callGetGameModes() async {
    ApiService()
        .getGameModes(
            openCloseValue: openCloseValue.value != "CLOSEBID".tr ? "0" : "1", marketID: marketValue.value.id ?? 0)
        .then((value) async {
      if (value['status']) {
        GameModesApiResponseModel gameModeModel = GameModesApiResponseModel.fromJson(value);
        gameModeList.value = gameModeModel;

        if (gameModeModel.data != null) {
          openBiddingOpen.value = gameModeModel.data!.isBidOpenForOpen ?? false;
          closeBiddingOpen.value = gameModeModel.data!.isBidOpenForClose ?? false;
          gameModesList.value = gameModeModel.data!.gameMode ?? <GameMode>[];
        }
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  void checkBids() async {
    // var hh = GetStorage().read(ConstantsVariables.playMore);

    //  if (!hh) {
    final bidList = GetStorage().read(ConstantsVariables.bidsList);

    //  biddingType.value = arguments["biddingType"];
    // marketName.value = arguments["marketName"];
    // selectedBidsList.value = bidList as List<Bids>;
    // } else {}
    // requestModel.refresh();
    // print("${requestModel.value.bids.toString()}  + +++++++");
  }

  void onTapOfGameModeTile(int index) {
    bool isBulkMode = false;
    bool digitBasedJodi = false;
    bool choicePanaSpDp = false;
    bool digitsBasedJodi = false;
    bool oddEven = false;
    bool halfSangamA = false;
    bool halfSangamB = false;
    bool fullSangam = false;
    switch (gameModesList[index].name) {
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
      case "Digit Based Jodi":
        digitBasedJodi = true;
        break;
      case "Choice Pana SPDP":
        choicePanaSpDp = true;
        break;
      case "Digits Based Jodi":
        digitsBasedJodi = true;
        break;
      case "Odd Even":
        oddEven = true;
        break;
      case "Half Sangam A":
        halfSangamA = true;
        break;
      case "Half Sangam B":
        halfSangamB = true;

        break;
      case "Full Sangam":
        halfSangamB = true;
        break;
      default:
    }

    if (halfSangamA || halfSangamB || fullSangam) {
      Get.toNamed(AppRoutName.sangamPages, arguments: {
        "gameMode": gameModesList[index],
        "marketName": marketValue.value.market ?? "",
        "marketData": marketValue.value,
        "gameModeList": gameModeList,
        "marketValue": marketValue.value,
        "bidsList": selectedBidsList,
        "gameName": gameModesList[index].name,
        "totalAmount": totalAmount.value,
      });
    } else if (isBulkMode) {
      Get.toNamed(AppRoutName.singleAnkPage, arguments: {
        "gameMode": gameModesList[index],
        "marketName": marketValue.value.market ?? "",
        "marketId": marketValue.value.id ?? "",
        "marketValue": marketValue.value,
        "time":
            openCloseValue.value == "OPENBID".tr ? marketValue.value.openTime ?? "" : marketValue.value.closeTime ?? "",
        "biddingType": openCloseValue.value == "OPENBID".tr ? "Open" : "Close",
        "isBulkMode": true,
        "gameModeList": gameModeList,
        "bidsList": selectedBidsList,
        "gameName": gameModesList[index].name,
        "totalAmount": totalAmount.value,
      });
    } else if (choicePanaSpDp || digitsBasedJodi || oddEven) {
      Get.toNamed(AppRoutName.newOddEvenPage, arguments: {
        "gameMode": gameModesList[index],
        "marketName": marketValue.value.market ?? "",
        "marketId": marketValue.value.id ?? "",
        "time":
            openCloseValue.value == "OPENBID".tr ? marketValue.value.openTime ?? "" : marketValue.value.closeTime ?? "",
        "biddingType": openCloseValue.value == "OPENBID".tr ? "Open" : "Close",
        "isBulkMode": false,
        "gameModeList": gameModeList,
        "marketValue": marketValue.value,
        "bidsList": selectedBidsList,
        "gameName": gameModesList[index].name,
        "totalAmount": totalAmount.value,
      });
    } else {
      print("nkjcnxcnxkjn");
      print(selectedBidsList);
      Future.delayed(
        Duration(milliseconds: 200),
        () => Get.toNamed(AppRoutName.newGameModePage, arguments: {
          "gameMode": gameModesList[index],
          "marketName": marketValue.value.market ?? "",
          "marketId": marketValue.value.id ?? "",
          "marketValue": marketValue.value,
          "time": openCloseValue.value == "OPENBID".tr
              ? marketValue.value.openTime ?? ""
              : marketValue.value.closeTime ?? "",
          "biddingType": openCloseValue.value == "OPENBID".tr ? "Open" : "Close",
          "isBulkMode": false,
          "gameModeList": gameModeList,
          "bidsList": selectedBidsList,
          "gameName": gameModesList[index].name,
          "totalAmount": totalAmount.value,
        }),
      );
    }
  }

  Future<void> getArguments() async {
    var data = GetStorage().read(ConstantsVariables.userData);
    // playmore = GetStorage().read(ConstantsVariables.playMore);
    UserDetailsModel userData = UserDetailsModel.fromJson(data);
    // requestModel.value.userId = userData.id;
    selectedBidsList.value = GetStorage().read(ConstantsVariables.bidsList);
    requestModel.refresh();
  }
}
