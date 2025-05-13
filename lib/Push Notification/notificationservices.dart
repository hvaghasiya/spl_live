import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      provisional: true,
      criticalAlert: true,
      badge: true,
      carPlay: true,
      sound: true,
    );
    await messaging.getNotificationSettings().then((settings) {
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        print("Notifications are disabled");
      }
    });
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("user Granted Permission");
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print("user Granted Provisinal Permission");
    } else {
      // openAppSettings();
      // openAppSettings();
      print("user Denied Permission");
    }
  }

  void initialLocalNotification(BuildContext context, RemoteMessage msg) async {
    var androidInitializationSettings = const AndroidInitializationSettings("@mipmap/ic_launcher");
    // var iosInitializationSettings = const IOSInitializationSettings();
    var initializationSetting = InitializationSettings(
      android: androidInitializationSettings,
      // iOS: iosInitializationSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
      return hendleMessege(context, msg);
    });
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (Platform.isAndroid) {
        initialLocalNotification(context, message);
        showNotification(message);
      } else {
        showNotification(message);
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel chennel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      "Hello Importance Notification",
      description: "YOur Chennel Discription",
      importance: Importance.max,
      showBadge: true,
    );
    // AndroidNotificationDetails androidNotificationDetails =
    //     AndroidNotificationDetails(
    //   chennel.id.toString(),
    //   chennel.name.toString(),
    //   channelDescription: chennel.description.toString(),
    //   importance: Importance.high,
    //   priority: Priority.high,
    //   icon: "@mipmap/ic_launcher",
    //   ticker: 'ticker',
    // );
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      chennel.id.toString(),
      chennel.name.toString(),
      channelDescription: chennel.description.toString(),
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: const BigTextStyleInformation(''),
      icon: "@mipmap/ic_launcher",
      largeIcon: const DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
      ticker: 'ticker',
      playSound: true,
      enableLights: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 100, 200, 300]),
      color: Colors.blue,
      ledColor: Colors.red,
      ledOnMs: 1000,
      ledOffMs: 500,
    );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      //  iOS: iosNotificationDetails,
    );
    print(message.notification?.title);
    print(message.notification?.body);
    print("fksdjfhsd");

    _flutterLocalNotificationsPlugin.show(
        1, "${message.notification?.title ?? ""}", message.notification?.body ?? "", notificationDetails);
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    print("dajkhdaskd");
    print(token);
    return token!;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }

  void hendleMessege(BuildContext context, RemoteMessage msg) {
    if (msg.data['send'] == 'msg') {
      launchUrl(
        Uri.parse("${msg.data['url']}"),
      );
    }
  }

////When App is In terminated
  Future<void> setuoIntrectMessege(BuildContext context) async {
    RemoteMessage? initialMessege = await FirebaseMessaging.instance.getInitialMessage();
    // var conrroller = Get.put(InactivityController());
    if (initialMessege != null) {
      // ignore: use_build_context_synchronously
      hendleMessege(context, initialMessege);
      // conrroller.appKilledStateApi();
    }
    // When app Is in Background/////
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      hendleMessege(context, event);
    });
  }
}
