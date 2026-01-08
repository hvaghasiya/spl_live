import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import 'Push Notification/notificationservices.dart';
import 'components/DeviceInfo/device_info.dart';
import 'components/updatedialougue.dart';
import 'components/versionchecker.dart';
import 'firebase_options.dart';
import 'helper_files/app_colors.dart';
import 'helper_files/constant_variables.dart';
import 'localization/app_localization.dart';
import 'routes/app_routes.dart';
import 'routes/app_routes_name.dart';
import 'screens/initial_bindings.dart';
import 'self_closing_page.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessegingBackgroundHendler(RemoteMessage msg) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Permission.notification.request();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Freshchat.init(
    "fea6f54d-1556-49ad-9365-0dbe3649df17",
    "7fa82d26-7cf0-41cb-bd99-cb120f18d25d",
    "msdk.in.freshchat.com",
  );


  FirebaseMessaging.onBackgroundMessage(_firebaseMessegingBackgroundHendler);
  try {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 10),
      minimumFetchInterval: const Duration(minutes: 10),
    ));
    await remoteConfig.fetchAndActivate();
  } on FirebaseException catch (e) {
    print('Firebase Error: ${e.code} - ${e.message}');
  } catch (e) {
    print('Unexpected error: $e');
  }
  await GetStorage.init();
  final appStateListener = AppStateListener();
  WidgetsBinding.instance.addObserver(appStateListener);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: AppColors.appBlueDarkColor,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(GlobalWrapper(child: const MyApp()));
}

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final con = Get.put<InactivityController>(InactivityController());
  bool _jailbroken = false;
  StreamSubscription? subscription;

  getAppVersion() async {
    FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

    subscription = remoteConfig.onConfigUpdated.listen((event) async {
      print(event.updatedKeys);
      print("Fsfkjdhsfskjfh");
      await remoteConfig.fetchAndActivate();
      newAppVersion.value = remoteConfig.getString('AppVersion');
      print(newAppVersion.value);
      newAppVersion.refresh();
    });

    await remoteConfig.fetchAndActivate();
    newAppVersion.value = remoteConfig.getString('AppVersion');
    print("fgsdkjhsfkjshdf");
    print(newAppVersion.value);
    newAppVersion.refresh();
  }

  @override
  void initState() {
    super.initState();
    getAppVersion();
    NotificationServices().requestNotificationPermission();
    HttpOverrides.global = MyHttpOverrides();
    NotificationServices().firebaseInit(context);
    NotificationServices().setuoIntrectMessege(context);
    NotificationServices().getDeviceToken().then(
        (value) => GetStorage().write(ConstantsVariables.fcmToken, value));
    print(
        "ConstantsVariables.fcmTokenConstantsVariables.fcmToken ${GetStorage().read(ConstantsVariables.fcmToken)}");
    //   initPlatformState();
  }

  // Future<void> initPlatformState() async {
  //   bool jailbroken;
  //   try {
  //     jailbroken = await FlutterJailbreakDetection.jailbroken;
  //   } on PlatformException {
  //     jailbroken = true;
  //   }
  //   if (!mounted) return;
  //   setState(() {
  //     _jailbroken = jailbroken;
  //     if (_jailbroken) {
  //       SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: AppColors.appBlueDarkColor,
    //   statusBarBrightness: Brightness.dark,
    //   statusBarIconBrightness: Brightness.light,
    //   systemNavigationBarIconBrightness: Brightness.dark,
    // ));
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        return RawKeyboardListener(
          autofocus: true,
          focusNode: FocusNode(),
          onKey: (e) => con.resetInactivityTimer(),
          child: Listener(
            onPointerSignal: con.userLogIn,
            onPointerDown: con.userLogIn,
            onPointerMove: con.userLogIn,
            onPointerUp: con.userLogIn,
            onPointerHover: con.userLogIn,
            onPointerPanZoomStart: con.userLogIn,
            onPointerPanZoomUpdate: con.userLogIn,
            child: SafeArea(
              bottom: true,
              child: GetMaterialApp(
                navigatorObservers: [VersionCheckObserver()],
                title: 'SPL app',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  scaffoldBackgroundColor: AppColors.white,

                  // dialogTheme: DialogTheme(surfaceTintColor: AppColors.white),
                  appBarTheme: AppBarTheme(
                    iconTheme: IconThemeData(color: AppColors.white),
                    scrolledUnderElevation: 0,
                  ),
                ),

                defaultTransition: Transition.fadeIn,
                debugShowCheckedModeBanner: false,
                navigatorKey: navigatorKey,
                // transitionDuration: const Duration(milliseconds: 500),
                translations: AppLocalization(),
                locale: getLocale(),
                initialBinding: InitialBindings(),
                initialRoute: AppRoutName.splashScreen,
                getPages: AppRoutes.pages,
              ),
            ),
          ),
        );
      },
    );
  }

  Locale getLocale() {
    final storedLocale = GetStorage().read(ConstantsVariables.languageName);
    var locale = const Locale('en', 'US');
    switch (storedLocale) {
      case ConstantsVariables.localeEnglish:
        locale = const Locale('en', 'US');
        break;
      case ConstantsVariables.localeHindi:
        locale = const Locale('hi', 'IN');
        break;
      default:
        locale = const Locale('en', 'US');
    }
    return locale;
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class AppStateListener extends WidgetsBindingObserver {
  final con = Get.put<InactivityController>(InactivityController());

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        bool alreadyLoggedIn = con.getStoredUserData();
        var mPinTimeOut =
            GetStorage().read(ConstantsVariables.mPinTimeOut) ?? true;
        if (alreadyLoggedIn && !mPinTimeOut) {
          GetStorage().write(ConstantsVariables.timeOut, true);
        } else {
          GetStorage().write(ConstantsVariables.timeOut, false);
        }
        break;
      case AppLifecycleState.inactive:
        GetStorage().write(ConstantsVariables.timeOut, false);
        break;
      case AppLifecycleState.paused:
        GetStorage().write(ConstantsVariables.timeOut, false);

        break;
      case AppLifecycleState.detached:
        GetStorage().write(ConstantsVariables.timeOut, false);
        break;
      case AppLifecycleState.hidden:
        GetStorage().write(ConstantsVariables.timeOut, false);
        break;
    }
  }
}

class GlobalWrapper extends StatelessWidget {
  final Widget child;

  const GlobalWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          child,
          Obx(() {
            print(newAppVersion.value);
            print(appVersion.value);
            print("sffjkhfkjfhdksfsdf");
            return newAppVersion.value.isNotEmpty &&
                    appVersion.isNotEmpty &&
                    newAppVersion.value != appVersion.value
                ? UpdateDialog()
                : SizedBox();
          }),
        ],
      ),
    );
  }
}
