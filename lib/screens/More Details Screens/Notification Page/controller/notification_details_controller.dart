import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../api_services/api_service.dart';
import '../../../../helper_files/constant_variables.dart';
import '../../../../helper_files/ui_utils.dart';

class NotificationDetailsPageController extends GetxController {
  // RxBool marketNotification = true.obs;
  // RxBool starlineNotification = true.obs;
  RxBool marketNotificationFromLocal = true.obs;
  RxBool starlineNotificationFromLocal = true.obs;

  @override
  void onInit() async {
    marketNotificationFromLocal.value = GetStorage().read(ConstantsVariables.marketNotification);
    starlineNotificationFromLocal.value = GetStorage().read(ConstantsVariables.starlineNotification);
    if (marketNotificationFromLocal.value == null) {
      GetStorage().write(ConstantsVariables.marketNotification, true);
      GetStorage().write(ConstantsVariables.starlineNotification, true);
      callNotification();
    }
    super.onInit();
  }

  void callNotification() async {
    ApiService().marketNotifications(await marketBody()).then((value) async {
      if (value['status']) {
        GetStorage().write(ConstantsVariables.marketNotification, marketNotificationFromLocal.value);
        GetStorage().write(ConstantsVariables.starlineNotification, starlineNotificationFromLocal.value);

        // AppUtils.showSuccessSnackBar(
        //     bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  marketBody() {
    var data = {
      "isMarketNotification": "$marketNotificationFromLocal",
      "isStarlineMarketNotification": "$starlineNotificationFromLocal"
    };
    return data;
  }
}
