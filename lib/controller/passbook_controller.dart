import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../api_services/api_service.dart';
import '../helper_files/constant_variables.dart';
import '../helper_files/ui_utils.dart';
import '../models/commun_models/user_details_model.dart';
import '../models/passbook_page_model.dart';


class PassbookHistoryController extends GetxController {
  RxList<Rows> passBookModelData = <Rows>[].obs;
  RxList<Rows> passBookModelData2 = <Rows>[].obs;
  RxInt passbookCount = 0.obs;

  final int itemLimit = 30;
  RxInt offset = 1.obs;
  RxBool isLoad = false.obs;
  void getPassBookData({required bool lazyLoad, required String offset}) {
    UserDetailsModel userData = UserDetailsModel.fromJson(GetStorage().read(ConstantsVariables.userData));
    isLoad.value = true;
    ApiService()
        .getPassBookData(
      userId: userData.id.toString(),
      isAll: true,
      limit: itemLimit.toString(),
      offset: offset.toString(),
    )
        .then((value) async {
      if (value['status']) {
        isLoad.value = false;
        if (value['data'] != null) {
          PassbookModel model = PassbookModel.fromJson(value);
          passbookCount.value = int.parse(model.data!.count!.toString());
          passBookModelData.value = model.data?.rows ?? <Rows>[];
          passBookModelData.refresh();
        }
      } else {
        isLoad.value = false;
        AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      }
    });
  }

  int calculateTotalPages() {
    var passbookValue = (passbookCount.value / itemLimit).ceil();
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
      update();
    }
  }

  void prevPage() {
    if (offset.value > 1) {
      passBookModelData.clear();
      offset.value--;
      num = num - itemLimit;
      getPassBookData(lazyLoad: false, offset: num.toString());
      passBookModelData.refresh();
      update();
    }
  }
}
