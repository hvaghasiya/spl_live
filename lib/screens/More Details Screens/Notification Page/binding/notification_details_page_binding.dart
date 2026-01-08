import 'package:get/get.dart';

import '../controller/notification_details_controller.dart';


class NotificationDetailsPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationDetailsPageController());
  }
}
