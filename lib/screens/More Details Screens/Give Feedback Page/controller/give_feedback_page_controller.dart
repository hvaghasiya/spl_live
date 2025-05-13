import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:spllive/helper_files/ui_utils.dart';

import '../../../../api_services/api_service.dart';
import '../../../../helper_files/constant_variables.dart';
import '../../../../models/commun_models/user_details_model.dart';
import '../../../../models/get_feedback_by_id_api_response_model.dart';

class GiveFeedbackPageController extends GetxController {
  final feedbackController = TextEditingController();
  var feedbackModel = GetFeedbackByIdApiResponseModel().obs;
  UserDetailsModel userDetailsModel = UserDetailsModel();

  RxBool isGiveFeedback = false.obs;

  @override
  void onInit() {
    super.onInit();
    getArguments();
  }

  void addFeedbackApi(ratingValue) async {
    isGiveFeedback.value = true;
    ApiService().createFeedback(await createFeedbackBody(ratingValue)).then((value) async {
      if (value['status']) {
        isGiveFeedback.value = false;
        feedbackController.clear();
        // Get.back();
        AppUtils.showSuccessSnackBar(bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
      } else {
        AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      }
    });
  }

  // UserDetailsModel userData = UserDetailsModel();
  // Future<void> getUserData() async {
  //   var data = GetStorage().read(ConstantsVariables.userData);
  //   userData = UserDetailsModel.fromJson(data);
  //   // getMarketBidsByUserId(lazyLoad: false);
  // }

  // Future<Map> createFeedbackBody(rating, String? feedBack) async {
  //   final createFeedbackBody = {
  //     "userId": userDetailsModel.id,
  //     "feedback": feedBack,
  //     "rating": 4,
  //   };
  //   debugPrint(createFeedbackBody.toString());
  //   return createFeedbackBody;
  // }
  // void addFeedbackApi() async {
  //   ApiService().createFeedback(await createFeedbackBody()).then((value) async {
  //     debugPrint("Create Feedback Api Response :- $value");
  //     if (value['status']) {
  //       Get.back();
  //       AppUtils.showSuccessSnackBar(
  //           bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
  //     } else {
  //       AppUtils.showErrorSnackBar(
  //         bodyText: value['message'] ?? "",
  //       );
  //     }
  //   });
  // }

  getArguments() async {
    var data = GetStorage().read(ConstantsVariables.userData);
    userDetailsModel = UserDetailsModel.fromJson(data);

    // getFeedbackAndRatingsById();
  }

  Future<Map> createFeedbackBody(ratingValue) async {
    final createFeedbackBody = {
      "userId": int.parse(userDetailsModel.id.toString()),
      "feedback": feedbackController.text,
      "rating": ratingValue
    };
    return createFeedbackBody;
  }

  void getFeedbackAndRatingsById() async {
    ApiService()
        //.getFeedbackAndRatingsById(userId: int.parse(userId))
        .getFeedbackAndRatingsById(userId: userDetailsModel.id)
        .then(
      (value) async {
        if (value['status']) {
          feedbackModel.value = GetFeedbackByIdApiResponseModel.fromJson(value);
          feedbackController.text = feedbackModel.value.data!.feedback ?? "";
        } else {
          AppUtils.showErrorSnackBar(
            bodyText: value['message'] ?? "",
          );
        }
      },
    );
  }
}
