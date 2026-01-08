import 'package:get/get.dart';

import '../controller/new_gamemode_page_controller.dart';


class NewGamemodePageBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewGamemodePageController());
  }
}
