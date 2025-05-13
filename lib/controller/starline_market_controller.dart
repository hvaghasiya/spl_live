import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:spllive/api_services/api_service.dart';
import 'package:spllive/helper_files/constant_image.dart';
import 'package:spllive/helper_files/constant_variables.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/models/commun_models/user_details_model.dart';
import 'package:spllive/models/market_history.dart';
import 'package:spllive/models/normal_market_bid_history_response_model.dart';
import 'package:spllive/models/starline_daily_market_api_response.dart';
import 'package:spllive/models/starlinechar_model/new_starlinechart_model.dart';

class StarlineMarketController extends GetxController {
  final selectedIndex = Rxn<int>();
  RxList<StarlineFilterModel> starlineButtonList = [
    // StarlineFilterModel(
    //   isSelected: false.obs,
    //   name: "BID HISTORY",
    //   image: ConstantImage.bidHistoryIcon,
    // ),
    StarlineFilterModel(isSelected: false.obs, name: "RESULT HISTORY", image: ConstantImage.resultHistoryNew),
    StarlineFilterModel(isSelected: false.obs, name: "CHART", image: ConstantImage.chartNewIcon),
  ].obs;
  RxList<StarlineMarketData> starLineMarketList = <StarlineMarketData>[].obs;
  RxList<StarlineMarketData> marketList = <StarlineMarketData>[].obs;
  RxList<StarlineMarketData> marketListForResult = <StarlineMarketData>[].obs;
  DateTime startEndDate = DateTime.now();
  DateTime bidHistoryDate = DateTime.now();
  String? starlineMarketDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  TextEditingController dateInputForResultHistory = TextEditingController(text: DateFormat('dd-MM-yyyy').format(DateTime.now()));

  RxList<MarketHistoryList> marketHistoryListt = <MarketHistoryList>[].obs;
  RxBool isMarketResults = false.obs;

  getDailyStarLineMarkets({String? startDate, String? endDate}) async {
    ApiService().getDailyStarLineMarkets(startDate: startDate ?? "", endDate: endDate ?? "").then((value) async {
      if (value['status']) {
        StarLineDailyMarketApiResponseModel responseModel = StarLineDailyMarketApiResponseModel.fromJson(value);
        starLineMarketList.value = responseModel.data ?? <StarlineMarketData>[];
        marketListForResult.value = responseModel.data ?? <StarlineMarketData>[];
        filterMarketList.clear();
        starLineMarketList.forEach((e) {
          filterMarketList.add(FilterModel(isSelected: false.obs, name: e.time, id: e.starlineMarketId));
        });
        print("filterMarketList ${filterMarketList.length}");
        if (starLineMarketList.isNotEmpty) {
          var biddingOpenMarketList = starLineMarketList.where((element) => element.isBidOpen == true && element.isBlocked == false).toList();
          var biddingClosedMarketList = starLineMarketList.where((element) => element.isBidOpen == false && element.isBlocked == false).toList();
          var tempFinalMarketList = <StarlineMarketData>[];
          biddingOpenMarketList.sort((a, b) {
            DateTime dateTimeA = DateFormat('hh:mm a').parse(a.time ?? "00:00 AM");
            DateTime dateTimeB = DateFormat('hh:mm a').parse(b.time ?? "00:00 AM");
            return dateTimeA.compareTo(dateTimeB);
          });
          tempFinalMarketList = biddingOpenMarketList;
          biddingClosedMarketList.sort((a, b) {
            DateTime dateTimeA = DateFormat('hh:mm a').parse(a.time ?? "00:00 AM");
            DateTime dateTimeB = DateFormat('hh:mm a').parse(b.time ?? "00:00 AM");
            return dateTimeA.compareTo(dateTimeB);
          });
          tempFinalMarketList.addAll(biddingClosedMarketList);
          starLineMarketList.value = tempFinalMarketList;
          marketListForResult.sort((a, b) {
            DateTime dateTimeA = DateFormat('hh:mm a').parse(a.time ?? "00:00 AM");
            DateTime dateTimeB = DateFormat('hh:mm a').parse(b.time ?? "00:00 AM");
            return dateTimeA.compareTo(dateTimeB);
          });
        }
      } else {
        AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      }
    });
  }

  TextEditingController dateResultHistory = TextEditingController(text: DateFormat('dd-MM-yyyy').format(DateTime.now()));

  getResultHistory(String? startDate) async {
    ApiService()
        .getResultHistory(
      startDate: startDate,
    )
        .then((value) async {
      if (value['status']) {
        StarLineDailyMarketApiResponseModel responseModel = StarLineDailyMarketApiResponseModel.fromJson(value);
        marketListForResult.value = responseModel.data ?? <StarlineMarketData>[];
        AppUtils.hideProgressDialog();
        if (marketListForResult.isNotEmpty) {
          marketListForResult.sort((a, b) {
            DateTime dateTimeA = DateFormat('hh:mm a').parse(a.time ?? "00:00 AM");
            DateTime dateTimeB = DateFormat('hh:mm a').parse(b.time ?? "00:00 AM");
            return dateTimeA.compareTo(dateTimeB);
          });
        }
      } else {
        AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      }
    });
  }

  getDailyMarketsResults() async {
    isMarketResults.value = true;
    ApiService()
        .getMarketsHistory(
      startDate: starlineMarketDate.toString().isEmpty ? null : starlineMarketDate.toString(),
    )
        .then((value) async {
      if (value['status'] == true) {
        MarketHistoryModel marketHistory = MarketHistoryModel.fromJson(value);
        marketHistoryListt.value = marketHistory.data!;
        isMarketResults.value = false;
        update();
      } else {
        isMarketResults.value = false;
        marketHistoryListt.clear();
        print("isMarketResults.value ${isMarketResults.value} ${marketHistoryListt.value.length}");
        update();
      }
    });
  }

  ////// StarLine Bid history
  RxList<ResultArr> marketHistoryList = <ResultArr>[].obs;
  TextEditingController dateinput = TextEditingController();
  String? date;
  RxInt offset = 0.obs;
  UserDetailsModel userData = UserDetailsModel();
  RxBool isStarline = false.obs;
  RxBool isStarlineBidHistory = false.obs;

  getUserData() async {
    final data = GetStorage().read(ConstantsVariables.userData);
    userData = UserDetailsModel.fromJson(data);
    // callFcmApi(userData.id);
  }

  Future<void> getMarketBidsByUserId() async {
    isStarlineBidHistory.value == true;
    ApiService()
        .getStarBidHistoryByUserId(
      userId: userData.id.toString(),
      startDate: date == "null" ? null : date,
      limit: "5000",
      offset: offset.value.toString(),
      isStarline: true,
      winningStatus: "${isSelectedWinStatusIndex.value}",
      markets: selectedFilterMarketList.value,
    )
        .then(
      (value) async {
        if (value['status']) {
          if (value['data'] != null) {
            NormalMarketBidHistoryResponseModel model = NormalMarketBidHistoryResponseModel.fromJson(value);
            marketHistoryList.value.clear();
            marketHistoryList.value = model.data?.resultArr;
            isStarlineBidHistory.value == false;
          }
        } else {
          isStarlineBidHistory.value == false;
        }
      },
    );
  }

  void getStarlineBidsByUserId() {
    ApiService()
        .getStarBidHistoryByUserId(
      userId: userData.id.toString(),
      startDate: dateinput.text.isEmpty ? null : dateinput.text,
      limit: "5000",
      offset: offset.value.toString(),
      isStarline: true,
      winningStatus: "${isSelectedWinStatusIndex.value}",
      markets: selectedFilterMarketList.value,
    )
        .then(
      (value) async {
        if (value['status']) {
          if (value['data'] != null) {
            marketHistoryList.clear();
            NormalMarketBidHistoryResponseModel model = NormalMarketBidHistoryResponseModel.fromJson(value);
            marketHistoryList.value = model.data?.resultArr ?? <ResultArr>[];
          }
        } else {
          AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
        }
      },
    );
  }

  //// starLine chart

  RxList<StarLineDateTime> starlineChartDateAndTime = <StarLineDateTime>[].obs;
  RxList<Markets> starlineChartTime = <Markets>[].obs;

  void callGetStarLineChart() async {
    ApiService().getStarlineChar().then((value) async {
      if (value['status']) {
        NewStarLineChartModel model = NewStarLineChartModel.fromJson(value);
        starlineChartDateAndTime.value = model.data!.data!;

        for (var i = 0; i < model.data!.markets!.length; i++) {
          starlineChartTime.value = model.data!.markets as List<Markets>;
        }
      } else {
        AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      }
    });
  }

  RxString bannerImage = "".obs;
  RxBool bannerLoad = false.obs;

  void getStarlineBanner() async {
    try {
      bannerLoad.value = true;
      ApiService().getStarlineBanner().then((value) async {
        print("fdskfjghsdkfdfd");
        print(value);
        if (value['status']) {
          bannerLoad.value = false;
          var bannerlist = await (value['data'] as List)
              .where(
                (element) => element["Key"] == "starlinePageBanner" && element["IsActive"] == true,
              )
              .toList();

          print("fdskfhgsdjkfhsdks");
          print(bannerlist);
          if ((bannerlist as List).isNotEmpty) {
            bannerImage.value = bannerlist[0]['Banner'];
          } else {
            bannerImage.value = "";
          }
          // for (var i in (value['data'] as List)) {
          //   print(i);
          //   print("fsdkfjhsdfkjhjk");
          //   if (i["Key"] == "starlinePageBanner" && i["IsActive"] == true) {
          //     bannerImage.value = i['Banner'];
          //     break;
          //   }
          // }

          // "Banner" -> "https://vishnulive.in:9870/public/banner/Test-1.png"
        } else {
          bannerLoad.value = false;
          AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
        }
      });
    } catch (e) {
      bannerLoad.value = false;
      //  print(e);
    }
  }

  onTapWinList(e, value) {
    winStatusList.forEach((j) => j.isSelected.value = false);
    if (e.isSelected.value) {
      e.isSelected.value = false;
    } else {
      e.isSelected.value = true;
    }
    e.isSelected.value = value ?? false;
    if (e.isSelected.value) {
      isSelectedWinStatusIndex.value = e.id;
    } else {
      isSelectedWinStatusIndex.value = null;
    }
  }

  restStartLineBidHistory() {
    Get.back();
    for (var e in starlineButtonList) {
      e.isSelected.value = false;
    }
    selectedFilterMarketList.value = [];
    filterMarketList.forEach((e) => e.isSelected.value = false);
    isSelectedWinStatusIndex.value = null;
    winStatusList.forEach((e) => e.isSelected.value = false);
    dateinput.clear();
    date = null;
  }

  List<FilterModel> filterMarketList = [];
  List<FilterModel> winStatusList = [
    FilterModel(id: 1, name: 'Win', isSelected: false.obs),
    FilterModel(id: 2, name: 'Loss', isSelected: false.obs),
    FilterModel(id: 0, name: 'Pending', isSelected: false.obs)
  ];
  var isSelectedWinStatusIndex = Rxn<int>();
  RxList<int> selectedFilterMarketList = <int>[].obs;
}

class StarlineFilterModel {
  final String? image;
  final String? name;
  RxBool isSelected = false.obs;
  final void Function()? onTap;

  StarlineFilterModel({this.image, this.name, this.onTap, required this.isSelected});
}

class FilterModel {
  final int? id;
  final String? name;
  final RxBool isSelected;

  FilterModel({this.id, this.name, required this.isSelected});
}
