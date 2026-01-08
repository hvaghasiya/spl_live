import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../api_services/api_service.dart';
import '../../../helper_files/constant_variables.dart';
import '../../../helper_files/ui_utils.dart';
import '../../../models/commun_models/user_details_model.dart';
import '../../../models/payment_transaction_model.dart';


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
