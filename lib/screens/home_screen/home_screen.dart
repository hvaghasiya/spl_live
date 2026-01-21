import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../Custom Controllers/wallet_controller.dart';
import '../../components/bottumnavigation/bottumnavigation.dart';
import '../../helper_files/app_colors.dart';
import '../../helper_files/custom_text_style.dart';
import 'controller/homepage_controller.dart';
import 'utils/home_screen_utils.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  final controller = Get.put<HomePageController>(HomePageController());
  final walletController = Get.put<WalletController>(WalletController());

  @override
  void initState() {
    super.initState();
    controller.setboolData();
    controller.getNotificationCount();
    controller.getNotificationsData();
    controller.callMarketsApi();
    controller.getUserData();
    controller.getUserBalance();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          bottomNavigationBar: Obx(
                () => MyNavigationBar(
              currentIndex: controller.currentIndex.value,
              onTapBidHistory: () {
                controller.pageWidget.value = 1;
                controller.currentIndex.value = 1;
                walletController.selectedIndex.value = null;
                controller.marketBidsByUserId(lazyLoad: false);
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.landscapeLeft
                ]);
                // controller.getUserBalance();
              },
              onTapHome: () {
                controller.pageWidget.value = 0;
                controller.currentIndex.value = 0;
                walletController.selectedIndex.value = null;
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.landscapeLeft
                ]);
                // controller.getUserBalance();
              },
              onTapWallet: () {
                controller.pageWidget.value = 2;
                controller.currentIndex.value = 2;
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.landscapeLeft
                ]);
                walletController.walletBalance.refresh();
                controller.getUserBalance();
                walletController.walletBalance.refresh();
              },
              onTapPassbook: () {
                walletController.selectedIndex.value = null;
                controller.getPassBookData(
                    lazyLoad: false, offset: controller.offset.value.toString());
                controller.pageWidget.value = 3;
                controller.currentIndex.value = 3;
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.landscapeLeft
                ]);
              },
              onTapChat: () {
                controller.pageWidget.value = 4;
                controller.currentIndex.value = 4;
                walletController.selectedIndex.value = null;
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.landscapeLeft
                ]);
              }, onTapMore: () {
                controller.pageWidget.value = 5;
                controller.currentIndex.value = 5;
                walletController.selectedIndex.value = null;
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.landscapeLeft
                ]);}
            ),
          ),
          backgroundColor: AppColors.white,
          body: RefreshIndicator(
            onRefresh: () async {
              if (controller.pageWidget.value == 0) {
                controller.handleRefresh();
                walletController.walletBalance.refresh();
              }
            },
            child: Obx(
                  () => controller.getDashBoardPages(
                controller.pageWidget.value,
                size,
                context,
                notifictionCount:
                controller.getNotifiactionCount.value.toString(),
              ),
            ),
          ),
        ),
        Obx(
              () => controller.getNotifiactionCount.value > 0
              ? HomeScreenUtils().notificationAbout(context)
              : Container(),
        )
      ],
    );
  }

  Padding onExitAlert(BuildContext context,
      {required Function() onExit, required Function() onCancel}) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: AlertDialog(
        title: Text(
          'Exit App',
          style: CustomTextStyle.textRobotoSansBold,
        ),
        content: Text('Are you sure you want to exit the app?',
            style: CustomTextStyle.textRobotoSansMedium),
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