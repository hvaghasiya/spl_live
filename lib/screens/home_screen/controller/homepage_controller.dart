import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Custom Controllers/wallet_controller.dart';
import '../../../api_services/api_service.dart';
import '../../../helper_files/app_colors.dart';
import '../../../helper_files/constant_variables.dart';
import '../../../helper_files/custom_text_style.dart';
import '../../../helper_files/dimentions.dart';
import '../../../helper_files/ui_utils.dart';
import '../../../models/benner_model.dart';
import '../../../models/bid_history_model_new.dart';
import '../../../models/commun_models/bid_request_model.dart';
import '../../../models/commun_models/starline_bid_request_model.dart';
import '../../../models/commun_models/user_details_model.dart';
import '../../../models/daily_market_api_response_model.dart';
import '../../../models/market_bid_history.dart';
import '../../../models/normal_market_bid_history_response_model.dart';
import '../../../models/notifiaction_models/get_all_notification_model.dart';
import '../../../models/notifiaction_models/notification_count_model.dart';
import '../../../models/passbook_page_model.dart';
import '../../../models/starline_daily_market_api_response.dart';
import '../../../models/starlinechar_model/new_starlinechart_model.dart';
import '../../../routes/app_routes_name.dart';
import '../../More Details Screens/Withdrawal Page/withdrawal_page.dart';
import '../../bottum_navigation_screens/bid_history.dart';
import '../../bottum_navigation_screens/moreoptions.dart';
import '../../bottum_navigation_screens/passbook_page.dart';
import '../../bottum_navigation_screens/spl_wallet.dart';
import '../utils/home_screen_utils.dart';

class HomePageController extends GetxController {
  TextEditingController dateinput = TextEditingController();
  TextEditingController dateinputForResultHistory = TextEditingController();
  DateTime bidHistotyDate = DateTime.now();
  RxBool isStarline = false.obs;
  var arguments = Get.arguments;
  RxBool market = false.obs;
  RxBool bidHistory = false.obs;
  RxBool resultHistory = false.obs;
  RxBool chart = false.obs;
  RxInt widgetContainer = 0.obs;
  RxInt pageWidget = 0.obs;
  RxInt currentIndex = 0.obs;
  var position = 0;
  var spaceBeetween = const SizedBox(height: 10);
  RxList<MarketData> normalMarketList = <MarketData>[].obs;
  RxList<StarlineMarketData> starLineMarketList = <StarlineMarketData>[].obs;
  RxBool noMarketFound = false.obs;
  RxList<StarlineMarketData> marketList = <StarlineMarketData>[].obs;
  RxList<StarlineMarketData> marketListForResult = <StarlineMarketData>[].obs;
  RxList<StarLineDateTime> starlineChartDateAndTime = <StarLineDateTime>[].obs;
  RxList<Markets> starlineChartTime = <Markets>[].obs;
  UserDetailsModel userData = UserDetailsModel();
  RxList<ResultArr> marketHistoryList = <ResultArr>[].obs;
  RxList<Rows> passBookModelData = <Rows>[].obs;
  RxList<Rows> passBookModelData2 = <Rows>[].obs;
  RxInt passbookCount = 0.obs;
  RxBool isStarline2 = false.obs;
  RxInt offset = 0.obs;
  RxList<Bids> selectedBidsList = <Bids>[].obs;
  RxList<StarLineBids> bidList = <StarLineBids>[].obs;
  RxList<BidHistoryNew> marketbidhistory = <BidHistoryNew>[].obs;
  RxList<MarketBidHistory> marketbidhistory1 = <MarketBidHistory>[].obs;
  RxList<dynamic> result = [].obs;
  Rx<Bidhistorymodel> bidMarketModel = Bidhistorymodel().obs;

  // Rx<MarketBidHistory> marketBidHistory = MarketBidHistory().obs;
  RxList<MarketBidHistoryList> marketBidHistoryList =
      <MarketBidHistoryList>[].obs;
  DateTime startEndDate = DateTime.now();

  RxList<NotificationData> notificationData = <NotificationData>[].obs;
  final walletController = Get.put<WalletController>(WalletController());
  RxString walletBalance = "00".obs;
  RxInt getNotifiactionCount = 0.obs;
  RxList<BennerData> bennerData = <BennerData>[].obs;
  RxBool starlineCheck = false.obs;

  callFcmApi(userId) async {
    final token = GetStorage().read(ConstantsVariables.fcmToken);
    Timer(const Duration(milliseconds: 200), () {
      fsmApiCall(userId, token);
    });
  }

  fcmBody(userId, fcmToken) {
    var a = {"id": userId, "fcmToken": fcmToken};
    return a;
  }

  void fsmApiCall(userId, fcmToken) async {
    ApiService().fcmToken(await fcmBody(userId, fcmToken)).then((value) async {
      if (value['status']) {
        // AppUtils.showSuccessSnackBar(
        //     bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  void getNotificationsData() async {
    ApiService().getAllNotifications().then((value) async {
      if (value['status']) {
        GetAllNotificationsData model = GetAllNotificationsData.fromJson(value);
        notificationData.value = model.data!.rows as List<NotificationData>;
        if (model.message!.isNotEmpty) {}
      } else {
        AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      }
    });
  }

  void setboolData() {
    GetStorage().write(ConstantsVariables.timeOut, true);
    GetStorage().write(ConstantsVariables.mPinTimeOut, false);
    GetStorage().write(ConstantsVariables.bidsList, selectedBidsList);
    GetStorage().write(ConstantsVariables.starlineBidsList, bidList);
    GetStorage().write(ConstantsVariables.totalAmount, "0");
    GetStorage().write(ConstantsVariables.marketName, "");
    GetStorage().write(ConstantsVariables.marketNotification, true);
    GetStorage().write(ConstantsVariables.starlineNotification, true);
    starlineCheck.value = GetStorage().read(ConstantsVariables.starlineConnect);

    starlineCheck.value == true
        ? widgetContainer.value = 1
        : widgetContainer.value;
    starlineCheck.value == true ? isStarline.value = true : isStarline.value;
    Timer(const Duration(seconds: 1), () {
      GetStorage().write(ConstantsVariables.starlineConnect, false);
    });

    getBennerData();
  }

  void callMarketsApi() {
    getDailyMarkets();
    marketBidHistoryList.refresh();
    passBookModelData.refresh();
    passBookModelData2.refresh();
    getStarLineMarkets(DateFormat('yyyy-MM-dd').format(startEndDate),
        DateFormat('yyyy-MM-dd').format(startEndDate));
  }

  Future<void> handleRefresh() async {
    // await Future.delayed(const Duration(seconds: 1));
    setboolData();
    callMarketsApi();
    getUserData();
    getNotificationCount();
    getUserBalance();
  }

  @override
  void dispose() {
    marketHistoryList.clear();
    // addFundCon.clear();
    super.dispose();
  }

  ontapOfBidData() {
    Get.toNamed(AppRoutName.newBidHistorypage);
  }

  getUserData() async {
    final data = GetStorage().read(ConstantsVariables.userData);
    userData = UserDetailsModel.fromJson(data);
    callFcmApi(userData.id);
  }

  void getStarLineMarkets(String startDate, String endDate) async {
    ApiService()
        .getDailyStarLineMarkets(startDate: startDate, endDate: endDate)
        .then((value) async {
      if (value['status']) {
        StarLineDailyMarketApiResponseModel responseModel =
        StarLineDailyMarketApiResponseModel.fromJson(value);
        starLineMarketList.value = responseModel.data ?? <StarlineMarketData>[];
        if (starLineMarketList.isNotEmpty) {
          var biddingOpenMarketList = starLineMarketList
              .where((element) =>
          element.isBidOpen == true && element.isBlocked == false)
              .toList();
          var biddingClosedMarketList = starLineMarketList
              .where((element) =>
          element.isBidOpen == false && element.isBlocked == false)
              .toList();
          var tempFinalMarketList = <StarlineMarketData>[];
          biddingOpenMarketList.sort((a, b) {
            DateTime dateTimeA =
            DateFormat('hh:mm a').parse(a.time ?? "00:00 AM");
            DateTime dateTimeB =
            DateFormat('hh:mm a').parse(b.time ?? "00:00 AM");
            return dateTimeA.compareTo(dateTimeB);
          });
          tempFinalMarketList = biddingOpenMarketList;
          biddingClosedMarketList.sort((a, b) {
            DateTime dateTimeA =
            DateFormat('hh:mm a').parse(a.time ?? "00:00 AM");
            DateTime dateTimeB =
            DateFormat('hh:mm a').parse(b.time ?? "00:00 AM");
            return dateTimeA.compareTo(dateTimeB);
          });
          tempFinalMarketList.addAll(biddingClosedMarketList);
          starLineMarketList.value = tempFinalMarketList;
        }
      } else {
        AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      }
    });
  }

  void getDailyMarkets() async {
    ApiService().getDailyMarkets().then((value) async {
      // if (value['status']) {
      //   DailyMarketApiResponseModel marketModel = DailyMarketApiResponseModel.fromJson(value);
      //   if (marketModel.data != null && marketModel.data!.isNotEmpty) {
      //     normalMarketList.value = marketModel.data!;
      //     noMarketFound.value = false;
      //     var biddingOpenMarketList = normalMarketList
      //         .where((element) =>
      //             (element.isBidOpenForClose == true || element.isBidOpenForOpen == true) && element.isBlocked == false)
      //         .toList();
      //     var biddingClosedMarketList = normalMarketList
      //         .where((element) =>
      //             (element.isBidOpenForOpen == false && element.isBidOpenForClose == false) &&
      //             element.isBlocked == false)
      //         .toList();
      //     var tempFinalMarketList = <MarketData>[];
      //     biddingOpenMarketList.sort((a, b) {
      //       DateTime dateTimeA = DateFormat('hh:mm a').parse(a.openTime ?? "00:00 AM");
      //       DateTime dateTimeB = DateFormat('hh:mm a').parse(b.openTime ?? "00:00 AM");
      //       return dateTimeA.compareTo(dateTimeB);
      //     });
      //     tempFinalMarketList = biddingOpenMarketList;
      //     biddingClosedMarketList.sort((a, b) {
      //       DateTime dateTimeA = DateFormat('hh:mm a').parse(a.openTime ?? "00:00 AM");
      //       DateTime dateTimeB = DateFormat('hh:mm a').parse(b.openTime ?? "00:00 AM");
      //       return dateTimeA.compareTo(dateTimeB);
      //     });
      //     tempFinalMarketList.addAll(biddingClosedMarketList);
      //     normalMarketList.value = tempFinalMarketList;
      //   } else {
      //     noMarketFound.value = true;
      //   }
      // } else {
      //   AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      // }
    });
  }

  RxList<Map<String, dynamic>> tickets = [
    {"text": "100", "isSelected": false},
    {"text": "500", "isSelected": false},
    {"text": "1000", "isSelected": false},
    {"text": "5000", "isSelected": false},
    {"text": "10000", "isSelected": false},
  ].obs;

  Widget getDashBoardWidget(index, size, BuildContext context) {
    switch (index) {
      case 0:
        return HomeScreenUtils().gridColumn(size);
      case 1:
        return Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.h5),
            child: HomeScreenUtils().gridColumnForStarLine(size));
      case 2:
        return Container();
      case 3:
        return Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.h10),
            child: HomeScreenUtils().bidHistory(context));
      case 4:
        return Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.h10),
            child: HomeScreenUtils().resultHistory(context));
      case 5:
        return Column(
          children: [
            spaceBeetween,
            const Text(
              "Starline Chart",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: Dimensions.h5),
            starlineChartDateAndTime.isEmpty
                ? SizedBox(
              height: size.height / 2.5,
              child: Center(
                child: Text(
                  "There is no Data in Starlin Chart",
                  style: CustomTextStyle.textRobotoSansMedium,
                ),
              ),
            )
                : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Row(
                children: [
                  HomeScreenUtils().dateColumn(),
                  Expanded(child: HomeScreenUtils().timeColumn())
                ],
              ),
            ),
          ],
        );
      default:
        return HomeScreenUtils().gridColumn(size);
    }
  }

  Future<void> addFund({String? amount}) async {
    try {
      ApiService().addFund(amount: amount).then((value) async {
        print("Add Fund Response: $value");

        if (value['status'] == true && value['data'] != null) {
          var responseData = value['data'];

          if (responseData['status'] == true) {
            walletController.addFundID = responseData['paymentId'];

            String? upiLink;
            String webUrl = responseData['data']['payment_url'] ?? "";

            // Check if UPI intent data is available
            if (responseData['data'] != null &&
                responseData['data']['upi_intent'] != null) {
              // Try getting bhim_link as preferred option
              upiLink = responseData['data']['upi_intent']['bhim_link'];
            }

            // Logic: Try UPI App first, if failed/not found, use Web Browser fallback
            if (upiLink != null && upiLink.isNotEmpty) {
              await _launchPaymentUrl(upiLink, webUrl);
            } else {
              await _launchPaymentUrl(webUrl, null);
            }
          } else {
            AppUtils.showErrorSnackBar(
                bodyText: responseData['msg'] ?? "Payment creation failed");
          }
        } else {
          // API request failed
          Get.defaultDialog(
            barrierDismissible: false,
            title: "",
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value['message'] ?? "Error",
                  textAlign: TextAlign.center,
                  style: CustomTextStyle.textRobotoSansMedium,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: Text("OK"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.appbarColor),
                )
              ],
            ),
          );
        }
      });
    } catch (e) {
      print("Error in addFund: $e");
      AppUtils.showErrorSnackBar(bodyText: "Something went wrong");
    }
  }

  // New Smart Launch Function with Fallback
  Future<void> _launchPaymentUrl(String mainUrl, String? fallbackUrl) async {
    try {
      Uri uri = Uri.parse(mainUrl);

      // Try launching external app (UPI App)
      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw 'Could not launch $mainUrl';
      }
    } catch (e) {
      print("Direct launch failed: $e");

      // Agar UPI app nahi khula, to Fallback URL (Browser) try karo
      if (fallbackUrl != null && fallbackUrl.isNotEmpty) {
        print("Trying fallback URL: $fallbackUrl");
        try {
          await launchUrl(
            Uri.parse(fallbackUrl),
            mode: LaunchMode.externalApplication,
          );
        } catch (e2) {
          print("Fallback also failed");
          Get.snackbar("Error", "Could not open payment page.");
        }
      } else {
        Get.snackbar("Error", "No payment app found and no web fallback available.");
      }
    }
  }

  TextEditingController addFundCon = TextEditingController();

  Widget getDashBoardPages(index, size, BuildContext context,
      {required String notifictionCount}) {
    switch (index) {
      case 0:
        return Column(
          children: [
            AppUtils().appbar(size,
                walletText: walletBalance.toString(),
                onTapTranction: () {},
                notifictionCount: notifictionCount,
                onTapNotifiaction: () =>
                    Get.toNamed(AppRoutName.notificationPage),
                onTapTelegram: () =>
                    launch("https://t.me/satta_matka_kalyan_bazar_milan"),
                shareOntap: () => Share.share("https://spl.live")),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    spaceBeetween,
                    HomeScreenUtils().banner(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.h10, vertical: Dimensions.h5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 0.1,
                              color: AppColors.grey,
                              blurRadius: 10,
                              offset: const Offset(2, 3),
                            )
                          ],
                          borderRadius: BorderRadius.circular(Dimensions.h5),
                          border:
                          Border.all(color: AppColors.redColor, width: 1),
                        ),
                        child: Column(
                          children: [
                            spaceBeetween,
                            HomeScreenUtils().iconsContainer(
                              iconColor1: widgetContainer.value == 0
                                  ? AppColors.appbarColor
                                  : AppColors.iconColorMain,
                              iconColor2: widgetContainer.value == 1
                                  ? AppColors.appbarColor
                                  : AppColors.iconColorMain,
                              iconColor3: widgetContainer.value == 2
                                  ? AppColors.appbarColor
                                  : AppColors.iconColorMain,
                              onTap1: () {
                                position = 0;
                                widgetContainer.value = position;
                                isStarline.value = false;
                              },
                              onTap2: () {
                                position = 1;
                                isStarline.value = true;
                                getDailyStarLineMarkets(
                                  DateFormat('yyyy-MM-dd').format(startEndDate),
                                  DateFormat('yyyy-MM-dd').format(startEndDate),
                                );
                                getMarketBidsByUserId(
                                    lazyLoad: false,
                                    endDate: DateFormat('yyyy-MM-dd')
                                        .format(startEndDate),
                                    startDate: DateFormat('yyyy-MM-dd')
                                        .format(startEndDate));
                                widgetContainer.value = position;
                              },
                              onTap3: () {
                                position = 2;
                                widgetContainer.value = position;
                                isStarline.value = false;
                                pageWidget.value = 2;
                                currentIndex.value = 2;
                                Future.delayed(Duration(milliseconds: 300), () {
                                  position = 0;
                                  widgetContainer.value = position;
                                });
                              },
                            ),
                            spaceBeetween,
                            Obx(() {
                              return isStarline.value
                                  ? HomeScreenUtils().iconsContainer2(
                                iconColor1: widgetContainer.value == 3
                                    ? AppColors.appbarColor
                                    : AppColors.iconColorMain,
                                iconColor2: widgetContainer.value == 4
                                    ? AppColors.appbarColor
                                    : AppColors.iconColorMain,
                                iconColor3: widgetContainer.value == 5
                                    ? AppColors.appbarColor
                                    : AppColors.iconColorMain,
                                onTap1: () {
                                  position = 3;
                                  widgetContainer.value = position;

                                  getMarketBidsByUserId(
                                    lazyLoad: false,
                                    endDate: DateFormat('yyyy-MM-dd')
                                        .format(startEndDate),
                                    startDate: DateFormat('yyyy-MM-dd')
                                        .format(
                                      startEndDate,
                                    ),
                                  );
                                },
                                onTap2: () {
                                  position = 4;
                                  widgetContainer.value = position;

                                  getDailyStarLineMarkets(
                                    DateFormat('yyyy-MM-dd')
                                        .format(startEndDate),
                                    DateFormat('yyyy-MM-dd')
                                        .format(startEndDate),
                                  );
                                },
                                onTap3: () {
                                  position = 5;
                                  widgetContainer.value = position;

                                  callGetStarLineChart();
                                },
                              )
                                  : Container();
                            }),
                          ],
                        ),
                      ),
                    ),
                    Obx(
                          () => getDashBoardWidget(
                        widgetContainer.value,
                        size,
                        context,
                      ),
                    ),
                    spaceBeetween,
                  ],
                ),
              ),
            ),
          ],
        );
      case 1:
        return BidHistory(appbarTitle: "Your Market");
      case 2:
        return const SPLWallet();
      case 3:
        return PassBook();
      case 4:
        return const MoreOptions();
      case 5:
        return WithdrawalPage();
      default:
        return Column(
          children: [
            AppUtils().appbar(size,
                walletText: walletBalance.toString(),
                onTapTranction: () {},
                notifictionCount: notifictionCount,
                onTapNotifiaction: () =>
                    Get.toNamed(AppRoutName.notificationPage),
                onTapTelegram: () =>
                    launch("https://t.me/satta_matka_kalyan_bazar_milan"),
                shareOntap: () => Share.share("https://spl.live")),
            SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  spaceBeetween,
                  HomeScreenUtils().banner(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.h10, vertical: Dimensions.h5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 0.1,
                            color: AppColors.grey,
                            blurRadius: 10,
                            offset: const Offset(2, 3),
                          )
                        ],
                        borderRadius: BorderRadius.circular(Dimensions.h5),
                        border: Border.all(color: AppColors.redColor, width: 1),
                      ),
                      child: Column(
                        children: [
                          spaceBeetween,
                          HomeScreenUtils().iconsContainer(
                            iconColor1: widgetContainer.value == 0
                                ? AppColors.appbarColor
                                : AppColors.iconColorMain,
                            iconColor2: widgetContainer.value == 1
                                ? AppColors.appbarColor
                                : AppColors.iconColorMain,
                            iconColor3: widgetContainer.value == 2
                                ? AppColors.appbarColor
                                : AppColors.iconColorMain,
                            onTap1: () {
                              position = 0;
                              widgetContainer.value = position;
                              isStarline.value = false;
                            },
                            onTap2: () {
                              position = 1;
                              isStarline.value = true;
                              //   callGetStarLineChart();
                              getDailyStarLineMarkets(
                                DateFormat('yyyy-MM-dd').format(startEndDate),
                                DateFormat('yyyy-MM-dd').format(startEndDate),
                              );
                              getMarketBidsByUserId(
                                  lazyLoad: false,
                                  endDate: DateFormat('yyyy-MM-dd')
                                      .format(startEndDate),
                                  startDate: DateFormat('yyyy-MM-dd')
                                      .format(startEndDate));
                              widgetContainer.value = position;
                            },
                            onTap3: () {
                              position = 2;
                              widgetContainer.value = position;
                              isStarline.value = false;
                            },
                          ),
                          spaceBeetween,
                          Obx(() {
                            return isStarline.value
                                ? HomeScreenUtils().iconsContainer2(
                              iconColor1: widgetContainer.value == 3
                                  ? AppColors.appbarColor
                                  : AppColors.iconColorMain,
                              iconColor2: widgetContainer.value == 4
                                  ? AppColors.appbarColor
                                  : AppColors.iconColorMain,
                              iconColor3: widgetContainer.value == 5
                                  ? AppColors.appbarColor
                                  : AppColors.iconColorMain,
                              onTap1: () {
                                position = 3;
                                widgetContainer.value = position;

                                getMarketBidsByUserId(
                                  lazyLoad: false,
                                  endDate: DateFormat('yyyy-MM-dd')
                                      .format(startEndDate),
                                  startDate: DateFormat('yyyy-MM-dd')
                                      .format(
                                    startEndDate,
                                  ),
                                );
                              },
                              onTap2: () {
                                position = 4;
                                widgetContainer.value = position;

                                getDailyStarLineMarkets(
                                  DateFormat('yyyy-MM-dd')
                                      .format(startEndDate),
                                  DateFormat('yyyy-MM-dd')
                                      .format(startEndDate),
                                );
                              },
                              onTap3: () {
                                position = 5;
                                widgetContainer.value = position;

                                callGetStarLineChart();
                              },
                            )
                                : Container();
                          }),
                        ],
                      ),
                    ),
                  ),
                  Obx(
                        () => getDashBoardWidget(
                      widgetContainer.value,
                      size,
                      context,
                    ),
                  ),
                  spaceBeetween,
                ],
              ),
            ),
          ],
        );
    }
  }

  onTapOfNormalMarket(MarketData market) {
    if (market.isBidOpenForClose ?? false) {
      Get.toNamed(AppRoutName.gameModePage, arguments: market);
    } else {
      AppUtils.showErrorSnackBar(bodyText: "Bidding is Closed!!!!");
    }
  }

  void onTapOfStarlineMarket(StarlineMarketData market) {
    if (market.isBidOpen ?? false) {
      Get.toNamed(
        AppRoutName.starLineGameModesPage,
        arguments: market,
      );
    } else {
      AppUtils.showErrorSnackBar(bodyText: "Bidding is Closed!!!!");
    }
  }

  void getDailyStarLineMarkets(String startDate, String endDate) async {
    ApiService()
        .getDailyStarLineMarkets(startDate: startDate, endDate: endDate)
        .then((value) async {
      if (value['status']) {
        StarLineDailyMarketApiResponseModel responseModel =
        StarLineDailyMarketApiResponseModel.fromJson(value);
        marketList.value = responseModel.data ?? <StarlineMarketData>[];
        marketListForResult.value =
            responseModel.data ?? <StarlineMarketData>[];
        if (marketList.isNotEmpty) {
          var biddingOpenMarketList = marketList
              .where((element) =>
          element.isBidOpen == true && element.isBlocked == false)
              .toList();
          var biddingClosedMarketList = marketList
              .where((element) =>
          element.isBidOpen == false && element.isBlocked == false)
              .toList();
          var tempFinalMarketList = <StarlineMarketData>[];
          biddingOpenMarketList.sort((a, b) {
            DateTime dateTimeA =
            DateFormat('hh:mm a').parse(a.time ?? "00:00 AM");
            DateTime dateTimeB =
            DateFormat('hh:mm a').parse(b.time ?? "00:00 AM");
            return dateTimeA.compareTo(dateTimeB);
          });
          tempFinalMarketList = biddingOpenMarketList;
          biddingClosedMarketList.sort((a, b) {
            DateTime dateTimeA =
            DateFormat('hh:mm a').parse(a.time ?? "00:00 AM");
            DateTime dateTimeB =
            DateFormat('hh:mm a').parse(b.time ?? "00:00 AM");
            return dateTimeA.compareTo(dateTimeB);
          });
          tempFinalMarketList.addAll(biddingClosedMarketList);
          marketList.value = tempFinalMarketList;
          marketListForResult.sort((a, b) {
            DateTime dateTimeA =
            DateFormat('hh:mm a').parse(a.time ?? "00:00 AM");
            DateTime dateTimeB =
            DateFormat('hh:mm a').parse(b.time ?? "00:00 AM");
            return dateTimeA.compareTo(dateTimeB);
          });
        }
      } else {
        AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      }
    });
  }

  String getResult(bool resultDeclared, int result) {
    if (resultDeclared) {
      int sum = 0;
      for (int i = result; i > 0; i = (i / 10).floor()) {
        sum += (i % 10);
      }
      return "$result - ${sum % 10}";
    } else {
      return "***-*";
    }
  }

  String getResult2(bool resultDeclared, int result) {
    if (resultDeclared) {
      int sum = 0;
      for (int i = result; i > 0; i = (i / 10).floor()) {
        sum += (i % 10);
      }

      return "$result";
    } else {
      return "***";
    }
  }

  String getResult3(bool resultDeclared, int result) {
    if (resultDeclared) {
      int sum = 0;
      for (int i = result; i > 0; i = (i / 10).floor()) {
        sum += (i % 10);
      }
      return "${sum % 10}";
    } else {
      return "*";
    }
  }

  reverse(String originalString) {
    String reversedString = '';

    for (int i = originalString.length - 1; i >= 0; i--) {
      reversedString += originalString[i];
    }
    return reversedString;
  }

  var cellValue;

  void callGetStarLineChart() async {
    ApiService().getStarlineChar().then((value) async {
      if (value['status']) {
        NewStarLineChartModel model = NewStarLineChartModel.fromJson(value);
        starlineChartDateAndTime.value = model.data!.data!;
        for (var i = 0; i < model.data!.markets!.length; i++) {
          starlineChartTime.value = model.data!.markets as List<Markets>;
        }
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  void getNotificationCount() async {
    ApiService().getNotificationCount().then((value) async {
      if (value['status']) {
        NotifiactionCountModel model = NotifiactionCountModel.fromJson(value);
        getNotifiactionCount.value =
        model.data!.notificationCount == null ? 0 : model.data!.notificationCount!.toInt();

        if (getNotifiactionCount.value > 0) {}
        if (model.message!.isNotEmpty) {
          AppUtils.showSuccessSnackBar(
              bodyText: model.message, headerText: "SUCCESSMESSAGE".tr);
        }
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  Future<void> getMarketBidsByUserId({
    required bool lazyLoad,
    required String startDate,
    required String endDate,
  }) async {
    ApiService()
        .getBidHistoryByUserId(
      userId: userData.id.toString(),
      startDate: startDate,
      endDate: endDate,
      limit: "5000",
      offset: offset.value.toString(),
      isStarline: isStarline.value,
    )
        .then(
          (value) async {
        if (value['status']) {
          if (value['data'] != null) {
            NormalMarketBidHistoryResponseModel model =
            NormalMarketBidHistoryResponseModel.fromJson(value);
            lazyLoad
                ? marketHistoryList
                .addAll(model.data?.resultArr ?? <ResultArr>[])
                : marketHistoryList.value =
                model.data?.resultArr ?? <ResultArr>[];
          }
        } else {
          AppUtils.showErrorSnackBar(
            bodyText: value['message'] ?? "",
          );
        }
      },
    );
  }

  final int itemLimit = 30;

  void getPassBookData({required bool lazyLoad, required String offset}) {
    ApiService()
        .getPassBookData(
      userId: userData.id.toString(),
      isAll: true,
      limit: itemLimit.toString(),
      offset: offset.toString(),
    )
        .then((value) async {
      if (value['status']) {
        if (value['data'] != null) {
          PassbookModel model = PassbookModel.fromJson(value);
          passbookCount.value = int.parse(model.data!.count!.toString());
          passBookModelData.value = model.data?.rows ?? <Rows>[];
          passBookModelData.refresh();
        }
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  int calculateTotalPages() {
    var passbookValue = (passbookCount.value / itemLimit).ceil() - 1;
    var passbookValueZero = (passbookCount.value / itemLimit).ceil();
    if (passbookCount.value < 30) {
      return passbookValueZero;
    } else {
      return passbookValue;
    }
  }

  var num = 0;

  void nextPage() {
    if (offset.value < calculateTotalPages()) {
      passBookModelData.clear();
      offset.value++;

      num = num + itemLimit;

      getPassBookData(lazyLoad: false, offset: num.toString());

      // passBookModelData.refresh();
      update();
    }
  }

  void prevPage() {
    if (offset.value > 0) {
      passBookModelData.clear();
      offset.value--;
      num = num - itemLimit;

      getPassBookData(lazyLoad: false, offset: num.toString());

      passBookModelData.refresh();
      update();
    }
  }

  void marketBidsByUserId({required bool lazyLoad}) {
    ApiService()
        .bidHistoryByUserId(
      userId: userData.id.toString(),
    )
        .then(
          (value) async {
        if (value['status']) {
          if (value['data'] != null) {
            MarketBidHistory model = MarketBidHistory.fromJson(value['data']);
            lazyLoad
                ? marketBidHistoryList
                .addAll(model.rows ?? <MarketBidHistoryList>[])
                : marketBidHistoryList.value =
                model.rows ?? <MarketBidHistoryList>[];
          }
          marketBidHistoryList.refresh();
        } else {
          AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
        }
      },
    );
  }

  void getUserBalance() {
    ApiService().getBalance().then(
          (value) async {
        if (value['status']) {
          if (value['data'] != null) {
            var tempBalance = value['data']['Amount'] ?? 00;
            walletBalance.value = tempBalance.toString();
          }
        } else {
          AppUtils.showErrorSnackBar(
            bodyText: value['message'] ?? "",
          );
        }
      },
    );
  }

  void resetNotificationCount() async {
    ApiService().resetNotification().then((value) async {
      if (value['status']) {
        NotifiactionCountModel model = NotifiactionCountModel.fromJson(value);
        getNotifiactionCount.value = model.data!.notificationCount!.toInt();
        if (model.message!.isNotEmpty) {}
      } else {
        AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      }
    });
  }

  void getBennerData() async {
    ApiService().getBennerData().then((value) async {
      if (value['status']) {
        BennerModel model = BennerModel.fromJson(value);
        bennerData.value = model.data as List<BennerData>;
        //  NotifiactionCountModel model = NotifiactionCountModel.fromJson(value);
        // getNotifiactionCount.value = model.data!.notificationCount!.toInt();
        // if (model.message!.isNotEmpty) {}
      } else {
        AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      }
    });
  }

  RxList<TicketModel> newTicketsList = <TicketModel>[].obs;

  void getTickets() async {
    ApiService().getTickets().then((value) async {
      if (value['status']) {
        newTicketsList.clear();
        List data = value['data'];
        for (int i = 0; i < data.length; i++) {
          newTicketsList.add(TicketModel(name: data[i], isSelected: false.obs));
        }
      } else {
        AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      }
    });
  }
}

class TicketModel {
  String? name;
  RxBool isSelected = false.obs;

  TicketModel({this.name, required this.isSelected});
}


