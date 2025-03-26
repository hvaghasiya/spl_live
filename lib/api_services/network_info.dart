import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../helper_files/ui_utils.dart';

abstract class NetworkInfo {
  static Future<bool> checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult.isNotEmpty) {
      if (connectivityResult[0] == ConnectivityResult.mobile) {
        Get.closeAllSnackbars();
        return true;
      } else if (connectivityResult[0] == ConnectivityResult.wifi) {
        Get.closeAllSnackbars();
        return true;
      } else {
        if (connectivityResult[0] == ConnectivityResult.none) {
          AppUtils.hideProgressDialog();
          AppUtils.showErrorSnackBar(bodyText: "No internet connection!");
          // checkNetwork();
          return false;
        } else {
          return true;
        }
      }
    } else {
      return false;
    }
  }
}
