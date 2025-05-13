import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:spllive/api_services/api_service.dart';
import 'package:spllive/helper_files/constant_variables.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/models/commun_models/user_details_model.dart';
import 'package:spllive/models/payment_transaction_model.dart';

class TransactionHistoryPageController extends GetxController {
  Rx<PaymentTransactionModel> transactionModel = PaymentTransactionModel().obs;
  // RxList<ResultArr> transactionList = <ResultArr>[].obs;
  UserDetailsModel userDetailsModel = UserDetailsModel();
  int offset = 0;
  // Future<void> onSwipeRefresh() async {
  //   if (userDetailsModel.id != null) {
  //     getTransactionHistory(offset: offset);
  //   } else {
  //     AppUtils.showErrorSnackBar(
  //       bodyText: "SOMETHINGWENTWRONG".tr,
  //     );
  //   }
  // }

  fetchUserData() {
    final userData = GetStorage().read(ConstantsVariables.userData);
    userDetailsModel = UserDetailsModel.fromJson(userData);
    if (userDetailsModel.id != null) {
      getTransactionHistory();
    }
    // } else {
    //   AppUtils.showErrorSnackBar(
    //     bodyText: "SOMETHINGWENTWRONG".tr,
    //   );
    // }
  }

  void getTransactionHistory() async {
    ApiService()
        .getTransactionHistoryById(
      userId: "${userDetailsModel.id ?? 0}",
      offset: "$offset",
      limit: "5000",
    )
        .then(
      (value) async {
        if (value['status']) {
          transactionModel.value = PaymentTransactionModel.fromJson(value);
        } else {
          AppUtils.showErrorSnackBar(
            bodyText: value['message'] ?? "",
          );
        }
      },
    );
  }
}
