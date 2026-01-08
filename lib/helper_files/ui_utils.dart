import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'app_colors.dart';
import 'constant_image.dart';
import 'custom_text_style.dart';
import 'dimentions.dart';


class AppUtils {
  static bool isProgressVisible = false;
  static bool isVisibleSnackBar = false;
  static SystemUiOverlayStyle toolBarStyleLight = const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    // <-- SEE HERE
    statusBarIconBrightness: Brightness.light,
    //<-- For Android SEE HERE (dark icons)
    statusBarBrightness: Brightness.light, //<-- For iOS SEE HERE (dark icons)
  );

  //common method for dark toolbar theme
  static SystemUiOverlayStyle toolBarStyleDark = const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    // <-- SEE HERE
    statusBarIconBrightness: Brightness.dark,
    //<-- For Android SEE HERE (dark icons)
    statusBarBrightness: Brightness.dark, //<-- For iOS SEE HERE (dark icons)
  );

  AppBar simpleAppbar({
    required String appBarTitle,
    List<Widget>? actions,
    Widget? leading,
    double? leadingWidht,
    bool? centerTitle,
    TextStyle? appBarTitlestyle,
  }) {
    return AppBar(
      backgroundColor: AppColors.appbarColor,
      shadowColor: AppColors.white,
      elevation: 0,
      centerTitle: centerTitle ?? false,
      leading: leading,
      leadingWidth: leadingWidht,
      title: Text(
        appBarTitle,
        style: appBarTitlestyle ?? CustomTextStyle.textRobotoSansMedium.copyWith(color: AppColors.white),
      ),
      actions: actions,
    );
  }

  Widget nameIcons(
      {required Function() onTap,
      required String icon,
      required String iconText,
      required double width,
      Color? textColor,
      double? iconwidth,
      Color? color}) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: Dimensions.w15,
              width: iconwidth ?? Dimensions.w15,
              child: SvgPicture.asset(
                icon,
                color: color ?? AppColors.grey,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                iconText,
                style: CustomTextStyle.textPTsansMedium
                    .copyWith(color: textColor ?? AppColors.grey, fontSize: Dimensions.h11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar appbar(
    size, {
    required Function() onTapTranction,
    required Function() onTapNotifiaction,
    required Function() shareOntap,
    required Function() onTapTelegram,
    required String walletText,
    String? notifictionCount,
  }) {
    return AppBar(
      backgroundColor: AppColors.appbarColor,
      title: Text("SPL", style: TextStyle(color: AppColors.white)),
      centerTitle: true,
      leadingWidth: Get.width * 0.4,
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: Dimensions.w5),
          InkWell(
            onTap: onTapTranction,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: SizedBox(
                width: Dimensions.w40,
                child: SvgPicture.asset(
                  ConstantImage.walletAppbar,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          Text(
            walletText.toString().length > 8 ? walletText.toString().split(".").toString() : walletText,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyle.textRobotoSansMedium.copyWith(
              color: AppColors.white,
              fontSize: 20,
            ),
          ),
        ],
      ),
      actions: [
        notifictionCount == null || notifictionCount == "0"
            ? Padding(
                padding: const EdgeInsets.only(right: 12),
                child: InkWell(
                  onTap: onTapNotifiaction,
                  child: Icon(
                    Icons.notifications_active,
                    color: AppColors.white,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(right: 12, top: 17, bottom: 17),
                child: Badge(
                  smallSize: Dimensions.h9,
                  child: InkWell(
                    onTap: onTapNotifiaction,
                    child: Icon(
                      Icons.notifications_active,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 17),
          child: InkWell(
            onTap: onTapTelegram,
            child: Container(
              decoration: BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
              child: Transform.rotate(
                angle: 180 * 3.14 / 48,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5, top: 5, left: 5, right: 3),
                  child: Icon(
                    Icons.send,
                    size: 11,
                    color: AppColors.appbarColor,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
          child: InkWell(
            onTap: shareOntap,
            child: Container(
              decoration: BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.share,
                  size: 11,
                  color: AppColors.appbarColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

//common method for showing progress dialog
  static void showProgressDialog({isCancellable = false}) async {
    print("jhgkjfhskfsfksdd");
    if (!isProgressVisible && !Get.isSnackbarOpen) {
      Get.dialog(
        Center(
          child: SizedBox(
            width: Dimensions.h80,
            height: Dimensions.h80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: Dimensions.h40,
                  width: Dimensions.h40,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.green),
                    strokeWidth: 4,
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: isCancellable,
      );
      isProgressVisible = true;
    }
  }

  //common method for hiding progress dialog
  static void hideProgressDialog() {
    if (Get.isDialogOpen == true) {
      Get.closeAllSnackbars();
      Get.back();
    }
    isProgressVisible = false;
  }

  //common method for show error snack-bar
  static void showErrorSnackBar({required String bodyText, Duration? duration}) {
    if (Get.isDialogOpen == true) {
      Get.closeCurrentSnackbar();
    }
    Get.snackbar(
      "",
      "",
      titleText: Padding(
        padding: EdgeInsets.only(top: Dimensions.h20, left: Dimensions.w15),
        child: Text(
          bodyText,
          textAlign: TextAlign.start,
          style: CustomTextStyle.textRobotoSansMedium.copyWith(
            color: AppColors.white,
          ),
        ),
      ),
      padding: EdgeInsets.zero,
      snackPosition: SnackPosition.TOP,
      isDismissible: true,
      onTap: null,
      duration: duration ?? const Duration(seconds: 3),
      colorText: AppColors.white,
      maxWidth: double.infinity,
      snackStyle: SnackStyle.FLOATING,
      backgroundColor: AppColors.black.withOpacity(0.6),
      borderRadius: 5,
      margin: const EdgeInsets.all(10),
    );
  }

  //common method for show success snack-bar
  static void showSuccessSnackBar({headerText, bodyText}) {
    Get.closeCurrentSnackbar();
    Get.snackbar(
      "",
      "",
      titleText: Padding(
        padding: EdgeInsets.only(top: Dimensions.h20, left: Dimensions.w15),
        child: Text(
          bodyText,
          textAlign: TextAlign.start,
          style: CustomTextStyle.textRobotoSansMedium.copyWith(
            color: AppColors.white,
          ),
        ),
      ),
      padding: EdgeInsets.zero,
      snackPosition: SnackPosition.TOP,
      isDismissible: true,
      backgroundColor: AppColors.black.withOpacity(0.6),
      onTap: null,
      borderRadius: 5,
      margin: const EdgeInsets.all(10),
    );
  }

  ///drawer
  Future<dynamic> showRateUsBoxDailog(Function callCreateRatingApi, double? givenRatings) async {
    double tempRatings = 0.00;
    IconData? selectedIcon;
    return Get.defaultDialog(
      barrierDismissible: false,
      onWillPop: () async => false,
      title: "",
      titleStyle: const TextStyle(fontSize: 0),
      backgroundColor: AppColors.white,
      content: Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(Dimensions.r18),
          ),
        ),
        child: Center(
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(Dimensions.r18)),
            child: Padding(
              padding: EdgeInsets.only(
                top: Dimensions.h5,
                left: Dimensions.h5,
                right: Dimensions.h5,
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Rate SPL live App",
                        style: CustomTextStyle.textRobotoMedium.copyWith(
                          color: AppColors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: Dimensions.h20,
                          letterSpacing: 1.29,
                        ),
                      ),
                      const SizedBox(height: 15),
                      RatingBar.builder(
                        initialRating: givenRatings != null || givenRatings!.toDouble() != 0.0 ? givenRatings : 0,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemSize: Dimensions.h35,
                        ignoreGestures: givenRatings.toDouble() != 0.0 ? true : false,
                        glowColor: AppColors.appbarColor,
                        unratedColor: AppColors.grey,

                        itemPadding: EdgeInsets.symmetric(horizontal: Dimensions.w4),
                        itemBuilder: (context, index) {
                          if (index >= tempRatings) {
                            if (givenRatings.toDouble() != 0.0) {
                              return Icon(
                                selectedIcon ?? Icons.star_rounded,
                                color: AppColors.appbarColor,
                                size: 35,
                              );
                            } else {
                              // Unrated items
                              return Icon(
                                selectedIcon ?? Icons.star_border_rounded,
                                color: AppColors.grey,
                                size: 35,
                              );
                            }
                          } else {
                            // Rated items
                            return Icon(
                              selectedIcon ?? Icons.star_rounded,
                              color: AppColors.appbarColor,
                              size: 35,
                            );
                          }
                        },
                        onRatingUpdate: (rating) async {
                          tempRatings = rating;
                        },
                        //updateOnDrag: true,
                        tapOnlyMode: true,
                      ),
                      const SizedBox(height: 50)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () => Get.back(),
                        child: Center(
                          child: Text(
                            "CANCEL",
                            style: CustomTextStyle.textPTsansMedium.copyWith(
                              color: AppColors.redColor,
                              fontSize: Dimensions.h18,
                            ),
                          ),
                        ),
                      ),
                      // const Spacer(),
                      const SizedBox(width: 25),
                      InkWell(
                        onTap: () {
                          if (givenRatings.toDouble() != 0.00) {
                            AppUtils.showErrorSnackBar(bodyText: "You can not add ratings multiple times!!!");
                          } else {
                            if (tempRatings < 1.00) {
                              AppUtils.showErrorSnackBar(bodyText: "Please Add Ratings");
                            } else {
                              callCreateRatingApi(tempRatings);
                            }
                          }
                        },
                        child: Center(
                          child: Text(
                            "SUBMIT",
                            style: CustomTextStyle.textPTsansMedium.copyWith(
                              color: AppColors.appbarColor,
                              fontSize: Dimensions.h18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  accountFlowDialog({String? msg}) {
    return Get.defaultDialog(
      barrierDismissible: false,
      onWillPop: () async => false,
      title: "",
      titlePadding: EdgeInsets.zero,
      titleStyle: const TextStyle(fontSize: 0),
      backgroundColor: AppColors.white,
      content: Column(
        children: [
          SizedBox(height: Dimensions.h20),
          Center(
            child: Text(
              msg ?? "",
              textAlign: TextAlign.center,
              style: CustomTextStyle.textRobotoSansMedium.copyWith(
                fontSize: Dimensions.h15,
                color: AppColors.appbarColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: Dimensions.h20),
        ],
      ),
      actions: [
        InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            height: Dimensions.h30,
            width: Get.width / 2.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.appbarColor,
            ),
            child: Center(
              child: Text(
                'Ok',
                style: CustomTextStyle.textRobotoSansBold.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
