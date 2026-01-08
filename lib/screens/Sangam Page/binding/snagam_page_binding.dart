import 'package:get/get.dart';

import '../controller/sangam_page_controller.dart';


class SangamPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SangamPageController());
  }
}
