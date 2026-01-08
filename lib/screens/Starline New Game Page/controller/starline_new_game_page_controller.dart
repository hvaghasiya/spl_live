import 'dart:async';
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
import '../../../models/commun_models/json_file_model.dart';
import '../../../models/commun_models/starline_bid_request_model.dart';
import '../../../models/commun_models/user_details_model.dart';
import '../../../models/starline_daily_market_api_response.dart';
import '../../../models/starline_game_modes_api_response_model.dart';

class StarlineNewGamePageController extends GetxController {
  Rx<StarLineGameMod> gameMode = StarLineGameMod().obs;
  Rx<StarlineMarketData> marketData = StarlineMarketData().obs;
  RxString totalAmount = "00".obs;
  var getBIdType = "";
  bool getBidData = false;
  var argument = Get.arguments;
  JsonFileModel jsonModel = JsonFileModel();
  String spValue = "SP";
  String dpValue = "DP";
  String tpValue = "TP";
  RxBool spValue1 = false.obs;
  RxBool dpValue2 = false.obs;
  RxBool tpValue3 = false.obs;
  List<String> selectedValues = [];
  var coinController = TextEditingController();
  TextEditingController autoCompleteFieldController = TextEditingController();
  late FocusNode focusNode;
  Timer? _debounce;
  bool enteredDigitsIsValidate = false;
  String addedNormalBidValue = "";
  RxInt panaControllerLength = 2.obs;
  Rx<StarlineBidRequestModel> requestModel = StarlineBidRequestModel().obs;
//  Rx<StarlineMarketData> marketData = StarlineMarketData().obs;
  RxBool isBulkMode = false.obs;
  var spdptpList = [];
  var selectedBidsList = <StarLineBids>[].obs;
  var marketName = "".obs;
  final List<String> _validationListForNormalMode = [];
  var apiUrl = "";
  RxBool oddbool = true.obs;
  RxBool evenbool = false.obs;
  var leftAnkController = TextEditingController();
  var rightAnkController = TextEditingController();
  var middleAnkController = TextEditingController();
  var gameModeName = "";
  final FocusNode leftFocusNode = FocusNode();
  final FocusNode middleFocusNode = FocusNode();
  final FocusNode rightFocusNode = FocusNode();
  final FocusNode coinFocusNode = FocusNode();
  var digitsPanel = {
    0: "fiveZero",
    1: "oneSix",
    2: "twoSeven",
    3: "threeEight",
    4: "fourNine",
    5: "fiveZero",
    6: "oneSix",
    7: "twoSeven",
    8: "threeEight",
    9: "fourNine",
  };
  Map<String, List<List<String>>> panelGroupChart = {};
  List<String> spdpMotor = [];
  Map<String, dynamic>? spdptplistFromModel = {};
  var digitsForSPDPTP = {
    0: "zero",
    1: "one",
    2: "two",
    3: "three",
    4: "four",
    5: "five",
    6: "six",
    7: "seven",
    8: "eight",
    9: "nine",
  };
  Map<String, List<String>> choisePanaSPDPTP = {};
  @override
  void onInit() {
    getArguments();
    super.onInit();
    focusNode = FocusNode();
  }

  @override
  void onClose() {
    requestModel.value.bids?.clear();
    selectedBidsList.clear();
  }

  @override
  void dispose() {
    leftAnkController.dispose();
    rightAnkController.dispose();
    middleAnkController.dispose();
    coinController.dispose();
    super.dispose();
  }

  checkType(index) {
    if (gameModeName.contains("Ank") || gameModeName.contains("Odd")) {
      return "Ank";
    } else {
      return "Pana";
    }
  }

  void validateEnteredDigit(bool validate, String value) {
    enteredDigitsIsValidate = validate;
    addedNormalBidValue = value;
    if (value.length == panaControllerLength.value) {
      if (gameMode.value.name!.toUpperCase() == "CHOICE PANA SPDP") {
        coinFocusNode.nextFocus();
        leftFocusNode.requestFocus();
      } else {
        focusNode.nextFocus();
      }
    }
  }

  ondebounce(bool validate, String value) {
    if (_debounce != null && _debounce!.isActive) {
      _debounce!.cancel();
    }
    Timer(const Duration(milliseconds: 10), () {
      enteredDigitsIsValidate = validate;
      addedNormalBidValue = value;
      newGamemodeValidation(validate, value);
    });
  }

  newGamemodeValidation(bool validate, String value) {
    if (value.length == panaControllerLength.value) {
      focusNode.nextFocus();
    } else if (gameMode.value.name == "Red Brackets") {
      if (autoCompleteFieldController.text.length < 2) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please enter ${gameMode.value.name!.toLowerCase()}",
        );
      }
    } else if (gameMode.value.name == "SPDPTP") {
      if (spValue1.value == false && dpValue2.value == false && tpValue3.value == false) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please select SP,DP or TP",
        );
      } else if (autoCompleteFieldController.text.isEmpty) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please enter ${gameMode.value.name!.toLowerCase()}",
        );
      }
    }
    enteredDigitsIsValidate = validate;
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
    print("kfhgjdghsfkdsfjksfskhfs");
    if (selectedBidsList.isNotEmpty) {
      requestModel.value.bids = selectedBidsList;
      showConfirmationDialog(context);
    } else {
      AppUtils.showErrorSnackBar(
        bodyText: "Please add some bids!",
      );
    }
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
              StarLineBids(
                bidNo: bidNo,
                coins: coins,
                starlineGameId: gameMode.value.id,
                remarks: "You invested At ${marketData.value.time} on $bidNo (${gameMode.value.name})",
              ),
            );
          }
          // selectedBidsList.add(
          //   StarLineBids(
          //     bidNo: i.toString(),
          //     coins: int.parse(coinController.text),
          //     starlineGameId: gameMode.value.id,
          //     //  gameModeName: gameMode.value.name,
          //     // subGameId: checkPanaType(),
          //     remarks:
          //         "You invested At ${marketName.value} on $i (${gameMode.value.name})",
          //   ),
          // );
        }
      } else {
        if (i % 2 == 0) {
          if (existingIndex != -1) {
            // If the bidNo already exists in selectedBidsList, update coins value.
            selectedBidsList[existingIndex].coins = (selectedBidsList[existingIndex].coins! + coins);
          } else {
            // If bidNo doesn't exist in selectedBidsList, add a new entry.
            selectedBidsList.insert(
              0,
              StarLineBids(
                bidNo: bidNo,
                coins: coins,
                starlineGameId: gameMode.value.id,
                remarks: "You invested At ${marketData.value.time} on $bidNo (${gameMode.value.name})",
              ),
            );
          }
          // selectedBidsList.add(
          //   StarLineBids(
          //     bidNo: i.toString(),
          //     coins: int.parse(coinController.text),
          //     starlineGameId: gameMode.value.id,
          //     // gameModeName: gameMode.value.name,
          //     // subGameId: checkPanaType(),
          //     remarks:
          //         "You invested At ${marketName.value} on $i (${gameMode.value.name})",
          //   ),
          // );
        }
      }
    }
    //autoCompleteFieldController.clear();
    coinController.clear();
    selectedBidsList.refresh();
    _calculateTotalAmount();
    //  focusNode.previousFcus();
  }

  RxList<StarLineGameMod> gameModesList = <StarLineGameMod>[].obs;
  void createMarketBidApi() async {
    ApiService().createStarLineMarketBid(requestModel.value.toJson()).then((value) async {
      if (value['status']) {
        selectedBidsList.clear();
        totalAmount.value = "0";
        Get.back();
        Get.back();
        // Get.offAllNamed(
        //   AppRoutName.starLineGameModesPage, arguments: marketData.value,
        //   // "gameMode": gameMode.value,
        //   // "getBidData": getBidData,
        //   // "getBIdType": getBIdType,
        //   // "gameModeName": gameModeName
        // );
        if (value['data'] == false) {
          selectedBidsList.clear();
          totalAmount.value = "0";
          Get.back();
          Get.back();
          // Get.offAllNamed(
          //   AppRoutName.starLineGameModesPage, arguments: marketData.value,
          //   // "gameMode": gameMode.value,
          //   // "getBidData": getBidData,
          //   // "getBIdType": getBIdType,
          //   // "gameModeName": gameModeName
          // );
          AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
        } else {
          AppUtils.showSuccessSnackBar(bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
        }
        GetStorage().remove(ConstantsVariables.bidsList);
        GetStorage().remove(ConstantsVariables.marketName);
        GetStorage().remove(ConstantsVariables.biddingType);
        final walletController = Get.find<WalletController>();
        walletController.getUserBalance();
        walletController.walletBalance.refresh();
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  Future<void> loadJsonFile() async {
    final String response = await rootBundle.loadString('assets/JSON File/digit_file.json');
    final data = await json.decode(response);
    jsonModel = JsonFileModel.fromJson(data);
  }

  Future<void> getArguments() async {
    gameModeName = argument['gameModeName'];
    gameMode.value = argument['gameMode'];
    marketData.value = argument['marketData'];
    requestModel.value.bids = argument['bidsList'];

    requestModel.refresh();

    _calculateTotalAmount();
    requestModel.value.dailyStarlineMarketId = marketData.value.id;
    var data = await GetStorage().read(ConstantsVariables.userData);
    UserDetailsModel userData = UserDetailsModel.fromJson(data);
    // requestModel.value.userId = userData.id;

    await loadJsonFile();
    List<String> tempValidationList = [];
    switch (gameMode.value.name) {
      case "Single Ank":
        enteredDigitsIsValidate = true;
        panaControllerLength.value = 1;
        tempValidationList = jsonModel.singleAnk!;
        break;
      case "Single Pana":
        panaControllerLength.value = 3;
        tempValidationList = jsonModel.allSinglePana!;
        break;
      case "Double Pana":
        panaControllerLength.value = 3;
        tempValidationList = jsonModel.allDoublePana!;
        break;
      case "Tripple Pana":
        panaControllerLength.value = 3;
        tempValidationList = jsonModel.triplePana!;
        break;
      case "Panel Group":
        panaControllerLength.value = 3;
        panelGroupChart = jsonModel.panelGroupChart!;
        apiUrl = ApiUtils.panelGroup;
        break;
      case "SPDPTP":
        panaControllerLength.value = 1;
        spdptplistFromModel = jsonModel.spdptpChart!;
        tempValidationList = jsonModel.singleAnk!;
        apiUrl = ApiUtils.spdptp;
        break;
      case "Choice Pana SPDP":
        panaControllerLength.value = 1;
        apiUrl = ApiUtils.choicePanaSPDP;
        tempValidationList = jsonModel.singleAnk!;
        choisePanaSPDPTP = jsonModel.spdptp!;
        break;
      case "SP Motor":
        panaControllerLength.value = 10;
        apiUrl = ApiUtils.spMotor;
        spdpMotor = jsonModel.spdptp!['SP'] as List<String>;
        break;
      case "DP Motor":
        panaControllerLength.value = 10;
        apiUrl = ApiUtils.dpMotor;
        spdpMotor = jsonModel.spdptp!['DP'] as List<String>;
        break;
      case "Odd Even":
        panaControllerLength.value = 1;
        tempValidationList = jsonModel.singleAnk!;
        break;
      case "Two Digits Panel":
        apiUrl = ApiUtils.towDigitJodi;
        spdpMotor = jsonModel.allThreePana!;
        panaControllerLength.value = 2;
        break;
    }
    _validationListForNormalMode.addAll(tempValidationList);
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
      } else {}
    }
    var a = panaArray.where((num1) {
      // if ((left.isNotEmpty && num1[0] != left)) {

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

  String getSingleDigit(int pana) {
    String digit = pana.toString();
    int sum = 0;
    String singleAnk = '0';

    for (int i = 0; i < digit.length; i++) {
      sum += int.parse(digit[i]);
    }
    String newResult = sum.toString();

    if (newResult.length > 1) {
      singleAnk = newResult[1];
    } else {
      singleAnk = newResult;
    }

    return singleAnk;
  }

  List<String> getPanelGroupPana(int pana) {
    List<String> bids = [];
    String? digit = digitsPanel[int.parse(getSingleDigit(pana))];
    List<List<String>>? values = panelGroupChart[digit];
    if (values != null) {
      for (int i = 0; i < values.length; i++) {
        List<String> temp = values[i];
        for (int j = 0; j < temp.length; j++) {
          if (temp.contains(pana.toString())) {
            bids = temp;
            break;
          }
        }
      }
    }
    return bids;
  }

  List<String> getSPDPTPPana(int singleAnk) {
    List<String> pana = [];
    var result = spdptplistFromModel![digitsForSPDPTP[singleAnk]];
    for (int i = 0; i < selectedValues.length; i++) {
      List<String> data = result[selectedValues[i]];
      for (int j = 0; j < data.length; j++) {
        pana.add(data[j]);
      }
    }

    return pana;
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
    // LocalStorage.write(ConstantsVariables.bidsList,
    //     requestModel.value.bids!.map((v) => v.toJson()).toList());
    selectedBidsList.refresh();
    _calculateTotalAmount();
  }

  void onTapOfAddButton() {
    // FocusManager.instance.primaryFocus?.unfocus();
    isBulkMode.value = false;

    if (!isBulkMode.value) {
      if (_validationListForNormalMode.contains(addedNormalBidValue) == false) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please enter valid ${gameMode.value.name!.toLowerCase()}",
        );
        autoCompleteFieldController.clear();
        coinController.clear();
        selectedBidsList.refresh();
        focusNode.previousFocus();
      } else if (coinController.text.trim().isEmpty || int.parse(coinController.text.trim()) < 1) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please enter valid points",
        );
        autoCompleteFieldController.clear();
        coinController.clear();
        selectedBidsList.refresh();
        focusNode.previousFocus();
      } else if (int.parse(coinController.text) > 10000) {
        AppUtils.showErrorSnackBar(
          bodyText: "You can not add more than 10000 points",
        );
        autoCompleteFieldController.clear();
        coinController.clear();
        selectedBidsList.refresh();
        focusNode.previousFocus();
      } else {
        if (spdptpList.isEmpty) {
          var existingIndex = selectedBidsList.indexWhere((element) => element.bidNo == addedNormalBidValue);
          if (existingIndex != -1) {
            // If the bidNo already exists in selectedBidsList, update coins value.
            selectedBidsList[existingIndex].coins =
                (selectedBidsList[existingIndex].coins! + int.parse(coinController.text));
          } else {
            // If bidNo doesn't exist in selectedBidsList, add a new entry.
            selectedBidsList.insert(
              0,
              StarLineBids(
                bidNo: addedNormalBidValue,
                coins: int.parse(coinController.text),
                starlineGameId: gameMode.value.id,
                remarks: "You invested At ${marketData.value.time} on $addedNormalBidValue (${gameMode.value.name})",
              ),
            );
          }
        } else {
          var existingIndex = selectedBidsList.indexWhere((element) => element.bidNo == addedNormalBidValue);
          if (existingIndex != -1) {
            // If the bidNo already exists in selectedBidsList, update coins value.
            selectedBidsList[existingIndex].coins =
                (selectedBidsList[existingIndex].coins! + int.parse(coinController.text));
          } else {
            // If bidNo doesn't exist in selectedBidsList, add a new entry.
            selectedBidsList.insert(
              0,
              StarLineBids(
                bidNo: addedNormalBidValue,
                coins: int.parse(coinController.text),
                starlineGameId: gameMode.value.id,
                remarks: "You invested At ${marketData.value.time} on $addedNormalBidValue (${gameMode.value.name})",
              ),
            );
          }
        }

        _calculateTotalAmount();
        autoCompleteFieldController.clear();
        coinController.clear();
        selectedBidsList.refresh();
        focusNode.previousFocus();
      }
    } else {
      if (!enteredDigitsIsValidate) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please enter valid ${gameMode.value.name!.toLowerCase()}",
        );
        autoCompleteFieldController.clear();
        coinController.clear();
        return;
      } else if (addedNormalBidValue.isEmpty) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please enter ${gameMode.value.name!.toLowerCase()}",
        );
        return;
      } else if (coinController.text.isEmpty || int.parse(coinController.text.trim()) < 1) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please enter valid points",
        );
        return;
      } else if (int.parse(coinController.text) > 10000) {
        AppUtils.showErrorSnackBar(
          bodyText: "You can not add more than 10000 points",
        );
        autoCompleteFieldController.clear();
        coinController.clear();
        selectedBidsList.refresh();
        focusNode.previousFocus();
      } else {
        var existingIndex = selectedBidsList.indexWhere((element) => element.bidNo == addedNormalBidValue);
        if (existingIndex != -1) {
          // If the bidNo already exists in selectedBidsList, update coins value.
          selectedBidsList[existingIndex].coins =
              (selectedBidsList[existingIndex].coins! + int.parse(coinController.text));
        } else {
          // If bidNo doesn't exist in selectedBidsList, add a new entry.
          selectedBidsList.insert(
            0,
            StarLineBids(
              bidNo: addedNormalBidValue,
              coins: int.parse(coinController.text),
              starlineGameId: gameMode.value.id,
              remarks: "You invested At ${marketData.value.time} on $addedNormalBidValue (${gameMode.value.name})",
            ),
          );
        }

        autoCompleteFieldController.clear();
        coinController.clear();
        selectedBidsList.refresh();
      }
    }
  }

  Future<Map> spdptpbody() async {
    String panaType = selectedValues.join(',');

    final a = {"digit": autoCompleteFieldController.text, "panaType": panaType};
    final b = {"pana": autoCompleteFieldController.text};
    final c = {
      "left": leftAnkController.text,
      "middle": middleAnkController.text,
      "right": rightAnkController.text,
      "panaType": panaType,
    };
    if (gameMode.value.name == "Panel Group") {
      return b;
    } else if (gameMode.value.name!.toUpperCase() == "CHOICE PANA SPDP") {
      return c;
    } else {
      return a;
    }
  }

  List<String> getSPMotorPana(int inputNum) {
    List<String> panaArray = spdpMotor;
    // Convert the input number to a string to extract individual digits
    List<String> inputDigits = inputNum.toString().split('');
    // Initialize an empty list to store matching elements
    List<String> matchingElements = [];

    // Loop through the elements in the array
    for (String element in panaArray) {
      // Convert each element to a string to extract individual digits
      List<String> elementDigits = element.toString().split('');
      // Check if all the input digits are present in the element digits
      bool tempBool = true;
      for (int i = 0; i < elementDigits.length; i++) {
        if (!inputDigits.contains(elementDigits[i])) {
          tempBool = false;
        }
      }
      if (tempBool) {
        matchingElements.add(element);
      }
    }
    return matchingElements;
  }

  gmaemodeNames() {
    switch (gameMode.value.name!) {
      case "SP Motor":
        return getSPMotorPana(int.parse(autoCompleteFieldController.text));
      case "DP Motor":
        return getSPMotorPana(int.parse(autoCompleteFieldController.text));
      case "Panel Group":
        return getPanelGroupPana(int.parse(autoCompleteFieldController.text));
      case "SPDPTP":
        return getSPDPTPPana(int.parse(autoCompleteFieldController.text.removeAllWhitespace));
      // case "Choice Pana SPDP":
      //   return groupJodi(autoCompleteFieldController.text.removeAllWhitespace);
      case "Two Digits Panel":
        return getTwoDigitPanelPana(int.parse(autoCompleteFieldController.text.removeAllWhitespace));
      default:
    }
  }

  List<String> getTwoDigitPanelPana(int inputNumber) {
    List<int> inputDigits = inputNumber.toString().split('').map(int.parse).toList();

    bool containsBothInputDigits(String num) {
      String numStr = num.toString();
      return inputDigits.every((digit) => numStr.contains(digit.toString()));
    }

    return spdpMotor.where(containsBothInputDigits).toList();
  }

  void newCallOnAddButton() {
    if (coinController.text.trim().isEmpty || int.parse(coinController.text.trim()) < 1) {
      AppUtils.showErrorSnackBar(
        bodyText: "Please enter valid points",
      );
      autoCompleteFieldController.clear();
      coinController.clear();
      selectedBidsList.refresh();
      focusNode.previousFocus();
    } else if (int.parse(coinController.text) > 10000) {
      AppUtils.showErrorSnackBar(
        bodyText: "You can not add more than 10000 points",
      );
      autoCompleteFieldController.clear();
      coinController.clear();
      selectedBidsList.refresh();
      focusNode.previousFocus();
    } else {
      spdptpList = gmaemodeNames();
      if (spdptpList.isEmpty) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please enter valid ${gameMode.value.name!.toLowerCase()}",
        );
        autoCompleteFieldController.clear();
        coinController.clear();
        selectedBidsList.refresh();
        focusNode.previousFocus();
      } else {
        for (var i = 0; i < spdptpList.length; i++) {
          addedNormalBidValue = spdptpList[i].toString();
          var existingIndex = selectedBidsList.indexWhere((element) => element.bidNo == addedNormalBidValue);
          if (existingIndex != -1) {
            // If the bidNo already exists in selectedBidsList, update coins value.
            selectedBidsList[existingIndex].coins =
                (selectedBidsList[existingIndex].coins! + int.parse(coinController.text));
          } else {
            // If bidNo doesn't exist in selectedBidsList, add a new entry.
            selectedBidsList.insert(
              0,
              StarLineBids(
                bidNo: addedNormalBidValue,
                coins: int.parse(coinController.text),
                starlineGameId: gameMode.value.id,
                remarks: "You invested At ${marketData.value.time} on ${spdptpList[i]} (${gameMode.value.name})",
              ),
            );
          }
        }
      }
      _calculateTotalAmount();
      autoCompleteFieldController.clear();
      coinController.clear();
      selectedBidsList.refresh();
      focusNode.previousFocus();
    }
  }

  void getspdptp() async {
    if (gameMode.value.name == "Choice Pana SPDP") {
      if (spValue1.value == false && dpValue2.value == false && tpValue3.value == false) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please select SP,DP or TP",
        );
      } else {
        spdptpList = getChoicePanaSPDPTP();
        // ApiService().newGameModeApi(await spdptpbody(), apiUrl).then(
        //   (value) async {

        //     if (value['status']) {
        //       spdptpList = value['data'];
        if (coinController.text.trim().isEmpty || int.parse(coinController.text.trim()) < 1) {
          AppUtils.showErrorSnackBar(
            bodyText: "Please enter valid points",
          );
          autoCompleteFieldController.clear();
          coinController.clear();
          selectedBidsList.refresh();
          coinFocusNode.nextFocus();
          leftFocusNode.requestFocus();
        } else if (int.parse(coinController.text) > 10000) {
          AppUtils.showErrorSnackBar(
            bodyText: "You can not add more than 10000 points",
          );
          autoCompleteFieldController.clear();
          coinController.clear();
          selectedBidsList.refresh();
          coinFocusNode.nextFocus();
          leftFocusNode.requestFocus();
        } else {
          if (spdptpList.isEmpty) {
            AppUtils.showErrorSnackBar(
              bodyText: "Please enter valid ${gameMode.value.name!.toLowerCase()}",
            );
            autoCompleteFieldController.clear();
            coinController.clear();
            selectedBidsList.refresh();
            coinFocusNode.nextFocus();
            leftFocusNode.requestFocus();
          } else {
            for (var i = 0; i < spdptpList.length; i++) {
              addedNormalBidValue = spdptpList[i].toString();
              var existingIndex = selectedBidsList.indexWhere((element) => element.bidNo == addedNormalBidValue);
              if (existingIndex != -1) {
                // If the bidNo already exists in selectedBidsList, update coins value.
                selectedBidsList[existingIndex].coins =
                    (selectedBidsList[existingIndex].coins! + int.parse(coinController.text));
              } else {
                // If bidNo doesn't exist in selectedBidsList, add a new entry.
                selectedBidsList.insert(
                  0,
                  StarLineBids(
                    bidNo: addedNormalBidValue,
                    coins: int.parse(coinController.text),
                    starlineGameId: gameMode.value.id,
                    remarks: "You invested At ${marketData.value.time} on ${spdptpList[i]} (${gameMode.value.name})",
                  ),
                );
              }
            }
          }
          _calculateTotalAmount();
        }
        // } else {
        //   AppUtils.showErrorSnackBar(
        //     bodyText: value['message'] ?? "",
        //   );
        // }
        autoCompleteFieldController.clear();
        leftAnkController.clear();
        rightAnkController.clear();
        middleAnkController.clear();
        coinController.clear();
        selectedBidsList.refresh();
        coinFocusNode.nextFocus();
        leftFocusNode.requestFocus();
        // },
        // );
      }
    } else {
      ApiService().newGameModeApi(await spdptpbody(), apiUrl).then(
        (value) async {
          if (value['status']) {
            spdptpList = value['data'];
            if (coinController.text.trim().isEmpty || int.parse(coinController.text.trim()) < 1) {
              AppUtils.showErrorSnackBar(
                bodyText: "Please enter valid points",
              );
              autoCompleteFieldController.clear();
              coinController.clear();
              selectedBidsList.refresh();
              focusNode.previousFocus();
            } else if (int.parse(coinController.text) > 10000) {
              AppUtils.showErrorSnackBar(
                bodyText: "You can not add more than 10000 points",
              );
              autoCompleteFieldController.clear();
              coinController.clear();
              selectedBidsList.refresh();
              focusNode.previousFocus();
            } else {
              if (spdptpList.isEmpty) {
                AppUtils.showErrorSnackBar(
                  bodyText: "Please enter valid ${gameMode.value.name!.toLowerCase()}",
                );
                autoCompleteFieldController.clear();
                coinController.clear();
                selectedBidsList.refresh();
                focusNode.previousFocus();
              } else {
                for (var i = 0; i < spdptpList.length; i++) {
                  addedNormalBidValue = spdptpList[i].toString();
                  var existingIndex = selectedBidsList.indexWhere((element) => element.bidNo == addedNormalBidValue);
                  if (existingIndex != -1) {
                    // If the bidNo already exists in selectedBidsList, update coins value.
                    selectedBidsList[existingIndex].coins =
                        (selectedBidsList[existingIndex].coins! + int.parse(coinController.text));
                  } else {
                    // If bidNo doesn't exist in selectedBidsList, add a new entry.
                    selectedBidsList.insert(
                      0,
                      StarLineBids(
                        bidNo: addedNormalBidValue,
                        coins: int.parse(coinController.text),
                        starlineGameId: gameMode.value.id,
                        remarks:
                            "You invested At ${marketData.value.time} on ${spdptpList[i]} (${gameMode.value.name})",
                      ),
                    );
                  }
                }
              }
              _calculateTotalAmount();
            }
          } else {
            AppUtils.showErrorSnackBar(
              bodyText: value['message'] ?? "",
            );
          }
          autoCompleteFieldController.clear();
          leftAnkController.clear();
          rightAnkController.clear();
          middleAnkController.clear();
          coinController.clear();
          selectedBidsList.refresh();
          focusNode.previousFocus();
        },
      );
    }
  }

  void choicePanaSPDPAddButton() {
    spdptpList = getChoicePanaSPDPTP();
    if (spdptpList.isEmpty) {
      AppUtils.showErrorSnackBar(
        bodyText: "Please enter valid ${gameMode.value.name!.toLowerCase()}",
      );
    }
    // ApiService()
    //     .newGameModeApi(await groupJodiBody(), apiUrl)
    //     .then((value) async {

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
              StarLineBids(
                bidNo: addedNormalBidValue,
                coins: int.parse(coinController.text),
                starlineGameId: gameMode.value.id,
                remarks: "You invested At ${marketData.value.time} on ${spdptpList[i]} (${gameMode.value.name})",
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
