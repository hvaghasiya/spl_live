import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../helper_files/constant_variables.dart';
import '../../../helper_files/ui_utils.dart';
import '../../../models/commun_models/bid_request_model.dart';
import '../../../models/commun_models/digit_list_model.dart';
import '../../../models/commun_models/json_file_model.dart';
import '../../../models/commun_models/user_details_model.dart';
import '../../../models/game_modes_api_response_model.dart';
import '../../../routes/app_routes_name.dart';

class GamePageController extends GetxController {
  var panaDigitList = <DigitListModelOffline>[].obs;
  RxInt containerWidget = 0.obs;
  TextEditingController coinController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  RxBool isEnable = false.obs;
  RxBool showNumbersLine = false.obs;
  GameMode gameMode = GameMode();
  List<String> matches = <String>[].obs;
  bool enteredDigitsIsValidate = false;
  var biddingType = "".obs;
  var marketName = "".obs;
  var marketTime = "".obs;
  RxString totalAmount = "0".obs;
  var marketId = 0;
  RxBool isBulkMode = false.obs;
  RxBool validCoinsEntered = false.obs;
  String addedNormalBidValue = "";
  RxInt panaControllerLength = 2.obs;
  RxInt totalBid = 0.obs;
  int selectedIndexOfDigitRow = 0;

  var argument = Get.arguments;
  RxList<Bids> selectedBidsList = <Bids>[].obs;
  RxList<Bids> bidsList = <Bids>[].obs;
  JsonFileModel jsonModel = JsonFileModel();

  var digitList = <DigitListModelOffline>[].obs;
  var serchListMatch = <DigitListModelOffline>[].obs;
  RxList<String> suggestionList = <String>[].obs;
  TextEditingController autoCompleteFieldController = TextEditingController();
  BidRequestModel requestModel = BidRequestModel();

  var singleAnkList = <DigitListModelOffline>[].obs;
  var jodiList = <DigitListModelOffline>[].obs;
  var triplePanaList = <DigitListModelOffline>[].obs;
  var singlePanaList = <DigitListModelOffline>[].obs;
  var doublePanaList = <DigitListModelOffline>[].obs;
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
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    gameMode = argument['gameMode'];
    biddingType.value = argument['biddingType'];
    marketName.value = argument['marketName'];
    marketId = argument['marketId'];
    marketTime.value = argument['time'];
    isBulkMode.value = argument['isBulkMode'];
  }

  ondebounce() {
    if (_debounce != null && _debounce!.isActive) {
      _debounce!.cancel();
    }
    Timer(const Duration(milliseconds: 10), () {
      if (int.parse(coinController.text) == 0) {
        AppUtils.showErrorSnackBar(bodyText: "Please enter minimun 1 coin");
      }
    });
  }

  // onchangeBulk(String val) {}

  Future<void> loadJsonFile() async {
    final String response = await rootBundle.loadString('assets/JSON File/digit_file.json');
    final data = await json.decode(response);
    jsonModel = JsonFileModel.fromJson(data);
  }

  // var marketList = MarketData().obs;
  // List<MarketData> tempMarketList = <MarketData>[];
  Future<void> getArguments() async {
    await loadJsonFile();
    //totalAmount.value = GetStorage().read(ConstantsVariables.totalAmount);
    //print(totalAmount.value);
    bidsList.value = GetStorage().read(ConstantsVariables.bidsList) ?? [];

    // marketList.value = argument['marketValue'];
    // print(marketList.toJson());
    switch (gameMode.name) {
      case "Single Ank Bulk":
        showNumbersLine.value = false;
        enteredDigitsIsValidate = true;
        panaControllerLength.value = 1;
        suggestionList.value = jsonModel.singleAnk!;
        for (var e in jsonModel.singleAnk!) {
          singleAnkList.add(DigitListModelOffline.fromJson(e));
        }
        digitList.value = singleAnkList;
        break;
      case "Jodi Bulk":
        showNumbersLine.value = false;
        suggestionList.value = jsonModel.jodi!;
        panaControllerLength.value = 2;
        for (var e in jsonModel.jodi!) {
          jodiList.add(DigitListModelOffline.fromJson(e));
        }
        digitList.value = jodiList;
        break;
      case "Single Pana Bulk":
        digitRow.first.isSelected = true;
        showNumbersLine.value = true;
        panaControllerLength.value = 3;
        suggestionList.value = jsonModel.singlePana!.single.l0!;

        // for (var e in jsonModel.singlePana!.single.l0!) {
        //   singlePanaList.add(DigitListModelOffline.fromJson(e));
        // }
        // digitList.value = singlePanaList;
        for (var e in jsonModel.allSinglePana!) {
          panaDigitList.add(DigitListModelOffline.fromJson(e));
        }
        List<List<DigitListModelOffline>> chunks = splitListIntoChunks(panaDigitList, 12);
        digitList.value = chunks[0];
        break;
      case "Double Pana Bulk":
        digitRow.first.isSelected = true;
        showNumbersLine.value = true;
        panaControllerLength.value = 3;
        suggestionList.value = jsonModel.doublePana!.single.l0!;
        // for (var e in jsonModel.doublePana!.single.l0!) {
        //   doublePanaList.add(DigitListModelOffline.fromJson(e));
        // }
        // digitList.value = doublePanaList;
        for (var e in jsonModel.allDoublePana!) {
          panaDigitList.add(DigitListModelOffline.fromJson(e));
        }
        List<List<DigitListModelOffline>> chunks = splitListIntoChunks(panaDigitList, 9);
        digitList.value = chunks[0];
        break;
      case "Tripple Pana":
        showNumbersLine.value = false;
        suggestionList.value = jsonModel.triplePana!;
        panaControllerLength.value = 3;
        // for (var e in jsonModel.triplePana!) {
        //   triplePanaList.add(DigitListModelOffline.fromJson(e));
        // }
        // digitList.value = triplePanaList;
        for (var e in jsonModel.allThreePana!) {
          panaDigitList.add(DigitListModelOffline.fromJson(e));
        }
        List<List<DigitListModelOffline>> chunks = splitListIntoChunks(panaDigitList, 12);
        digitList.value = chunks[0];
        break;
    }
    var data = GetStorage().read(ConstantsVariables.userData);
    UserDetailsModel userData = UserDetailsModel.fromJson(data);
    // requestModel.userId = userData.id;
    requestModel.bidType = biddingType.value;
    requestModel.dailyMarketId = marketId;
  }

  List<List<DigitListModelOffline>> splitListIntoChunks(List<DigitListModelOffline> tempList, int chunkSize) {
    List<List<DigitListModelOffline>> chunks = [];

    for (var i = 0; i < tempList.length; i += chunkSize) {
      int end = i + chunkSize;
      if (end > tempList.length) {
        end = tempList.length;
      }
      chunks.add(tempList.sublist(i, end));
    }
    return chunks;
  }

  void onTapNumberList(index) {
    if (validCoinsEntered.value) {
      if (digitList[index].isSelected == false) {
        onTapOfDigitTile(index);
      } else {
        onLongPressDigitTile(index);
      }
    }
  }

  void onTapOfDigitTile(int index) {
    if (coinController.text.isNotEmpty) {
      if (!validCoinsEntered.value) {
        AppUtils.showErrorSnackBar(bodyText: "Please enter valid coins");
        return;
      }
      int tempCoins = int.parse("${digitList[index].coins}");
      digitList[index].coins = tempCoins + int.parse(coinController.text);
      digitList[index].isSelected = true;
      digitList.refresh();
      if (selectedBidsList.isNotEmpty) {
        var tempBid = selectedBidsList.where((element) => element.bidNo == digitList[index].value).toList();

        if (tempBid.isNotEmpty) {
          for (var element in selectedBidsList) {
            if (element.bidNo == digitList[index].value) {
              element.coins = digitList[index].coins;
            }
          }
        } else {
          selectedBidsList.add(
            Bids(
              bidNo: digitList[index].value,
              coins: int.parse(coinController.text),
              gameId: gameMode.id,
              gameModeName: gameMode.name,
              remarks: "You invested At ${marketName.value} on ${digitList[index].value} (${gameMode.name})",
            ),
          );
        }
      } else {
        selectedBidsList.add(
          Bids(
            bidNo: digitList[index].value,
            coins: int.parse(coinController.text),
            gameId: gameMode.id,
            gameModeName: gameMode.name,
            remarks: "You invested At ${marketName.value} on ${digitList[index].value} (${gameMode.name})",
          ),
        );
      }
      _calculateTotalAmount();
    } else {
      // digitList[index].coins = 0;
      validCoinsEntered.value = false;
      digitList.refresh();
      digitList[index].isSelected = false;

      isEnable.value = false;
      digitList.refresh();
      selectedBidsList.removeWhere((element) => element.bidNo == digitList[index].value);
      _calculateTotalAmount();
      // print("Enable Value:${isEnable.value}");
      AppUtils.showErrorSnackBar(bodyText: "Please enter coins!");
    }
  }

  void onLongPressDigitTile(int index) {
    digitList[index].coins = 0;
    digitList[index].isSelected = false;
    digitList.refresh();
    selectedBidsList.removeWhere((element) => element.bidNo == digitList[index].value);
    _calculateTotalAmount();
  }

  void _calculateTotalAmount() {
    var tempTotal = 0;
    for (var element in selectedBidsList) {
      tempTotal += element.coins ?? 0;
    }
    totalAmount.value = tempTotal.toString();
  }

  void onTapOfNumbersLine(int index) {
    for (int i = 0; i < digitRow.length; i++) {
      digitRow[i].isSelected = false;
    }
    digitRow[index].isSelected = true;
    digitRow.refresh();
    if (gameMode.name!.toUpperCase() == "SINGLE PANA BULK") {
      panaSwitchCase(index, 12);
    } else {
      panaSwitchCase(index, 9);
    }
    digitList.refresh();
  }

  // void panaSwitchCase(ThreePana panaList, int index) {
  //   List<DigitListModelOffline> tempList = [];
  //   List<String> temListFor = [];
  //   switch (index) {
  //     case 0:
  //       for (var e in panaList.l0!) {
  //         tempList.add(DigitListModelOffline.fromJson(e));
  //         temListFor.add(e);
  //       }
  //       break;
  //     case 1:
  //       for (var e in panaList.l1!) {
  //         tempList.add(DigitListModelOffline.fromJson(e));
  //         temListFor.add(e);
  //       }
  //       break;
  //     case 2:
  //       for (var e in panaList.l2!) {
  //         tempList.add(DigitListModelOffline.fromJson(e));
  //         temListFor.add(e);
  //       }
  //       break;
  //     case 3:
  //       for (var e in panaList.l3!) {
  //         tempList.add(DigitListModelOffline.fromJson(e));
  //         temListFor.add(e);
  //       }
  //       break;
  //     case 4:
  //       for (var e in panaList.l4!) {
  //         tempList.add(DigitListModelOffline.fromJson(e));
  //         temListFor.add(e);
  //       }
  //       break;
  //     case 5:
  //       for (var e in panaList.l5!) {
  //         tempList.add(DigitListModelOffline.fromJson(e));
  //         temListFor.add(e);
  //       }
  //       break;
  //     case 6:
  //       for (var e in panaList.l6!) {
  //         tempList.add(DigitListModelOffline.fromJson(e));
  //         temListFor.add(e);
  //       }
  //       break;
  //     case 7:
  //       for (var e in panaList.l7!) {
  //         tempList.add(DigitListModelOffline.fromJson(e));
  //         temListFor.add(e);
  //       }
  //       break;
  //     case 8:
  //       for (var e in panaList.l8!) {
  //         tempList.add(DigitListModelOffline.fromJson(e));
  //         temListFor.add(e);
  //       }
  //       break;
  //     case 9:
  //       for (var e in panaList.l9!) {
  //         tempList.add(DigitListModelOffline.fromJson(e));
  //         temListFor.add(e);
  //       }
  //       break;
  //     default:
  //       for (var e in panaList.l0!) {
  //         tempList.add(DigitListModelOffline.fromJson(e));
  //         temListFor.add(e);
  //       }
  //       break;
  //   }
  //   digitList.value = tempList;
  //   suggestionList.value = temListFor;
  // }

  void panaSwitchCase(int index, chunkSize) {
    List<DigitListModelOffline> tempList = [];
    List<List<DigitListModelOffline>> chunks = splitListIntoChunks(panaDigitList, chunkSize);
    switch (index) {
      case 0:
        tempList = chunks[0];
        break;
      case 1:
        tempList = chunks[1];
        break;
      case 2:
        tempList = chunks[2];
        break;
      case 3:
        tempList = chunks[3];
        break;
      case 4:
        tempList = chunks[4];
        break;
      case 5:
        tempList = chunks[5];
        break;
      case 6:
        tempList = chunks[6];
        break;
      case 7:
        tempList = chunks[7];
        break;
      case 8:
        tempList = chunks[8];
        break;
      case 9:
        tempList = chunks[9];
        break;
      default:
        tempList = chunks[0];
        break;
    }
    digitList.value = tempList;
  }

  Future<void> onTapOfSaveButton() async {
    if (selectedBidsList.isNotEmpty) {
      if (bidsList.isNotEmpty) {
        for (var i = 0; i < bidsList.length; i++) {
          var existingIndex = selectedBidsList.indexOf(bidsList[i]);
          selectedBidsList.add(bidsList[i]);
        }
        GetStorage().write(ConstantsVariables.bidsList, selectedBidsList);
        Get.offAndToNamed(AppRoutName.selectedBidsPage, arguments: {
          "bidsList": selectedBidsList,
          "biddingType": biddingType.value,
          "gameName": gameMode.name,
          "marketName": marketName.value,
          "marketId": marketId,
          "totalAmount": totalAmount.value,
        });
        digitList.clear();
        searchController.clear();
        coinController.clear();
        // totalAmount.value = "0";
        //  totalBid.value == "0";
        getArguments();
      } else {
        GetStorage().write(ConstantsVariables.bidsList, selectedBidsList);
        GetStorage().write(ConstantsVariables.totalAmount, totalAmount.value);
        GetStorage().write(ConstantsVariables.bidType, biddingType.value);

        Get.offAndToNamed(AppRoutName.selectedBidsPage, arguments: {
          "bidsList": selectedBidsList,
          "biddingType": biddingType.value,
          "gameName": gameMode.name,
          "marketName": marketName.value,
          "marketId": marketId,
          "totalAmount": totalAmount.value,
        });
        digitList.clear();
        searchController.clear();
        coinController.clear();
        // totalAmount.value = "0";
        //   totalBid.value == "0";
        getArguments();
      }
    } else {
      AppUtils.showErrorSnackBar(
        bodyText: "Please add some bids!",
      );
    }
  }

  void onSearch(val) {
    List<DigitListModelOffline> tempList = digitList;
    if (val.toString().isNotEmpty) {
      var searchResultList = tempList
          .where(
              (element) => element.value.toString().toLowerCase().trim().contains(val.toString().toLowerCase().trim()))
          .toList();
      searchResultList.toSet().toList();
      digitList.value = searchResultList;
    } else {
      switch (gameMode.id) {
        case 19:
          digitList.value = singleAnkList;
          break;
        case 20:
          digitList.value = jodiList;
          break;
        case 21:
          digitList.value = panaDigitList;
          break;
        case 22:
          digitList.value = panaDigitList;
          break;
        default:
          AppUtils.showErrorSnackBar(bodyText: "SOMETHINGWENTWRONG".tr);
          break;
      }
    }
  }
}
