import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:spllive/models/commun_models/withdrawal_request_model.dart';

import '../../../../Custom Controllers/wallet_controller.dart';
import '../../../../api_services/api_service.dart';
import '../../../../helper_files/app_colors.dart';
import '../../../../helper_files/constant_variables.dart';
import '../../../../helper_files/ui_utils.dart';
import '../../../../models/commun_models/user_details_model.dart';

class CheckWithdrawalPageController extends GetxController {
  RxList<WithdrawalRequestList> withdrawalRequestList = <WithdrawalRequestList>[].obs;
  UserDetailsModel userData = UserDetailsModel();
  int? userId = 0;
  RxBool isloading = false.obs;
  var walletController = Get.put(WalletController());

  Future<void> getUserData() async {
    final data = GetStorage().read(ConstantsVariables.userData);
    userData = UserDetailsModel.fromJson(data);
    userId = userData.id;
    walletController.walletBalance.refresh();
    getWithdrawalHistoryByUserId(lazyLoad: false);
  }

  void getWithdrawalHistoryByUserId({required bool lazyLoad}) async {
    isloading.value = true;
    await ApiService().getWithdrawalHistoryByUserId(userId: userId).then(
      (value) async {
        if (value['status']) {
          isloading.value = false;
          if (value['data'] != null) {
            WithdrawalRequestResponseModel model = WithdrawalRequestResponseModel.fromJson(value);
            lazyLoad
                ? withdrawalRequestList.addAll(model.data ?? <WithdrawalRequestList>[])
                : withdrawalRequestList.value = model.data ?? <WithdrawalRequestList>[];
          }
        } else {
          isloading.value = false;
          AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
        }
      },
    );
  }

  checkColor(i) {
    if (withdrawalRequestList[i].status == "Pending") {
      return AppColors.appbarColor;
    } else if (withdrawalRequestList[i].status == "Rejected") {
      return AppColors.redColor;
    } else {
      return AppColors.greenShade;
    }
  }
}
