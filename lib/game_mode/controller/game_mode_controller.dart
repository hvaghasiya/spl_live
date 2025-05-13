import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../add_bid.dart';

class GameModeController extends GetxController {
  RxList gameModeList = <String>["Open", "Close"].obs;

  RxList closeGameModeList =
      <String>[
        "Single Ank",
        "Single Ank Bulk",
        "Single Pana",
        "Single Pana Bulk",
        "Double Pana",
        "Double Pana Bulk",
        "Tripple Pana",
        "Panel Group",
        "SPDPTP",
        "Choice Pana SPDP",
        "SP Motor",
        "DP Motor",
        "Odd Even",
        "Two Digits Panel",
      ].obs;
  RxList openGameModeList =
      <String>[
        "Single Ank",
        "Single Ank Bulk",
        "Jodi",
        "Jodi Bulk",
        "Single Pana",
        "Single Pana Bulk",
        "Double Pana",
        "Double Pana Bulk",
        "Tripple Pana",
        "Panel Group",
        "Red Brackets",
        "SPDPTP",
        "Choice Pana SPDP",
        "SP Motor",
        "DP Motor",
        "Group Jodi",
        "Digits Based Jodi",
        "Odd Even",
        "Two Digits Panel",
        "Half Sangam A",
        "Half Sangam B",
        "Full Sangam",
      ].obs;
  RxString gameMode = "Open".obs;
  RxString selectedgameMode = "".obs;

  RxList<SeletedBidList> selectedBidList = <SeletedBidList>[].obs;

  TextEditingController textEditingController = TextEditingController();
  TextEditingController ankTextEditingController = TextEditingController();
  TextEditingController leftAnkTextEditingController = TextEditingController();
  TextEditingController rightAnkTextEditingController = TextEditingController();
  TextEditingController openTextEditingController = TextEditingController();
  TextEditingController closeTextEditingController = TextEditingController();
  TextEditingController pointTextEditingController = TextEditingController();
  @override
  void onInit() {
    loadJsonFile();
    super.onInit();
  }

  var jsonData;
  Future<void> loadJsonFile() async {
    final String response = await rootBundle.loadString('assets/digit_file.json');
    final data = await json.decode(response);
    jsonData = data;
    print(data["single_digit"]);
    print(data["jodi_digit"]);
    print(data["single_pana"]);
    print("${data["single_pana"].length}");
    print(data["double_pana"]);
    print(data["triple_pana"]);
    print(data["all_three_pana"]);
    print(data["all_double_pana"]);
    print(data["all_single_pana"]);
    print("${data["all_single_pana"].length}");
    print(data["panelGroupChart"]);
    log(data.toString());

    // jsonModel = JsonFileModel.fromJson(data);
  }

  RxString selectedBulkAnk = "0".obs;
  RxString selectedOddEven = "odd".obs;
  getchoiceList() {
    switch (selectedgameMode.value) {
      case "Single Ank Bulk":
        return jsonData["single_digit"];
      case "Jodi Bulk":
        return jsonData["jodi_digit"];
      case "Single Pana Bulk":
        return jsonData["single_pana"][0][selectedBulkAnk.value];
      case "Double Pana Bulk":
        return jsonData["double_pana"][0][selectedBulkAnk.value];
      default:
        return [];
    }
  }

  onModeChange(String mode) {
    gameMode.value = mode;
    selectedgameMode.value = "";
  }

  onGameModeChange(String gameMode) {
    selectedgameMode.value = gameMode;
    Get.to(() => AddBidScreen());
  }

  reset(type) {
    if (type == "All") {
      selectedBidList.clear();
    }
    ankTextEditingController.clear();
    pointTextEditingController.clear();
    leftAnkTextEditingController.clear();
    rightAnkTextEditingController.clear();
    closeTextEditingController.clear();
    openTextEditingController.clear();
  }

  addBid() {
    if (pointTextEditingController.text.isEmpty) {
      Get.snackbar("Error", "Please enter a valid points");
      return;
    }
    switch (selectedgameMode.value) {
      case "Single Ank":
        if (validate()) {
          addSelectedBid(ankTextEditingController.text, pointTextEditingController.text);
        } else {
          return;
        }
        break;
      case "Jodi":
        if (validate()) {
          addSelectedBid(ankTextEditingController.text, pointTextEditingController.text);
        } else {
          return;
        }
        break;
      case "Single Pana":
        if (validate()) {
          addSelectedBid(ankTextEditingController.text, pointTextEditingController.text);
        } else {
          return;
        }
        break;
      case "Double Pana":
        if (validate()) {
          addSelectedBid(ankTextEditingController.text, pointTextEditingController.text);
        } else {
          return;
        }
        break;
      case "Tripple Pana":
        if (validate()) {
          addSelectedBid(ankTextEditingController.text, pointTextEditingController.text);
        } else {
          return;
        }
        break;
      case "Panel Group":
        if (validate()) {
          addPanelBid();
        } else {
          return;
        }
        break;
      case "Red Brackets":
        if (validate()) {
          addSelectedBid(ankTextEditingController.text, pointTextEditingController.text);
        } else {
          return;
        }
        break;
      case "Odd Even":
        if (selectedOddEven.value == "odd") {
          addBulkBid(jsonData["odd"]);
        }
        if (selectedOddEven.value == "even") {
          addBulkBid(jsonData["even"]);
        }
        break;
      case "Two Digits Panel":
        if (validate()) {
          addBulkBid(jsonData["twodigitpanel"][ankTextEditingController.text]);
        } else {
          return;
        }
        break;
      case "Digits Based Jodi":
        if (validate()) {
          addDigitBasedJodi();
        } else {
          return;
        }
        break;
      case "Group Jodi":
        if (validate()) {
          addGroupJodi();
        } else {
          return;
        }
        break;
      case "Half Sangam A":
        if (validate()) {
          addSelectedSangamBid(closeTextEditingController.text, openTextEditingController.text, pointTextEditingController.text);
        } else {
          return;
        }
        break;
      case "Half Sangam B":
        if (validate()) {
          addSelectedSangamBid(closeTextEditingController.text, openTextEditingController.text, pointTextEditingController.text);
        } else {
          return;
        }
        break;
      case "Full Sangam":
        if (validate()) {
          addSelectedSangamBid(closeTextEditingController.text, openTextEditingController.text, pointTextEditingController.text);
        } else {
          return;
        }
        break;
      default:
        Get.snackbar("Error", "Please select a valid game mode");
        break;
    }
    reset("");
  }

  addGroupJodi() {
    final list = jsonData["groupJodi"];
    var newlist = [];
    for (var i = 0; i < list.length; i++) {
      print("list[i] ${list[i]}");
      if (list[i].contains(ankTextEditingController.text)) {
        newlist = list[i];
        break;
      }
    }
    if (newlist.isNotEmpty) {
      addBulkBid(newlist);
    }
  }

  addDigitBasedJodi() {
    final list = jsonData["jodi_digit"];
    var newlist = [];
    if (leftAnkTextEditingController.text.isNotEmpty && rightAnkTextEditingController.text.isNotEmpty) {
      newlist =
          list.where((element) {
            return element[0] == leftAnkTextEditingController.text || element[1] == rightAnkTextEditingController.text;
          }).toList();
    } else if (leftAnkTextEditingController.text.isNotEmpty) {
      newlist =
          list.where((element) {
            return element[0] == leftAnkTextEditingController.text;
          }).toList();
    } else if (rightAnkTextEditingController.text.isNotEmpty) {
      newlist =
          list.where((element) {
            return element[1] == rightAnkTextEditingController.text;
          }).toList();
    }
    if (newlist.isNotEmpty) {
      addBulkBid(newlist);
    }
  }

  addBulkBid(selectedlist) {
    print("fsdfhgsfjhgsfs");
    print(selectedlist);
    for (int i = 0; i < selectedlist.length; i++) {
      addSelectedBid(selectedlist[i], pointTextEditingController.text);
    }
    reset("");
  }

  deleteBid(index) {
    selectedBidList.value.removeAt(index);
    selectedBidList.refresh();
  }

  addSelectedBid(pana, points) {
    for (int i = 0; i < selectedBidList.length; i++) {
      if (selectedBidList[i].pana == pana) {
        selectedBidList.value[i] = SeletedBidList(pana: pana, points: selectedBidList[i].points + int.parse(points));
        selectedBidList.refresh();
        return;
      }
    }
    selectedBidList.add(SeletedBidList(pana: pana, points: int.parse(points)));
  }

  addSelectedSangamBid(close, open, points) {
    for (int i = 0; i < selectedBidList.length; i++) {
      if (selectedBidList[i].sangamclose == close && selectedBidList[i].sangamopen == open) {
        selectedBidList.value[i] = SeletedBidList(sangamclose: close, sangamopen: open, points: selectedBidList[i].points + int.parse(points));
        selectedBidList.refresh();
        return;
      }
    }
    selectedBidList.add(SeletedBidList(sangamclose: close, sangamopen: open, points: int.parse(points)));
  }

  addPanelBid() {
    final panelList = getPanelGroup();
    if (panelList.isEmpty) {
      Get.snackbar("Error", "Please enter a valid panel group");
      return;
    }

    addBulkBid(panelList);
  }

  getPanelGroup() {
    int sum = ankTextEditingController.text.toString().split('').map(int.parse).reduce((a, b) => a + b);
    final digitString = jsonData["digitsPanel"][sum.toString()];
    final dataList = jsonData["panelGroupChart"][digitString];
    if (dataList == null) {
      return [];
    }
    for (var i = 0; i < dataList.length; i++) {
      if (dataList[i].contains(ankTextEditingController.text)) {
        return dataList[i];
      }
    }
    return [];
  }

  validate() {
    switch (selectedgameMode.value) {
      case "Single Ank":
        if (ankTextEditingController.text.isEmpty) {
          Get.snackbar("Error", "Please enter a ank");
          return false;
        } else {
          return true;
        }
      case "Jodi":
        if (ankTextEditingController.text.isEmpty) {
          Get.snackbar("Error", "Please enter a Jodi");
          return false;
        } else {
          return true;
        }
      case "Single Pana":
        if (ankTextEditingController.text.isEmpty) {
          Get.snackbar("Error", "Please enter a Single Pana");
          return false;
        } else if (!jsonData["all_single_pana"].contains(ankTextEditingController.text)) {
          Get.snackbar("Error", "Please enter a valid Single Pana");
          return false;
        } else {
          return true;
        }
      case "Double Pana":
        if (ankTextEditingController.text.isEmpty) {
          Get.snackbar("Error", "Please enter a Double Pana");
          return false;
        } else if (!jsonData["all_double_pana"].contains(ankTextEditingController.text)) {
          Get.snackbar("Error", "Please enter a valid Double Pana");
          return false;
        } else {
          return true;
        }
      case "Tripple Pana":
        if (ankTextEditingController.text.isEmpty) {
          Get.snackbar("Error", "Please enter a Tripple Pana");
          return false;
        } else if (!jsonData["triple_pana"].contains(ankTextEditingController.text)) {
          Get.snackbar("Error", "Please enter a valid Tripple Pana");
          return false;
        } else {
          return true;
        }
      case "Panel Group":
        if (ankTextEditingController.text.isEmpty) {
          Get.snackbar("Error", "Please enter a Panel Group");
          return false;
        } else {
          return true;
        }
      case "Red Brackets":
        if (ankTextEditingController.text.isEmpty) {
          Get.snackbar("Error", "Please enter a Red Brackets");
          return false;
        } else if (!jsonData["redBrackelist"].contains(ankTextEditingController.text)) {
          Get.snackbar("Error", "Please enter a valid Red Brackets");
          return false;
        } else {
          return true;
        }
      case "Two Digits Panel":
        if (ankTextEditingController.text.isEmpty) {
          Get.snackbar("Error", "Please enter a Two Digits Panel");
          return false;
        } else if (ankTextEditingController.text.length < 2) {
          Get.snackbar("Error", "Please enter a valid Two Digits Panel");
          return false;
        } else {
          return true;
        }
      case "Group Jodi":
        if (ankTextEditingController.text.isEmpty) {
          Get.snackbar("Error", "Please enter a Group Jodi");
          return false;
        } else if (ankTextEditingController.text.length < 2) {
          Get.snackbar("Error", "Please enter a valid Group Jodi");
          return false;
        } else {
          return true;
        }
      case "Digits Based Jodi":
        if (leftAnkTextEditingController.text.isEmpty && rightAnkTextEditingController.text.isEmpty) {
          Get.snackbar("Error", "Please enter a Digits Based Jodi");
          return false;
        } else {
          return true;
        }
      case "Half Sangam A":
        if (openTextEditingController.text.isEmpty) {
          Get.snackbar("Error", "Please enter Pana");
          return false;
        } else if (closeTextEditingController.text.isEmpty) {
          Get.snackbar("Error", "Please enter Digit");
          return false;
        } else if (closeTextEditingController.text.length < 3) {
          Get.snackbar("Error", "Please enter a valid Enter Pana");
          return false;
        } else if (!jsonData["all_three_pana"].contains(closeTextEditingController.text)) {
          Get.snackbar("Error", "Please enter a valid Panavcbcv");
          return false;
        } else {
          return true;
        }
      case "Half Sangam B":
        if (closeTextEditingController.text.isEmpty) {
          Get.snackbar("Error", "Please enter Pana");
          return false;
        } else if (openTextEditingController.text.isEmpty) {
          Get.snackbar("Error", "Please enter Digit");
          return false;
        } else if (openTextEditingController.text.length < 3) {
          Get.snackbar("Error", "Please enter a valid Enter Pana");
          return false;
        } else if (!jsonData["all_three_pana"].contains(openTextEditingController.text)) {
          Get.snackbar("Error", "Please enter a valid Pana");
          return false;
        } else {
          return true;
        }
      case "Full Sangam":
        if (closeTextEditingController.text.isEmpty) {
          Get.snackbar("Error", "Please enter Pana");
          return false;
        } else if (openTextEditingController.text.isEmpty) {
          Get.snackbar("Error", "Please enter Pana");
          return false;
        } else if (openTextEditingController.text.length < 3) {
          Get.snackbar("Error", "Please enter a valid Enter Pana");
          return false;
        } else if (closeTextEditingController.text.length < 3) {
          Get.snackbar("Error", "Please enter a valid Enter Pana");
          return false;
        } else if (!jsonData["all_three_pana"].contains(openTextEditingController.text)) {
          Get.snackbar("Error", "Please enter a valid Pana");
          return false;
        } else if (!jsonData["all_three_pana"].contains(closeTextEditingController.text)) {
          Get.snackbar("Error", "Please enter a valid Pana");
          return false;
        } else {
          return true;
        }
    }
  }
}

class SeletedBidList {
  final pana;
  final points;
  final sangamopen;
  final sangamclose;
  SeletedBidList({this.pana, this.points, this.sangamopen, this.sangamclose});
}
