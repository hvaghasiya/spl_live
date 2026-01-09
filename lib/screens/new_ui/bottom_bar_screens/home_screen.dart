import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Custom Controllers/wallet_controller.dart';
import '../../../components/DeviceInfo/device_info.dart';
import '../../../controller/home_controller.dart';
import '../../../helper_files/app_colors.dart';
import '../../../helper_files/constant_image.dart';
import '../../../helper_files/constant_variables.dart';
import '../../../helper_files/custom_text_style.dart';
import '../../../helper_files/dimentions.dart';
import '../../../routes/app_routes_name.dart';
import '../../bottum_navigation_screens/controller/bottum_navigation_controller.dart';
import 'home_screens/normal_markets.dart';
import 'starline market/starline_markets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeCon = Get.find<HomeController>();
  final walletCon = Get.find<WalletController>();
  final moreCon = Get.put(MoreListController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    print(GetStorage().read(ConstantsVariables.authToken));
    GetStorage().write(ConstantsVariables.timeOut, true);
    walletCon.getUserBalance();
    homeCon.getBannerData();
    homeCon.getDailyMarkets();
    homeCon.getNotificationCountData();
    homeCon.getNotificationsData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        homeCon.getBannerData();
        homeCon.getDailyMarkets();
        homeCon.getNotificationCountData();
        homeCon.getNotificationsData();
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        drawer: Drawer(
          backgroundColor: AppColors.white,
          width: Get.width * 0.75,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 50, bottom: 20),
                color: AppColors.appbarColor,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: Dimensions.w20),
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            color: AppColors.appbarColor,
                            size: 50,
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                moreCon.userData.userName ?? "User Name",
                                style: CustomTextStyle.textRobotoSansMedium
                                    .copyWith(
                                  fontSize: Dimensions.h16,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                moreCon.userData.phoneNumber ?? "",
                                style: CustomTextStyle.textRobotoSansMedium
                                    .copyWith(
                                  fontSize: Dimensions.h14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      drawerListItem(
                        onTap: () {
                          Get.back();
                          Get.toNamed(AppRoutName.profilePage);
                        },
                        iconData: ConstantImage.bankAccountNew,
                        text: "Change Password".tr,
                      ),
                      drawerListItem(
                        onTap: () {
                          Get.back();
                          homeCon.pageWidget.value = 2;
                          walletCon.selectedIndex.value = null;
                        },
                        iconData: ConstantImage.walletAppbar,
                        text: "Wallet".tr,
                      ),
                      drawerListItem(
                        onTap: () {
                          Get.back();
                          homeCon.pageWidget.value = 1;
                        },
                        iconData: ConstantImage.clockIcon,
                        text: "Bid History".tr,
                      ),
                      drawerListItem(
                        onTap: () {
                          Get.back();
                          homeCon.pageWidget.value = 2;
                          walletCon.selectedIndex.value = 2;
                        },
                        iconData: ConstantImage.addBankDeatils,
                        text: "Add Bank Details",
                      ),
                      drawerListItem(
                        onTap: () {
                          Get.back();
                          homeCon.pageWidget.value = 2;
                          walletCon.selectedIndex.value = 0;
                        },
                        iconData: ConstantImage.plusIcon,
                        text: "ADDFUND".tr,
                      ),
                      drawerListItem(
                        onTap: () {
                          Get.back();
                          Get.toNamed(AppRoutName.gameRatePage);
                        },
                        iconData: ConstantImage.gameRate,
                        text: "GAMERATE".tr,
                      ),
                      drawerListItem(
                        onTap: () {
                          Get.back();
                          Get.toNamed(AppRoutName.notificationDetailsPage);
                        },
                        iconData: ConstantImage.notifiacation,
                        text: "NOTIFICATIONS".tr,
                      ),
                      drawerListItem(
                        onTap: () {
                          Get.back();
                          Get.toNamed(AppRoutName.feedBackPage);
                        },
                        iconData: ConstantImage.giveFeedbackIcon,
                        text: "GIVEFEEDBACK".tr,
                      ),

                      drawerListIconItem(
                        onTap: () {
                          Get.back();
                          launch("https://t.me/satta_matka_kalyan_bazar_milan");
                        },
                        icon: Icons.send,
                        text: "Join Telegram",
                        isRotated: true,
                      ),
                      drawerListIconItem(
                        onTap: () {
                          Get.back();
                          Share.share("https://spl.live");
                        },
                        icon: Icons.share,
                        text: "Share App",
                      ),
                      // -----------------------------------

                      // drawerListItem(
                      //   onTap: () {
                      //     Get.back();
                      //     Freshchat.showConversations();
                      //   },
                      //   iconData: ConstantImage.giveFeedbackIcon,
                      //   text: "CHAT / SUPPORT",
                      // ),
                      drawerListItem(
                        onTap: () {
                          Get.back();
                          moreCon.callLogout();
                        },
                        iconData: ConstantImage.logoutNew,
                        text: "Log Out",
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "Version: ${appVersion.value}",
                  textAlign: TextAlign.center,
                  style: CustomTextStyle.textRobotoSansMedium.copyWith(
                      fontSize: Dimensions.h14,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: AppColors.appbarColor,
          title: Text("SPL",
              style: CustomTextStyle.textRamblaMedium.copyWith(
                  color: Colors.white,
                  fontSize: Dimensions.h20,
                  fontWeight: FontWeight.w700)),
          centerTitle: true,

          leadingWidth: Dimensions.w50,
          leading: InkWell(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                Icons.menu,
                color: AppColors.white,
                size: 24,
              ),
            ),
          ),

          actions: [


            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: Dimensions.w18,
                  child: SvgPicture.asset(
                    ConstantImage.walletAppbar,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(width: 5),
                Obx(
                      () => Container(
                    constraints: BoxConstraints(maxWidth: 100),
                    child: Text(
                      walletCon.walletBalance.toString(),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyle.textRobotoMedium.copyWith(
                        color: AppColors.white,
                        fontSize: Dimensions.h14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 5),

            Obx(
                  () => homeCon.notificationCount.value == null ||
                  homeCon.notificationCount.value == 0
                  ? Padding(
                padding: const EdgeInsets.only(right: 12),
                child: InkWell(
                  onTap: () => Get.toNamed(AppRoutName.notificationPage),
                  child: Icon(
                    Icons.notifications_active,
                    color: AppColors.white,
                    size: 21,
                  ),
                ),
              )
                  : Padding(
                padding:
                const EdgeInsets.only(right: 12, top: 17, bottom: 17),
                child: Badge(
                  smallSize: Dimensions.h9,
                  child: InkWell(
                    onTap: () =>
                        Get.toNamed(AppRoutName.notificationPage),
                    child: Icon(
                      Icons.notifications_active,
                      color: AppColors.white,
                      size: 21,
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Obx(
                        () => homeCon.bannerData.isNotEmpty
                        ? CarouselSlider(
                      items: homeCon.bannerData
                          .where((p0) =>
                      p0.isActive! &&
                          p0.key != "starlinePageBanner")
                          .map((element) {
                        return Builder(
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10),
                              child: Image(
                                fit: BoxFit.cover,
                                image: NetworkImage(element.banner ?? ""),
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                    Center(
                                      child: Icon(
                                        Icons.error_outline,
                                        color: AppColors.appbarColor,
                                        size: 35,
                                      ),
                                    ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: Dimensions.h90,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        aspectRatio: 17 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration:
                        const Duration(milliseconds: 600),
                        viewportFraction: 1,
                      ),
                    )
                        : SizedBox(
                      height: 100,
                      child: Center(
                        child: Icon(
                          Icons.error_outline,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () =>
                                    Get.to(() => StarlineDailyMarketData()),
                                child: Container(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: AppColors.appbarColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        ConstantImage.starLineIcon,
                                        height: 30,
                                        color: AppColors.white,
                                      ),
                                      const SizedBox(width: 15),
                                      Text(
                                        "SPL STARLINE",
                                        style: CustomTextStyle.textRobotoMedium
                                            .copyWith(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  homeCon.pageWidget.value = 2;
                                  walletCon.selectedIndex.value = 0;
                                },
                                child: Container(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: AppColors.appbarColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        ConstantImage.addFundIcon,
                                        height: 30,
                                        color: AppColors.white,
                                      ),
                                      const SizedBox(width: 15),
                                      Text(
                                        "ADD FUND",
                                        style: CustomTextStyle.textRobotoMedium
                                            .copyWith(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      NormalMarketsList(
                          normalMarketList: homeCon.normalMarketList),
                    ],
                  ),
                ],
              ),
            ),
            Obx(() {
              return homeCon.getNotificationCount.value > 0
                  ? Container(
                height: Get.height,
                width: Get.width,
                color: AppColors.black.withOpacity(0.4),
                padding: EdgeInsets.only(
                    left: 20.0, right: 10.0, top: 85, bottom: 60.0),
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10, right: 10),
                      color: Colors.white,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (var index = 0;
                            index < homeCon.notificationData.length;
                            index++)
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: notificationWidget(
                                  notificationHeader: homeCon
                                      .notificationData[index]
                                      .title ??
                                      "",
                                  notificationSubTitle: homeCon
                                      .notificationData[index]
                                      .description ??
                                      "",
                                  image: homeCon.notificationData[index]
                                      .notification,
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 5,
                      top: 0,
                      child: InkWell(
                        onTap: () {
                          homeCon.resetNotificationCount();
                          homeCon.getNotificationCount.refresh();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius:
                            BorderRadius.circular(Dimensions.r10),
                          ),
                          child: Icon(Icons.close,
                              color: AppColors.redColor),
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  : Container();
            })
          ],
        ),
      ),
    );
  }

  Widget drawerListItem(
      {required Function() onTap,
        required String iconData,
        required String text}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: Dimensions.h30,
            child: Row(
              children: [
                SizedBox(width: Dimensions.w20),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: SizedBox(
                    height: Dimensions.h20,
                    width: Dimensions.w20,
                    child: SvgPicture.asset(
                      iconData,
                      color: AppColors.appbarColor,
                    ),
                  ),
                ),
                SizedBox(
                  width: Dimensions.w15,
                ),
                Text(text,
                    style: CustomTextStyle.textRobotoMedium.copyWith(
                        fontSize: Dimensions.h14, fontWeight: FontWeight.w500))
              ],
            ),
          ),
          Divider(
            color: AppColors.grey,
            endIndent: 50,
            indent: 20,
          )
        ],
      ),
    );
  }

  Widget drawerListIconItem(
      {required Function() onTap,
        required IconData icon,
        required String text,
        bool isRotated = false}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: Dimensions.h30,
            child: Row(
              children: [
                SizedBox(width: Dimensions.w20),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: SizedBox(
                    height: Dimensions.h20,
                    width: Dimensions.w20,
                    child: isRotated
                        ? Transform.rotate(
                      angle: 180 * 3.14 / 48,
                      child: Icon(
                        icon,
                        color: AppColors.appbarColor,
                        size: 20,
                      ),
                    )
                        : Icon(
                      icon,
                      color: AppColors.appbarColor,
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(
                  width: Dimensions.w15,
                ),
                Text(text,
                    style: CustomTextStyle.textRobotoMedium.copyWith(
                        fontSize: Dimensions.h14, fontWeight: FontWeight.w500))
              ],
            ),
          ),
          Divider(
            color: AppColors.grey,
            endIndent: 50,
            indent: 20,
          )
        ],
      ),
    );
  }

  Widget notificationWidget(
      {String? notificationHeader,
        String? notificationSubTitle,
        String? image}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              spreadRadius: 1,
              color: AppColors.grey.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 0),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                gradient: LinearGradient(
                  colors: [AppColors.wpColor1, AppColors.wpColor2],
                ),
              ),
              child: Center(
                child: Text(
                  notificationHeader ?? "",
                  style: CustomTextStyle.textRobotoSansBold.copyWith(
                    color: AppColors.white,
                    fontSize: Dimensions.h14,
                  ),
                ),
              ),
            ),
            SizedBox(height: Dimensions.h5),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dear Players,",
                    textAlign: TextAlign.start,
                    style: CustomTextStyle.textRobotoSansLight.copyWith(
                      color: AppColors.black,
                      fontSize: Dimensions.h13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Dimensions.h5),
                  Text(
                    notificationSubTitle ?? "",
                    textAlign: TextAlign.start,
                    style: CustomTextStyle.textRobotoSansLight.copyWith(
                      color: AppColors.black,
                      fontSize: Dimensions.h13,
                    ),
                  ),
                  SizedBox(height: Dimensions.h5),
                  Visibility(
                    visible: image != null,
                    child: Container(
                      child: Image(
                        image: NetworkImage(image ?? ""),
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Icon(
                            Icons.error_outline,
                            color: AppColors.appbarColor,
                            size: 35,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: image != null,
                      child: SizedBox(height: Dimensions.h5)),
                  Text(
                    "Regards",
                    textAlign: TextAlign.start,
                    style: CustomTextStyle.textRobotoSansLight.copyWith(
                      color: AppColors.black,
                      fontSize: Dimensions.h13,
                    ),
                  ),
                  Text(
                    "SPL ADMIN",
                    textAlign: TextAlign.start,
                    style: CustomTextStyle.textRobotoSansLight.copyWith(
                      color: AppColors.black,
                      fontSize: Dimensions.h13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}