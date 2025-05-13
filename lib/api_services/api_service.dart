import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/models/BankHistory.dart';
import 'package:spllive/models/FundTransactionModel.dart';
import 'package:spllive/models/daily_market_api_response_model.dart';
import 'package:spllive/models/get_withdrawal_time.dart';
import 'package:spllive/models/tikets_model.dart';
import 'package:spllive/routes/app_routes_name.dart';

import '../helper_files/constant_variables.dart';
import 'api_urls.dart';
import 'network_info.dart';

class ApiService extends GetConnect implements GetxService {
  Map<String, String>? headers = {};
  Map<String, String>? headersWithToken = {};
  String contentType = "";
  String authToken = '';
  final allowAutoSignedCert = true;

  @override
  void onInit() {
    allowAutoSignedCert = true;
    super.onInit();
  }

  Future<void> initApiService() async {
    authToken = GetStorage().read(ConstantsVariables.authToken) ?? "";
    await NetworkInfo.checkNetwork().whenComplete(() async {
      headers = {"Accept": "application/json"};
      headersWithToken = {"Accept": "application/json", "Authorization": "Bearer $authToken"};
    });
  }

  Future<dynamic> signUpAPI(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();

    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.signUP,
      body,
      headers: headers,
      // contentType: contentType,
    );
    if (kDebugMode) {
      developer.log("RESPONSE : ${response.body} RESPONSE HEADER:  ${response.request?.url}");
    }
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      AppUtils.showErrorSnackBar(bodyText: "Something went wrong");
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> signInAPI(body) async {
    try {
      AppUtils.showProgressDialog(isCancellable: false);
      await initApiService();
      final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).post(
        ApiUtils.signIN,
        body,
        headers: headers,
      );
      if (kDebugMode) {
        developer.log("RESPONSE : ${response.body} RESPONSE HEADER:  ${response.request?.url}");
      }
      if (response.status.hasError) {
        AppUtils.hideProgressDialog();
        AppUtils.showErrorSnackBar(bodyText: "Something went wrong");
        return Future.error(response.statusText!);
      } else {
        AppUtils.hideProgressDialog();
        return response.body;
      }
    } catch (e) {
      AppUtils.hideProgressDialog();
    }
  }

  Future<dynamic> verifyUser(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.verifyUSER,
      body,
      headers: headers,
      // contentType: contentType,
    );
    if (kDebugMode) {
      developer.log("RESPONSE : ${response.body} RESPONSE HEADER:  ${response.request?.url}");
    }
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();

      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> logout() async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.logout,
      {},
      headers: headersWithToken,
      // contentType: contentType,
    );
    if (kDebugMode) {
      developer.log("RESPONSE : ${response.body} RESPONSE HEADER:  ${response.request?.url}");
    }

    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> forgotPassword(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.forgotPassword,
      body,
      headers: headers,
      // contentType: contentType,
    );
    if (kDebugMode) {
      developer.log("RESPONSE : ${response.body} RESPONSE HEADER:  ${response.request?.url}");
    }
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> resetPassword(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.resetPassword,
      body,
      headers: headersWithToken,
      // contentType: contentType,
    );
    if (kDebugMode) {
      developer.log("RESPONSE : ${response.body} RESPONSE HEADER:  ${response.request?.url}");
    }
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getBankDetails() async {
    await initApiService();
    // AppUtils.showProgressDialog(isCancellable: false);
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
      ApiUtils.getBankDetails,
      headers: headersWithToken,
    );
    if (kDebugMode) {
      developer.log("RESPONSE HEADER URl:  ${response.request?.url} RESPONSE : ${response.body} ");
    }
    if (response.status.hasError) {
      // AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      // AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> editBankDetails(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).put(
      ApiUtils.editBankDetails,
      body,
      headers: headersWithToken,
    );
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<DailyMarketApiResponseModel?> getDailyMarkets() async {
    Future.delayed(const Duration(milliseconds: 2), () {
      AppUtils.showProgressDialog(isCancellable: false);
    });

    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
      ApiUtils.getDailyMarkets,
      headers: headersWithToken,
    );
    if (kDebugMode) {
      developer.log("RESPONSE : ${response.body} RESPONSE HEADER:  ${response.request?.url}");
    }
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return DailyMarketApiResponseModel.fromJson(response.body);
    }
  }

  Future<dynamic> getGameModes({required String openCloseValue, required int marketID}) async {
    Future.delayed(const Duration(milliseconds: 2), () {
      AppUtils.showProgressDialog(isCancellable: false);
    });

    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
      "${ApiUtils.getGameModes}$openCloseValue/$marketID",
      headers: headersWithToken,
    );
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> createMarketBid(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.createMarketBid,
      body,
      headers: headersWithToken,
      // contentType: contentType,
    );

    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> createStarLineMarketBid(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.createStarLineMarketBid,
      body,
      headers: headersWithToken,
      // contentType: contentType,
    );

    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      AppUtils.showErrorSnackBar(
        bodyText: response.status.code.toString() + response.toString(),
      );
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> createWithdrawalRequest(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.createWithdrawalRequest,
      body,
      headers: headersWithToken,
      // contentType: contentType,
    );
    print(response.request!.url!);
    print("Fsdkjfhsdkfjhsflksfl");
    print(response.body);
    print(response.statusCode);
    print(response.headers);
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getDailyStarLineMarkets({required String startDate, required String endDate}) async {
    Future.delayed(const Duration(milliseconds: 2), () {
      // AppUtils.showProgressDialog(isCancellable: false);
    });

    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
      "${ApiUtils.getDailyStarLineMarkets}?startDate=$startDate&endDate=$endDate",
      headers: headersWithToken,
    );

    if (kDebugMode) {
      developer.log("RESPONSE HEADER:  ${response.request?.url} RESPONSE : ${response.body} ");
    }
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      // if (response.status.code != null && response.status.code == 401) {
      //   tokenExpired();
      // }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getResultHistory({
    required String? startDate,
  }) async {
    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
      "${ApiUtils.getDailyStarLineMarkets}?startDate=$startDate&endDate=$startDate",
      headers: headersWithToken,
    );

    if (kDebugMode) {
      developer.log("RESPONSE HEADER:  ${response.request?.url} RESPONSE : ${response.body} ");
    }
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getMarketsHistory({
    required String? startDate,
  }) async {
    Future.delayed(const Duration(milliseconds: 2), () {
      // AppUtils.showProgressDialog(isCancellable: false);
    });

    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
      "${ApiUtils.marketResult}?date=$startDate",
      headers: headersWithToken,
    );

    if (kDebugMode) {
      developer.log("RESPONSE HEADER:  ${response.request?.url} RESPONSE : ${response.body} ");
    }
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      // if (response.status.code != null && response.status.code == 401) {
      //   tokenExpired();
      // }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getStarLineGameModes({required int marketID}) async {
    Future.delayed(const Duration(milliseconds: 2), () {
      AppUtils.showProgressDialog(isCancellable: false);
    });

    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
      "${ApiUtils.getStarLineGameModes}$marketID",
      headers: headersWithToken,
    );
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getTransactionHistoryById({
    String? userId,
    String? offset,
    String? limit,
  }) async {
    Future.delayed(const Duration(milliseconds: 2), () {
      AppUtils.showProgressDialog(isCancellable: false);
    });

    await initApiService();
    // final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
    //   // "${ApiUtils.getTransactionHistory}?id=$userId&limit=100&offset=$offset",
    //   headers: headersWithToken,
    // );
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.getTransactionHistory,
      {"userId": userId, "limit": limit, "offset": offset},
      headers: headersWithToken,
    );
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getFeedbackAndRatingsById({required int? userId}) async {
    Future.delayed(const Duration(milliseconds: 2), () {
      AppUtils.showProgressDialog(isCancellable: false);
    });

    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
      ApiUtils.getFeedbackAndRatingsById,
      headers: headersWithToken,
    );
    if (kDebugMode) {
      developer.log("RESPONSE : ${response.body} RESPONSE HEADER:  ${response.request?.url}");
    }
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getWithdrawalHistoryByUserId({required int? userId}) async {
    // Future.delayed(const Duration(milliseconds: 2), () {
    //   AppUtils.showProgressDialog(isCancellable: false);
    // });

    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
      // "${ApiUtils.getWithdrawalHistoryByUserId}$userId",
      ApiUtils.getWithdrawalHistoryByUserId,
      headers: headersWithToken,
    );

    if (kDebugMode) {
      developer.log("RESPONSE HEADER:  ${response.request?.url} RESPONSE : ${response.body} ");
    }
    if (response.status.hasError) {
      // AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      // AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  // Future<dynamic> getWithdrawalRequestTime() async {
  //   Future.delayed(const Duration(milliseconds: 2), () {
  //     AppUtils.showProgressDialog(isCancellable: false);
  //   });

  //   await initApiService();
  //   final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
  //     ApiUtils.getWithdrawalRequestTime,
  //     headers: headersWithToken,
  //   );
  //   if (response.status.hasError) {
  //     AppUtils.hideProgressDialog();
  //     if (response.status.code != null && response.status.code == 401) {
  //       tokenExpired();
  //     }
  //     return Future.error(response.statusText!);
  //   } else {
  //     AppUtils.hideProgressDialog();
  //     return response.body;
  //   }
  // }

  Future<dynamic> getStarlineGameRates() async {
    Future.delayed(const Duration(milliseconds: 2), () {
      AppUtils.showProgressDialog(isCancellable: false);
    });

    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
      "${ApiUtils.getStarlineGameRates}true",
      headers: headersWithToken,
    );
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getGameRates({required bool forStarlineGameModes}) async {
    Future.delayed(const Duration(milliseconds: 2), () {
      AppUtils.showProgressDialog(isCancellable: false);
    });

    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
      "${ApiUtils.getStarlineGameRates}$forStarlineGameModes",
      headers: headersWithToken,
    );
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> createFeedback(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.createFeedback,
      body,
      headers: headersWithToken,
      // contentType: contentType,
    );

    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> resendOTP(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.resendOTP,
      body,
      headers: headersWithToken,
    );
    if (kDebugMode) {
      developer.log("Resqeust URL  ${response.request?.url} response ${response.body}");
    }
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }

      return response.body;
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> verifyMPIN(body) async {
    try {
      AppUtils.showProgressDialog(isCancellable: false);
      await initApiService();
      final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).post(
        ApiUtils.verifyMPIN,
        body,
        headers: headersWithToken,
      );
      if (response.status.hasError) {
        AppUtils.hideProgressDialog();
        if (response.status.code != null && response.status.code == 401) {
          tokenExpired();
        }
        return response.body;
      } else {
        AppUtils.hideProgressDialog();
        return response.body;
      }
    } catch (e) {
      AppUtils.hideProgressDialog();
    }
  }

  Future<dynamic> forgotMPIN() async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
      ApiUtils.forgotMPIN,
      headers: headersWithToken,
    );
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  // new api functions

  Future<dynamic> setUserDetails(body) async {
    // AppUtils.showProgressDialog(isCancellable: false);
    try {
      await initApiService();
      final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).post(
        ApiUtils.setUserDetails,
        body,
        headers: headersWithToken,
      );
      if (response.status.hasError) {
        AppUtils.hideProgressDialog();
        if (response.status.code != null && response.status.code == 401) {
          tokenExpired();
        }

        return response.body;
      } else {
        AppUtils.hideProgressDialog();
        return response.body;
      }
    } catch (e) {
      AppUtils.hideProgressDialog();
    }
  }

  // Future<dynamic> setDeviceDetails(body) async {
  //   try {
  //     AppUtils.showProgressDialog(isCancellable: false);
  //     await initApiService();
  //     final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).post(
  //       ApiUtils.setDeviceDetails,
  //       body,
  //       headers: headersWithToken,
  //     );
  //
  //     if (response.status.hasError) {
  //       AppUtils.hideProgressDialog();
  //       if (response.status.code != null && response.status.code == 401) {
  //         tokenExpired();
  //       }
  //
  //       return response.body;
  //     } else {
  //       AppUtils.hideProgressDialog();
  //       return response.body;
  //     }
  //   } catch (e) {
  //     AppUtils.hideProgressDialog();
  //
  //   }
  // }

  Future<dynamic> setMPIN(body) async {
    try {
      AppUtils.showProgressDialog(isCancellable: false);
      await initApiService();
      final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).post(
        ApiUtils.setMPIN,
        body,
        headers: headersWithToken,
      );
      if (response.status.hasError) {
        AppUtils.hideProgressDialog();
        if (response.status.code != null && response.status.code == 401) {
          tokenExpired();
        }
        return response.body;
      } else {
        // AppUtils.hideProgressDialog();
        return response.body;
      }
    } catch (e) {
      AppUtils.hideProgressDialog();
    }
  }

  Future<void> tokenExpired() async {
    GetStorage().remove(ConstantsVariables.authToken);
    AppUtils.showErrorSnackBar(bodyText: "Session timeout, sign in again");
    Get.offAllNamed(AppRoutName.walcomeScreen);
  }

  Future<dynamic> verifyOTP(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.verifyOTP,
      body,
      headers: headersWithToken,
      // contentType: contentType,
    );

    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      AppUtils.showErrorSnackBar(
        bodyText: response.status.code.toString() + response.toString(),
      );
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getBalance() async {
    try {
      await initApiService();
      final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
        ApiUtils.getBalance,
        headers: headersWithToken,
      );
      if (response.status.hasError) {
        if (response.status.code != null && response.status.code == 401) {
          tokenExpired();
        }
        return Future.error(response.statusText!);
      } else {
        return response.body;
      }
    } catch (e) {}
  }

  Future<dynamic> getWithBankDetails() async {
    try {
      await initApiService();
      final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
        ApiUtils.checkBankDetails,
        headers: headersWithToken,
      );
      if (kDebugMode) {
        developer.log("RESPONSE : ${response.body} RESPONSE request?.url:  ${response.request?.url}");
      }
      if (response.status.hasError) {
        if (response.status.code != null && response.status.code == 401) {
          tokenExpired();
        }
        return Future.error(response.statusText!);
      } else {
        return response.body;
      }
    } catch (e) {}
  }

  Future<dynamic> getBidHistoryByUserId({
    required String userId,
    required String limit,
    required String offset,
    required bool isStarline,
    required String? startDate,
    String? endDate,
    String? winningStatus,
    List<int>? markets,
  }) async {
    // AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
        "${isStarline ? ApiUtils.starlineMarketBidHistory : ApiUtils.normalMarketBidHistory}?limit=$limit&offset=$offset&startDate=$startDate&endDate=$endDate",
        headers: headersWithToken,
        query: {
          "limit": limit,
          "offset": offset,
          "startDate": startDate,
          "endDate": endDate,
          "winningStatus": winningStatus,
          "markets": markets?.join(","),
        });
    if (kDebugMode) {
      developer.log("RESPONSE HEADER:  ${response.request?.url} RESPONSE : ${response.body} ");
    }
    if (response.status.hasError) {
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      AppUtils.hideProgressDialog();
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getStarBidHistoryByUserId({
    required String userId,
    required String limit,
    required String offset,
    required bool isStarline,
    required String? startDate,
    String? winningStatus,
    List<int>? markets,
  }) async {
    // AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true)
        .get(ApiUtils.starlineMarketBidHistory, headers: headersWithToken, query: {
      "limit": limit,
      "offset": offset,
      "startDate": startDate,
      "winningStatus": winningStatus,
      "markets": markets?.join(","),
    });
    if (kDebugMode) {
      developer.log("RESPONSE HEADER:  ${response.request?.url} RESPONSE : ${response.body} ");
    }
    if (response.status.hasError) {
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      AppUtils.hideProgressDialog();
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> changePassword(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.changePassword,
      body,
      headers: headersWithToken,
    );

    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }

      return response.body;
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> changeMPIN(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await put(
      ApiUtils.changeMPIN,
      body,
      headers: headersWithToken,
    );

    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }

      return response.body;
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getStarlineChar() async {
    Future.delayed(const Duration(milliseconds: 2), () {
      AppUtils.showProgressDialog(isCancellable: false);
    });

    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
      ApiUtils.webStarLinechar,
      headers: headersWithToken,
    );
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      // if (response.status.code != null && response.status.code == 401) {
      //   tokenExpired();
      // }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getStarlineBanner() async {
    Future.delayed(const Duration(milliseconds: 2), () {
      AppUtils.showProgressDialog(isCancellable: false);
    });

    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true)
        .get(ApiUtils.getStarlineBanner, headers: headersWithToken, query: {});
    print("fsdkjfjhsdkjfhsdkjfhskjfhskdf");
    print(response.body);
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  // Future<dynamic> starlineMarketBidHistory({
  //   required String userId,
  //   required String limit,
  //   required String offset,
  // }) async {
  //   AppUtils.showProgressDialog(isCancellable: false);
  //   await initApiService();
  //   final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
  //     "${ApiUtils.dailyStarlineMarketBidHistory}?id=$userId&limit=$limit&offset=$offset",
  //     headers: headersWithToken,
  //   );
  //   if (response.status.hasError) {
  //     if (response.status.code != null && response.status.code == 401) {
  //       tokenExpired();
  //     }
  //     AppUtils.hideProgressDialog();

  //     return Future.error(response.statusText!);
  //   } else {
  //     AppUtils.hideProgressDialog();

  //     return response.body;
  //   }
  // }

  Future<dynamic> newGameModeApi(body, url) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).post(
      url,
      body,
      //  headers: headersWithToken,
    );

    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }

      return response.body;
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getPassBookData({
    required String userId,
    required bool isAll,
    required String limit,
    required String offset,
  }) async {
    //  AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
      "${ApiUtils.passBookApi}/?isAll=$isAll&limit=$limit&offset=$offset",
      headers: headersWithToken,
    );

    if (kDebugMode) {
      developer.log("RESPONSE HEADER:  ${response.request?.url}  RESPONSE HEADER:  ${response.request?.headers} RESPONSE : ${response.body}");
    }
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> bidHistoryByUserId({String? userId, String? gameType, String? winningStatus, List<int>? markets, String? date}) async {
    try {
      // AppUtils.showProgressDialog(isCancellable: false);
      await initApiService();
      print("fsdjfhdgsk");
      print(headersWithToken);
      final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
        ApiUtils.bidHistory,
        headers: headersWithToken,
        query: {
          "limit": "5000",
          "offset": "0",
          "bidType": gameType,
          "winningStatus": winningStatus,
          "markets": markets?.join(","),
          "date": date,
        },
      );
      if (kDebugMode) {
        developer.log("RESPONSE HEADER:  ${response.request?.url} RESPONSE : ${response.body} djhhs ${response.headers}");
      }
      if (response.status.hasError) {
        AppUtils.hideProgressDialog();
        return Future.error(response.statusText!);
      } else {
        AppUtils.hideProgressDialog();
        return response.body;
      }
    } catch (e) {}
  }

  // Future<dynamic> getNewMarketBidlistData({
  //   required String dailyMarketId,
  //   required String limit,
  //   required String offset,
  //   required String bidType,
  // }) async {
  //   await initApiService();
  //
  //   final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
  //     "${ApiUtils.marketBidNewLists}?dailyMarketId=$dailyMarketId&limit=$limit&offset=$offset&bidType=$bidType",
  //     //  "${ApiUtils.dailyStarlineMarketBidHistory}?id=$userId&limit=$limit&offset=$offset",
  //     headers: headersWithToken,
  //   );
  //   if (response.status.hasError) {
  //     if (response.status.code != null && response.status.code == 401) {
  //       tokenExpired();
  //     }
  //     AppUtils.hideProgressDialog();
  //
  //     return Future.error(response.statusText!);
  //   } else {
  //     AppUtils.hideProgressDialog();
  //     return response.body;
  //   }
  // }
  ///////// Notifications ///////////

  Future<dynamic> getNotificationCount() async {
    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
      ApiUtils.getNotificationCount,
      headers: headersWithToken,
    );
    if (response.status.hasError) {
      // if (response.status.code != null && response.status.code == 401) {
      //   tokenExpired();
      // }
      AppUtils.hideProgressDialog();
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getAllNotifications() async {
    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
      ApiUtils.getAllNotifications,
      headers: headersWithToken,
    );
    if (response.status.hasError) {
      // if (response.status.code != null && response.status.code == 401) {
      //   tokenExpired();
      // }
      AppUtils.hideProgressDialog();
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> resetNotification() async {
    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
      ApiUtils.resetNotificationCount,
      headers: headersWithToken,
    );
    if (kDebugMode) {
      developer
          .log("RESPONSE : ${response.body} RESPONSE REQUEST URI:  ${response.request?.url} RESPONSE REQUEST HEDER:  ${response.request?.headers}");
    }
    if (response.status.hasError) {
      // if (response.status.code != null && response.status.code == 401) {
      //   tokenExpired();
      // }
      AppUtils.hideProgressDialog();
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> rateApp(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.rateAppApi,
      body,
      headers: headersWithToken,
      // contentType: contentType,
    );

    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> marketNotifications(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await put(
      ApiUtils.marketNotification,
      body,
      headers: headersWithToken,
      // contentType: contentType,
    );

    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getBennerData() async {
    //   AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
      ApiUtils.bennerApi,
      headers: headersWithToken,
    );
    if (kDebugMode) {
      developer.log("RESPONSE : ${response.body} RESPONSE HEADER:  ${response.request?.url}");
    }
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getTickets() async {
    //   AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
      ApiUtils.getTickets,
      headers: headersWithToken,
    );
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> fcmToken(body) async {
    // AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();

    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.fcmToken,
      body,
      headers: headersWithToken,
    );
    if (kDebugMode) {
      developer.log("RESPONSE : ${response.body} RESPONSE HEADER:  ${response.request?.url} ${response.request?.headers}");
    }
    if (response.status.hasError) {
      //  AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return response.body;
    } else {
      return response.body;
    }
  }

  // Future<dynamic> appKilledStateApi() async {
  //   //AppUtils.showProgressDialog(isCancellable: false);
  //   await initApiService();
  //   final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
  //     ApiUtils.appKillApi,
  //     headers: headersWithToken,
  //   );
  //   if (response.status.hasError) {
  //     // AppUtils.hideProgressDialog();s
  //     return Future.error(response.statusText!);
  //   } else {
  //     // AppUtils.hideProgressDialog();
  //
  //     return response.body;
  //   }
  // }

  Future<dynamic> getAppVersion() async {
    await initApiService();
    final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
      ApiUtils.getVersion,
    );

    if (response.status.hasError) {
      return Future.error(response.statusText!);
    } else {
      return response.body;
    }
  }

  Future<dynamic> addFund({String? amount}) async {
    try {
      AppUtils.showProgressDialog(isCancellable: false);
      await initApiService();
      final response = await GetConnect(timeout: Duration(seconds: 20), allowAutoSignedCert: true).post(
        ApiUtils.addFund,
        {"amount": "$amount.00"},
        headers: headersWithToken,
      );
      if (kDebugMode) {
        developer.log(
            "RESPONSE HEADER: ${response.status.code} ${response.request?.url} RESPONSE : ${response.body} RESPONSE STATUS CODE:  ${headersWithToken} ");
      }
      if (response.status.hasError) {
        AppUtils.hideProgressDialog();
        if (response.status.code != null && response.status.code == 401) {
          tokenExpired();
        }
        return Future.error(response.statusText!);
      } else {
        AppUtils.hideProgressDialog();
        return response.body;
      }
    } catch (e) {
      AppUtils.hideProgressDialog();
    }
  }

  Future<dynamic> getPaymentStatus(paymentId) async {
    try {
      AppUtils.showProgressDialog(isCancellable: false);
      await initApiService();
      final response = await GetConnect(timeout: Duration(seconds: 20), allowAutoSignedCert: true).post(
        ApiUtils.paymentStatus,
        // {"paymentId": paymentId},
        {"paymentId": 25},
        headers: headersWithToken,
      );
      if (kDebugMode) {
        developer.log("RESPONSE HEADER:  ${response.request?.url} RESPONSE : ${response.body} RESPONSE STATUS CODE:  ${response.statusCode} ");
      }

      if (response.status.hasError) {
        AppUtils.hideProgressDialog();
        if (response.status.code != null && response.status.code == 401) {
          tokenExpired();
        }
        return Future.error(response.statusText!);
      } else {
        AppUtils.hideProgressDialog();
        return response.body;
      }
    } catch (e) {
      AppUtils.hideProgressDialog();
    }
  }

  Future<FundTransactionModel?> getTransactionHistory(limit, offset) async {
    try {
      await initApiService();
      final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).get(
        "${ApiUtils.getWalletTransactionHistory}/${GetStorage().read(ConstantsVariables.id)}?limit=${limit}&offset=${offset}",
        headers: headersWithToken,
      );
      print("Fsdkfjhsfkjhdskfh");
      print(headersWithToken);
      // print(FundTransactionModel.fromJson(response.body));
      if (kDebugMode) {
        developer.log("RESPONSE HEADER:  ${response.request?.url} RESPONSE : ${response.body} ");
      }

      print("Fsdlfjshfkjdh");
      print(response.body);
      if (response.status.hasError) {
        if (response.status.code != null && response.status.code == 401) {
          tokenExpired();
        }
        return Future.error(response.statusText!);
      } else {
        return FundTransactionModel.fromJson(response.body);
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<dynamic> getTransactionSuccess({int? transactionId}) async {
    try {
      await initApiService();
      final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true)
          .put(ApiUtils.putWalletTransactionStatus, {"id": transactionId}, headers: headersWithToken, query: {"search": ""});
      if (response.status.hasError) {
        if (response.status.code != null && response.status.code == 401) {
          tokenExpired();
        }
        return Future.error(response.statusText!);
      } else {
        return response.body;
      }
    } catch (e) {
      return null;
    }
  }

  Future<BankHistory?> getBankHistory() async {
    try {
      // AppUtils.showProgressDialog(isCancellable: false);
      await initApiService();
      final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).get(
        ApiUtils.getBankHistory,
        headers: headersWithToken,
        query: {"search": ""},
      );

      if (response.status.hasError) {
        AppUtils.hideProgressDialog();
        if (response.status.code != null && response.status.code == 401) {
          tokenExpired();
        }
        return Future.error(response.statusText!);
      } else {
        AppUtils.hideProgressDialog();
        return BankHistory.fromJson(response.body);
      }
    } catch (e) {
      AppUtils.hideProgressDialog();
      return null;
    }
  }

  Future<GetWithdrawalTiming?> getWithDrawalTime() async {
    try {
      await initApiService();
      final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).get(
        ApiUtils.getWithdrawal,
        headers: headersWithToken,
      );
      if (kDebugMode) {
        developer.log("RESPONSE HEADER url:  ${response.request?.url} RESPONSE : ${response.body} ");
      }
      if (response.status.hasError) {
        AppUtils.hideProgressDialog();
        if (response.status.code != null && response.status.code == 401) {
          tokenExpired();
        }
        return Future.error(response.statusText!);
      } else {
        AppUtils.hideProgressDialog();
        return GetWithdrawalTiming.fromJson(response.body);
      }
    } catch (e) {
      AppUtils.hideProgressDialog();
      return null;
    }
  }

  Future<TicketsModel?> getAllPackages() async {
    try {
      await initApiService();
      final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).get(
        ApiUtils.getAllPackages,
        headers: headersWithToken,
      );
      if (response.status.hasError) {
        if (response.status.code != null && response.status.code == 401) {
          tokenExpired();
        }
        return Future.error(response.statusText!);
      } else {
        return TicketsModel.fromJson(response.body);
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> getMarketsData({String? date}) async {
    try {
      await initApiService();
      final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true)
          .get(ApiUtils.getMarketsData, headers: headersWithToken, query: {
        "date": date,
      });
      if (response.status.hasError) {
        if (response.status.code != null && response.status.code == 401) {
          tokenExpired();
        }
        return Future.error(response.statusText!);
      } else {
        return response.body;
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> checkUserName({String? username}) async {
    try {
      AppUtils.showProgressDialog(isCancellable: false);
      await initApiService();
      final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).get(
        ApiUtils.checkUserName,
        query: {"username": username},
        headers: headersWithToken,
      );
      if (response.status.hasError) {
        AppUtils.hideProgressDialog();
        if (response.status.code != null && response.status.code == 401) {
          tokenExpired();
        }
        return Future.error(response.statusText!);
      } else {
        AppUtils.hideProgressDialog();
        return response.body;
      }
    } catch (e) {
      AppUtils.hideProgressDialog();
      return null;
    }
  }
}
