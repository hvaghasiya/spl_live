import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:share_plus/share_plus.dart';

import '../../../api_services/api_service.dart';
import '../../../helper_files/app_colors.dart';
import '../../../helper_files/constant_image.dart';
import '../../../helper_files/constant_variables.dart';
import '../../../helper_files/custom_text_style.dart';
import '../../../helper_files/ui_utils.dart';
import '../../../models/commun_models/user_details_model.dart';
import '../../../models/get_feedback_by_id_api_response_model.dart';
import '../../../routes/app_routes_name.dart';
import '../../../self_closing_page.dart';

class MoreListController extends GetxController {
  UserDetailsModel userData = UserDetailsModel();
  // RxList<ResultArr> marketHistoryList = <ResultArr>[].obs;
  // RxList<MarketBidHistoryList> marketBidHistoryList = <MarketBidHistoryList>[].obs;
  RxBool isStarline = false.obs;
  int offset = 0;
  RxString walletBalance = "00".obs;
  double ratingValue = 0.00;
  RxBool isSharing = false.obs;
  DateTime startEndDate = DateTime.now();
  final con = Get.find<InactivityController>();

  @override
  void onInit() {
    getUserData();
    walletBalance.refresh();
    getUserBalance();
    walletBalance.refresh();
    super.onInit();
  }

  Future<void> getUserData() async {
    userData = UserDetailsModel.fromJson(GetStorage().read(ConstantsVariables.userData));
    // getMarketBidsByUserId(lazyLoad: false);
  }

  void callLogout() async {
    ApiService().logout().then((value) async {
      if (value['status']) {
        // AppUtils.showSuccessSnackBar(bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
        // ApiUtils().inactivityTimer?.cancel();
        con.inactivityTimer?.cancel();
        GetStorage().erase();
        Get.offAllNamed(AppRoutName.walcomeScreen);
        Get.defaultDialog(
          title: "",
          titleStyle: const TextStyle(fontSize: 0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                ConstantImage.logOutDialog,
                height: 60,
              ),
              // Icon(
              //   Icons.thumb_up_alt_outlined,
              //   size: 60,
              //   color: AppColors.appbarColor,
              // ),
              const SizedBox(height: 10),
              Text(
                value['message'] ?? "Logout Successful",
                textAlign: TextAlign.center,
                style: CustomTextStyle.textRamblaBold.copyWith(
                  color: AppColors.appbarColor,
                  fontSize: 26,
                ),
              ),
            ],
          ),
        );
      } else {
        AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      }
    });
  }

  void getUserBalance() {
    ApiService().getBalance().then((value) async {
      if (value['status']) {
        if (value['data'] != null) {
          var tempBalance = value['data']['Amount'] ?? 00;
          walletBalance.value = tempBalance.toString();
        }
      } else {
        AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      }
    });
  }

  // Rate Controller
  var tempRatings = 0.00;
  String tempFeedBack = "";
  Future<void> getFeedbackAndRatingsById() async {
    ApiService().getFeedbackAndRatingsById(userId: userData.id).then(
      (value) async {
        if (value['status']) {
          var feedbackModel = GetFeedbackByIdApiResponseModel.fromJson(value);
          if (feedbackModel.data != null) {
            tempRatings =
                feedbackModel.data!.user!.appRating != null ? feedbackModel.data!.user!.appRating.toDouble() : 0.00;
            tempFeedBack = feedbackModel.data!.feedback.toString();
          } else {
            tempRatings = 0.00;
          }
        } else {
          AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
        }
        if (tempRatings > 0.00) {
          AppUtils().showRateUsBoxDailog((rat) => addRating(rat), tempRatings);
        } else {
          AppUtils().showRateUsBoxDailog((rat) => addRating(rat), 0);
        }
      },
    );
  }

  Future<Map> createRatingBody(rating) async {
    final createFeedbackBody = {
      "userId": userData.id,
      "rating": rating,
    };
    return createFeedbackBody;
  }

  void addRating(ratingValue) async {
    ApiService().rateApp(await createRatingBody(ratingValue)).then((value) async {
      if (value['status']) {
        Get.back();
        AppUtils.showSuccessSnackBar(bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
      } else {
        AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      }
    });
  }

  void toggleShare() {
    isSharing.value = !isSharing.value;
    if (isSharing.value) {
      Share.share("http://spl.live");
    }
  }
}
