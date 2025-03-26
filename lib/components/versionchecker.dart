import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'DeviceInfo/device_info.dart';

class VersionCheckObserver extends NavigatorObserver {
  RxBool _dialogShown = false.obs;
  void _printNavigationStack(NavigatorState? navigator) {
    if (navigator == null) return;

    final stack = navigator.widget.pages.map((page) => page.name).toList();
    print("Current Navigation Stack: $stack");
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _checkForUpdate(route.navigator?.context);
  }

  void _checkForUpdate(BuildContext? context) async {
    if (dialogShown.value == false) {
      FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

      await remoteConfig.fetchAndActivate();

      newAppVersion.value = remoteConfig.getString('AppVersion');
      print("gdfgdfgdfgdgdfgf");
      print(newAppVersion.value);
      newAppVersion.refresh();
    }
  }
}
