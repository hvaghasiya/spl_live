import 'package:get/get.dart';

class DoubleTapExitController extends GetxController {
  DateTime? _lastTapTime;

  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (_lastTapTime == null ||
        now.difference(_lastTapTime!) > const Duration(seconds: 2)) {
      _lastTapTime = now;
      Get.back();
      return false;
    } else {
      return true;
    }
  }
}
