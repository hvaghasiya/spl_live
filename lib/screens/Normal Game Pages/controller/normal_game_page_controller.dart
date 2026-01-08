import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../Custom Controllers/wallet_controller.dart';
import '../../../api_services/api_service.dart';
import '../../../api_services/api_urls.dart';
import '../../../helper_files/app_colors.dart';
import '../../../helper_files/constant_variables.dart';
import '../../../helper_files/custom_text_style.dart';
import '../../../helper_files/dimentions.dart';
import '../../../helper_files/ui_utils.dart';
import '../../../models/commun_models/bid_request_model.dart';
import '../../../models/commun_models/digit_list_model.dart';
import '../../../models/commun_models/json_file_model.dart';
import '../../../models/commun_models/user_details_model.dart';
import '../../../models/daily_market_api_response_model.dart';
import '../../../models/game_modes_api_response_model.dart';
import '../../../routes/app_routes_name.dart';

class NormalGamePageController extends GetxController {
  var coinController = TextEditingController();
  var leftAnkController = TextEditingController();
  var rightAnkController = TextEditingController();
  var middleAnkController = TextEditingController();
  final FocusNode leftFocusNode = FocusNode();
  final FocusNode middleFocusNode = FocusNode();
  final FocusNode rightFocusNode = FocusNode();
  final FocusNode coinFocusNode = FocusNode();
  // late FocusNode focusNode;
  var spdptpList = [];
  String spValue = "SP";
  String dpValue = "DP";
  String tpValue = "TP";
  RxBool spValue1 = false.obs;
  RxBool dpValue2 = false.obs;
  String addedNormalBidValue = "";
  RxBool tpValue3 = false.obs;
  RxString totalAmount = "0".obs;
  RxInt panaControllerLength = 2.obs;
  JsonFileModel jsonModel = JsonFileModel();
  Rx<BidRequestModel> requestModel = BidRequestModel().obs;
  List<String> selectedValues = [];
  var selectedBidsList = <Bids>[].obs;
  final List<String> _validationListForNormalMode = [];
  Rx<GameMode> gameMode = GameMode().obs;
  RxBool oddbool = true.obs;
  RxBool evenbool = false.obs;

  Future<void> loadJsonFile() async {
    final String response = await rootBundle.loadString('assets/JSON File/digit_file.json');
    final data = await json.decode(response);
    jsonModel = JsonFileModel.fromJson(data);
  }

  var digitList = <DigitListModelOffline>[].obs;
  var singleAnkList = <DigitListModelOffline>[].obs;
  var jodiList = <DigitListModelOffline>[].obs;
  var biddingType = "".obs;
  var marketName = "".obs;
  var marketId = 0;
  String bidType = "Open";
  var argument = Get.arguments;
  bool enteredDigitsIsValidate = false;
  var apiUrl = "";
  List<String> digitBasedJodi = [];
  Map<String, List<String>> choisePanaSPDPTP = {};
  @override
  void onInit() {
    super.onInit();
    getArguments();
  }

  checkType(index) {
    if (selectedBidsList.elementAt(index).gameModeName! == "Odd Even") {
      return "Ank";
    } else if (selectedBidsList.elementAt(index).gameModeName!.contains("Jodi")) {
      return "Jodi";
    } else {
      return "Pana";
    }
  }

  void getArguments() async {
    await loadJsonFile();
    marketValue.value = argument["marketValue"];
    gameMode.value = argument['gameMode'];
    biddingType.value = argument['biddingType'];
    marketName.value = argument['marketName'];
    marketId = argument['marketId'];
    // isBulkMode.value = argument['isBulkMode'];
    // marketData.value = argument['marketData'];
    // requestModel.value.dailyMarketId = marketData.value.id;
    requestModel.value.bidType = bidType;
    final data = GetStorage().read(ConstantsVariables.userData);
    UserDetailsModel userData = UserDetailsModel.fromJson(data);
    // requestModel.value.userId = userData.id;
    requestModel.value.bidType = biddingType.value;
    requestModel.value.dailyMarketId = marketId;

    RxBool showNumbersLine = false.obs;
    List<String> _tempValidationList = [];
    switch (gameMode.value.name) {
      case "Choice Pana SPDP":
        showNumbersLine.value = false;
        apiUrl = ApiUtils.choicePanaSPDP;
        panaControllerLength.value = 1;
        _tempValidationList = jsonModel.singleAnk!;
        choisePanaSPDPTP = jsonModel.spdptp!;
        break;
      case "Digits Based Jodi":
        showNumbersLine.value = false;
        panaControllerLength.value = 1;
        apiUrl = ApiUtils.digitsBasedJodi;
        digitBasedJodi = jsonModel.jodi!;
        _tempValidationList = jsonModel.singleAnk!;
        break;
      case "Odd Even":
        showNumbersLine.value = false;
        panaControllerLength.value = 1;
        _tempValidationList = jsonModel.singleAnk!;
        break;
    }
    _validationListForNormalMode.addAll(_tempValidationList);
  }

// Function to filter elements that match the provided digits
  List<String> getChoicePanaSPDPTP() {
    String? middle = middleAnkController.text;
    String? left = leftAnkController.text;
    String? last = rightAnkController.text;
    List<String> panaType = selectedValues;

    List<String> panaArray = [];

    for (int i = 0; i < panaType.length; i++) {
      List<String>? data = choisePanaSPDPTP[panaType[i]];
      if (data != null) {
        panaArray.addAll(data);
      } else {
        // debugPrint("Error");
      }
    }
    var a = panaArray.where((num1) {
      // if ((left.isNotEmpty && num1[0] != left)) {
      //   print("+============");
      //   return false;
      // } else if (((middle.isNotEmpty && num1[num1.length ~/ 2] != middle))) {
      //   return false;
      // } else if ((last.isNotEmpty && num1[num1.length - 1] != last)) {
      //   return false;
      // }
      // return true;
      return matchesDigits(num1, left: left, middle: middle, last: last);
    }).toList();

    return a;
  }

  bool matchesDigits(String num, {String? left, String? middle, String? last}) {
    if ((left!.isNotEmpty && num[0] != left)) {
      return false;
    } else if (((middle!.isNotEmpty && num[num.length ~/ 2] != middle))) {
      return false;
    } else if ((last!.isNotEmpty && num[num.length - 1] != last)) {
      return false;
    }
    return true;
  }

  /// add Button DigitBasedJodi
  List<String> digitBasedJodiFilter() {
    String? left = leftAnkController.text;
    String? right = rightAnkController.text;
    List<String> result = [];
    List<String> jodiArray = digitBasedJodi;

    bool startsWithLeft(String num) => num.startsWith(left);

    bool endsWithRight(String num) => num.endsWith(right);

    if (right == null) {
      result = jodiArray.where((num) => startsWithLeft(num)).toList();
      result.sort((a, b) => b.compareTo(a)); // Sort in descending order for strings.
    } else if (left == null) {
      result = jodiArray.where((num) => endsWithRight(num)).toList();
      result.sort((a, b) => b.compareTo(a)); // Sort in descending order for strings.
    } else if (left != null && right != null) {
      List<String> leftList = jodiArray.where((num) => endsWithRight(num)).toList();
      leftList.sort((a, b) => b.compareTo(a)); // Sort in descending order for strings.
      List<String> rightList = jodiArray.where((num) => startsWithLeft(num)).toList();
      rightList.sort((a, b) => b.compareTo(a)); // Sort in descending order for strings.

      result = [...leftList, ...rightList];
    }

    return result;
  }

  newDigitBasedData() {
    if (coinController.text.trim().isEmpty || int.parse(coinController.text.trim()) < 1) {
      AppUtils.showErrorSnackBar(
        bodyText: "Please enter valid points",
      );
      coinFocusNode.nextFocus();
      leftFocusNode.requestFocus();
      return;
    } else if (int.parse(coinController.text) > 10000) {
      AppUtils.showErrorSnackBar(
        bodyText: "You can not add more than 10000 points",
      );
      coinFocusNode.nextFocus();
      leftFocusNode.requestFocus();
      return;
    } else {
      spdptpList = digitBasedJodiFilter();
      if (spdptpList.isEmpty) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please enter valid ${gameMode.value.name!.toLowerCase()}",
        );
        coinFocusNode.nextFocus();
        leftFocusNode.requestFocus();
      } else {
        for (var i = 0; i < spdptpList.length; i++) {
          addedNormalBidValue = spdptpList[i].toString();
          selectedBidsList.insert(
            0,
            Bids(
              bidNo: spdptpList[i].toString(),
              coins: int.parse(coinController.text),
              gameId: gameMode.value.id,
              // subGameId: ,
              gameModeName: gameMode.value.name,
              remarks: "You invested At ${marketName.value} on $addedNormalBidValue (${gameMode.value.name})",
            ),
          );
        }
      }
      coinFocusNode.nextFocus();
      leftFocusNode.requestFocus();
    }

    leftAnkController.clear();
    rightAnkController.clear();
    middleAnkController.clear();
    coinController.clear();
    selectedBidsList.refresh();
    coinFocusNode.nextFocus();
    leftFocusNode.requestFocus();
    _calculateTotalAmount();
  }

  onTapAddOddEven() {
    for (var i = 0; i < 10; i++) {
      var bidNo = i.toString();
      var existingIndex = selectedBidsList.indexWhere((element) => element.bidNo == bidNo);
      var coins = int.parse(coinController.text);
      if (oddbool.value) {
        if (i % 2 != 0) {
          if (existingIndex != -1) {
            // If the bidNo already exists in selectedBidsList, update coins value.
            selectedBidsList[existingIndex].coins = (selectedBidsList[existingIndex].coins! + coins);
          } else {
            // If bidNo doesn't exist in selectedBidsList, add a new entry.
            selectedBidsList.insert(
              0,
              Bids(
                bidNo: bidNo,
                coins: coins,
                gameId: gameMode.value.id,
                gameModeName: gameMode.value.name,
                subGameId: gameMode.value.id,
                remarks: "You invested At ${marketName.value} on $bidNo (${gameMode.value.name})",
              ),
            );
          }
        }
      } else {
        if (i % 2 == 0) {
          if (existingIndex != -1) {
            // If the bidNo already exists in selectedBidsList, update coins value.
            selectedBidsList[existingIndex].coins = (selectedBidsList[existingIndex].coins! + coins);
          } else {
            selectedBidsList.insert(
              0,
              Bids(
                bidNo: i.toString(),
                coins: int.parse(coinController.text),
                gameId: gameMode.value.id,
                gameModeName: gameMode.value.name,
                subGameId: gameMode.value.id,
                remarks: "You invested At ${marketName.value} on $i (${gameMode.value.name})",
              ),
            );
          }
        }
      }
    }
    coinController.clear();
    selectedBidsList.refresh();
    _calculateTotalAmount();
  }

  var marketValue = MarketData().obs;
  void createMarketBidApi() async {
    ApiService().createMarketBid(requestModel.toJson()).then((value) async {
      if (value['status']) {
        Get.back();
        Get.back();
        if (value['data'] == false) {
          selectedBidsList.clear();
          Get.offAndToNamed(AppRoutName.gameModePage, arguments: marketValue.value);
          AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
        } else {
          Get.offAndToNamed(AppRoutName.gameModePage, arguments: marketValue.value);
          AppUtils.showSuccessSnackBar(bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
          final walletController = Get.find<WalletController>();
          walletController.getUserBalance();
          walletController.walletBalance.refresh();
        }
        GetStorage().remove(ConstantsVariables.bidsList);
        requestModel.value.bids!.clear();
        GetStorage().remove(ConstantsVariables.marketName);
        GetStorage().remove(ConstantsVariables.biddingType);
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  void _calculateTotalAmount() {
    var tempTotal = 0;
    for (var element in selectedBidsList) {
      tempTotal += element.coins ?? 0;
    }
    totalAmount.value = tempTotal.toString();
  }

  void onDeleteBids(int index) {
    selectedBidsList.remove(selectedBidsList[index]);
    selectedBidsList.refresh();
    _calculateTotalAmount();
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
                selectedBidsList.clear();
                coinController.clear();
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

  Future<void> onTapOfSaveButton(context) async {
    if (selectedBidsList.isNotEmpty) {
      requestModel.value.bids = selectedBidsList;
      showConfirmationDialog(context);
    } else {
      AppUtils.showErrorSnackBar(
        bodyText: "Please add some bids!",
      );
    }
  }

  Future<Map> groupJodiBody() async {
    String panaType = selectedValues.join(',');
    final a = {
      "left": leftAnkController.text,
      "middle": middleAnkController.text,
      "right": rightAnkController.text,
      "panaType": panaType,
    };
    return a;
  }

  void groupJodiData() {
    spdptpList = getChoicePanaSPDPTP();
    if (spdptpList.isEmpty) {
      AppUtils.showErrorSnackBar(
        bodyText: "Please enter valid ${gameMode.value.name!.toLowerCase()}",
      );
    }
    // ApiService()
    //     .newGameModeApi(await groupJodiBody(), apiUrl)
    //     .then((value) async {
    //   debugPrint("Forgot MPIN Api Response :- $value");
    //   if (value['status']) {
    //     spdptpList = value['data'];
    if (coinController.text.trim().isEmpty || int.parse(coinController.text.trim()) < 1) {
      AppUtils.showErrorSnackBar(
        bodyText: "Please enter valid points",
      );
      coinFocusNode.nextFocus();
      leftFocusNode.requestFocus();
      return;
    } else if (int.parse(coinController.text) > 10000) {
      AppUtils.showErrorSnackBar(
        bodyText: "You can not add more than 10000 points",
      );
      coinFocusNode.nextFocus();
      leftFocusNode.requestFocus();
      return;
    } else {
      if (spdptpList.isEmpty) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please enter valid ${gameMode.value.name!.toLowerCase()}",
        );
        coinFocusNode.nextFocus();
        leftFocusNode.requestFocus();
      } else {
        for (var i = 0; i < spdptpList.length; i++) {
          addedNormalBidValue = spdptpList[i].toString();
          var existingIndex = selectedBidsList.indexWhere((element) => element.bidNo == addedNormalBidValue);
          if (existingIndex != -1) {
            selectedBidsList[existingIndex].coins =
                (selectedBidsList[existingIndex].coins! + int.parse(coinController.text));
          } else {
            selectedBidsList.insert(
              0,
              Bids(
                bidNo: addedNormalBidValue,
                coins: int.parse(coinController.text),
                gameId: gameMode.value.id,
                subGameId: gameMode.value.id,
                gameModeName: gameMode.value.name,
                remarks: "You invested At ${marketName.value} on $addedNormalBidValue (${gameMode.value.name})",
              ),
            );
          }
        }
      }
      // Get.closeAllSnackbars();
      _calculateTotalAmount();
      coinFocusNode.nextFocus();
      leftFocusNode.requestFocus();
    }
    // } else {
    //   AppUtils.showErrorSnackBar(
    //     bodyText: value['message'] ?? "",
    //   );
    // }
    // Get.closeAllSnackbars();
    coinController.clear();
    leftAnkController.clear();
    middleAnkController.clear();
    rightAnkController.clear();
    coinFocusNode.nextFocus();
    leftFocusNode.requestFocus();
    selectedBidsList.refresh();
    // }
    // );
  }
}
