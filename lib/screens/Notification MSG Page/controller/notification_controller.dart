import 'package:get/get.dart';

import '../../../api_services/api_service.dart';
import '../../../helper_files/ui_utils.dart';
import '../../../models/notifiaction_models/get_all_notification_model.dart';
import '../../../models/notifiaction_models/notification_count_model.dart';

class NotificationController extends GetxController {
  RxList<NotificationData> notificationData = <NotificationData>[].obs;
  RxString getNotifiactionCount = "".obs;

  @override
  void onInit() {
    resetNotificationCount();
    getNotificationsData();
    super.onInit();
  }

  @override
  void onClose() {
    getNotifiactionCount.refresh();
    super.onClose();
  }

  void getNotificationsData() async {
    ApiService().getAllNotifications().then((value) async {
      if (value['status']) {
        GetAllNotificationsData model = GetAllNotificationsData.fromJson(value);
        notificationData.value = model.data!.rows as List<NotificationData>;
        if (model.message!.isNotEmpty) {
          // AppUtils.showSuccessSnackBar(
          //     bodyText: model.message, headerText: "SUCCESSMESSAGE".tr);
        }
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  void resetNotificationCount() async {
    ApiService().resetNotification().then((value) async {
      if (value['status']) {
        NotifiactionCountModel model = NotifiactionCountModel.fromJson(value);
        getNotifiactionCount.value = model.data!.notificationCount.toString();
        if (model.message!.isNotEmpty) {
          // AppUtils.showSuccessSnackBar(
          //     bodyText: model.message, headerText: "SUCCESSMESSAGE".tr);
        }
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }
}
