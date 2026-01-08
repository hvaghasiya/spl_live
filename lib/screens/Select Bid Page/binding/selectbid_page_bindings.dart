import 'package:get/get.dart';

import '../controller/selectbid_page_controller.dart';


class SelecteBidPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SelectBidPageController());
  }
}
