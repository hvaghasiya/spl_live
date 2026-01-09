import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:get/get.dart';

import '../../../Custom Controllers/wallet_controller.dart';
import '../../../components/DeviceInfo/device_info.dart';
import '../../../controller/home_controller.dart';
import '../../../controller/passbook_controller.dart';
import '../../../controller/starline_market_controller.dart';
import '../../../helper_files/app_colors.dart';
import '../../../helper_files/constant_image.dart';
import '../../../helper_files/custom_text_style.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  final homeCon = Get.put<HomeController>(HomeController());
  final walletCon = Get.put<WalletController>(WalletController());
  final starlineCon = Get.put<StarlineMarketController>(StarlineMarketController());
  final passbookCon = Get.put<PassbookHistoryController>(PassbookHistoryController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) async {
        if (value) {
          return;
        }
        if (homeCon.pageWidget.value == 1 || homeCon.pageWidget.value == 2 || homeCon.pageWidget.value == 3 || homeCon.pageWidget.value == 4) {
          print("OR VALUE: ${homeCon.pageWidget.value}");
          if (walletCon.selectedIndex.value != null) {
            walletCon.selectedIndex.value = null;
            print("OR VALUE: 1");
          } else {
            homeCon.pageWidget.value = 0;
            print("OR VALUE: 111");
          }
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft]);
        } else {
          print("OR VALUE: 12222");
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => onExitAlert(context, onCancel: () {
              Navigator.of(context).pop(false);
            }, onExit: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            }),
          );
        }
      },
      child: Scaffold(
        body: Obx(() => homeCon.getDashBoardPages(homeCon.pageWidget.value ?? 0)),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            backgroundColor: AppColors.bottomBarColor,
            showUnselectedLabels: true,
            unselectedItemColor: AppColors.black,
            elevation: 5,
            type: BottomNavigationBarType.fixed,
            currentIndex: homeCon.pageWidget.value,
            selectedItemColor: AppColors.appbarColor,
            unselectedLabelStyle: CustomTextStyle.textPTsansMedium.copyWith(fontSize: 14),
            selectedLabelStyle: CustomTextStyle.textPTsansMedium.copyWith(fontSize: 14),
            // onTap: (v) async {
            //   homeCon.pageWidget.value = v;
            //
            //   if (homeCon.pageWidget.value == 2) {
            //     walletCon.selectedIndex.value = null;
            //   }
            //   if (homeCon.pageWidget.value != 3) {
            //     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft]);
            //   }
            //   if (dialogShown.value == false) {
            //     FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
            //
            //     await remoteConfig.fetchAndActivate();
            //
            //     newAppVersion.value = remoteConfig.getString('AppVersion');
            //     print("gdfgdfgdfgdgdfgf");
            //     print(newAppVersion.value);
            //     newAppVersion.refresh();
            //   }
            // },
            onTap: (v) async {
              // CHAT TAB → OPEN FRESHWORKS
              if (v == 4) {
                Freshchat.showConversations();
                return;
              }

              homeCon.pageWidget.value = v;

              if (homeCon.pageWidget.value == 2) {
                walletCon.selectedIndex.value = null;
              }

              if (homeCon.pageWidget.value != 3) {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.landscapeLeft,
                ]);
              }

              if (dialogShown.value == false) {
                FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

                await remoteConfig.fetchAndActivate();

                newAppVersion.value = remoteConfig.getString('AppVersion');
                print("Remote App Version: ${newAppVersion.value}");
                newAppVersion.refresh();
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(bottom: 4),
                  child: SvgPicture.asset(
                    ConstantImage.homeIcon,
                    height: 15,
                    color: homeCon.pageWidget.value == 0 ? AppColors.appbarColor : AppColors.black,
                  ),
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(bottom: 4),
                  child: SvgPicture.asset(
                    ConstantImage.bidHistoryListIcon,
                    height: 15,
                    color: homeCon.pageWidget.value == 1 ? AppColors.appbarColor : AppColors.black,
                  ),
                ),
                label: "Bid History",
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(bottom: 4),
                  child: SvgPicture.asset(
                    ConstantImage.walletAppbar,
                    height: 15,
                    color: homeCon.pageWidget.value == 2 ? AppColors.appbarColor : AppColors.black,
                  ),
                ),
                label: "Wallet",
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(bottom: 4),
                  child: SvgPicture.asset(
                    ConstantImage.passBookIcon,
                    height: 15,
                    color: homeCon.pageWidget.value == 3 ? AppColors.appbarColor : AppColors.black,
                  ),
                ),
                label: "Passbook",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat,
                  size: 18,
                  color: homeCon.pageWidget.value == 4
                      ? AppColors.appbarColor
                      : AppColors.black,
                ),
                label: "Chat",
              ),
              // BottomNavigationBarItem(
              //   icon: Container(
              //     width: 20,
              //     height: 15,
              //     margin: EdgeInsets.only(bottom: 4),
              //     child: SvgPicture.asset(
              //       ConstantImage.moreIcon,
              //       width: 15,
              //       color: homeCon.pageWidget.value == 4 ? AppColors.appbarColor : AppColors.black,
              //     ),
              //   ),
              //   label: "More",
              // )
            ],
          ),
        ),
      ),
    );
  }

  onExitAlert(BuildContext context, {required Function() onExit, required Function() onCancel}) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: AlertDialog(
        title: Text(
          'Exit App',
          style: CustomTextStyle.textRobotoSansBold,
        ),
        content: Text('Are you sure you want to exit the app?', style: CustomTextStyle.textRobotoSansMedium),
        actions: [
          TextButton(
            onPressed: onCancel,
            child: Text(
              'Cancel',
              style: CustomTextStyle.textRobotoSansBold.copyWith(
                color: AppColors.appbarColor,
              ),
            ),
          ),
          TextButton(
            onPressed: onExit,
            child: Text(
              'Exit',
              style: CustomTextStyle.textRobotoSansBold.copyWith(
                color: AppColors.redColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
