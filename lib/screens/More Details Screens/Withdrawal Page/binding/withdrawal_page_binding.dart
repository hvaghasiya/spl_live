import 'package:get/get.dart';

import '../controller/withdrawal_page_controller.dart';


class WithdrawalPageBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WithdrawalPageController());
  }
}
