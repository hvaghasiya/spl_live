import 'package:get/get.dart';

import '../controller/create_withdrawal_page_controller.dart';


class CreateWithDrawalPageBiding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateWithDrawalPageController());
  }
}
