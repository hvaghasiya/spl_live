import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../helper_files/app_colors.dart';
import '../../../helper_files/custom_notification_toggle.dart';
import '../../../helper_files/custom_text_style.dart';
import '../../../helper_files/dimentions.dart';
import '../../../helper_files/ui_utils.dart';
import 'controller/notification_details_controller.dart';

class NotificationDetailsPage extends StatelessWidget {
  NotificationDetailsPage({super.key});

  var controller = Get.put(NotificationDetailsPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppUtils().simpleAppbar(appBarTitle: "NOTIFICATIONS".tr),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: Dimensions.h50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 1,
                    blurRadius: 4,
                    color: AppColors.grey.withOpacity(0.5),
                    offset: const Offset(0, 0),
                  )
                ],
                borderRadius: BorderRadius.circular(Dimensions.r4),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "MARKETNOTIFICATION".tr,
                      style: CustomTextStyle.textRobotoMedium.copyWith(
                        color: AppColors.black,
                        fontSize: Dimensions.h15,
                      ),
                    ),
                    Obx(
                      () => CustomNotificationSwitch<bool>(
                        onTap: (value) {
                          print("fsdjfgdsfsd");
                          print(value.tapped!.value);
                          controller.marketNotificationFromLocal.value = !controller.marketNotificationFromLocal.value;
                          controller.callNotification();
                        },
                        current: controller.marketNotificationFromLocal.value,
                        values: [false, true],
                        spacing: 0.0,
                        indicatorSize: Size.square(25.0),
                        animationDuration: const Duration(milliseconds: 200),
                        animationCurve: Curves.linear,
                        onChanged: (value) {
                          print("hsasahhsa ${value}");
                          controller.marketNotificationFromLocal.value = value;
                          controller.callNotification();
                        },
                        iconBuilder: (context, local, global) {
                          return const SizedBox();
                        },
                        cursors: ToggleCursors(defaultCursor: SystemMouseCursors.click),
                        iconsTappable: false,
                        wrapperBuilder: (context, global, child) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                  left: 8.0,
                                  right: 8.0,
                                  height: 13.0,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Color.lerp(Colors.black26, AppColors.appToggleBGColor, global.position),
                                      borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                                    ),
                                  )),
                              child,
                            ],
                          );
                        },
                        foregroundIndicatorBuilder: (context, global) {
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SizedBox.fromSize(
                              size: Size.fromHeight(12.0),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Color.lerp(Colors.white, AppColors.appBlueColor, global.position),
                                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black38,
                                        spreadRadius: 0.05,
                                        blurRadius: 1.1,
                                        offset: Offset(0.0, 0.8))
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    /*Obx(
                      () => Switch(
                        activeColor: AppColors.appbarColor,
                        // activeTrackColor: Colors.lightGreenAccent,
                        // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

                        value: controller.marketNotificationFromLocal.value,
                        onChanged: (value) {
                          controller.marketNotificationFromLocal.value = value;

                          controller.callNotification();
                        },
                      ),
                    )*/
                  ],
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.h8,
            ),
            Container(
              height: Dimensions.h50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 1,
                    blurRadius: 4,
                    color: AppColors.grey.withOpacity(0.5),
                    offset: const Offset(0, 0),
                  )
                ],
                borderRadius: BorderRadius.circular(Dimensions.r4),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "STARLINENOTIFICATION".tr,
                      style: CustomTextStyle.textRobotoMedium.copyWith(
                        color: AppColors.black,
                        fontSize: Dimensions.h15,
                      ),
                    ),
                    Obx(
                      () => CustomNotificationSwitch<bool>(
                        onTap: (value) {
                          print("fsdkjfhsd");
                          print(value.tapped?.value);
                          controller.starlineNotificationFromLocal.value =
                              !controller.starlineNotificationFromLocal.value;

                          controller.callNotification();
                        },
                        current: controller.starlineNotificationFromLocal.value,
                        values: [false, true],
                        spacing: 0.0,
                        indicatorSize: Size.square(25.0),
                        animationDuration: const Duration(milliseconds: 200),
                        animationCurve: Curves.linear,
                        onChanged: (value) {
                          controller.starlineNotificationFromLocal.value = value;

                          controller.callNotification();
                        },
                        iconBuilder: (context, local, global) {
                          return const SizedBox();
                        },
                        cursors: ToggleCursors(defaultCursor: SystemMouseCursors.click),

                        // onTap: (_) {
                        //   controller.starlineNotificationFromLocal.value =
                        //       !controller.starlineNotificationFromLocal.value;
                        // },
                        iconsTappable: false,
                        wrapperBuilder: (context, global, child) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                  left: 8.0,
                                  right: 8.0,
                                  height: 13.0,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Color.lerp(Colors.black26, AppColors.appToggleBGColor, global.position),
                                      borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                                    ),
                                  )),
                              child,
                            ],
                          );
                        },
                        foregroundIndicatorBuilder: (context, global) {
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SizedBox.fromSize(
                              size: Size.fromHeight(12.0),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Color.lerp(Colors.white, AppColors.appBlueColor, global.position),
                                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black38,
                                        spreadRadius: 0.05,
                                        blurRadius: 1.1,
                                        offset: Offset(0.0, 0.8))
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    /* Obx(
                      () => Switch(
                        activeColor: AppColors.appbarColor,
                        // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: controller.starlineNotificationFromLocal.value,
                        onChanged: (value) {
                          controller.starlineNotificationFromLocal.value = value;

                          controller.callNotification();
                        },
                      ),
                    )*/
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomToggleSwitch extends StatefulWidget {
  final bool value;
  final Function(bool) onChanged;

  // final IconData onIcon;
  // final IconData offIcon;
  final Color activeColor;
  final Color inactiveColor;

  const CustomToggleSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    // this.onIcon,
    // required this.offIcon,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
  }) : super(key: key);

  @override
  _CustomToggleSwitchState createState() => _CustomToggleSwitchState();
}

class _CustomToggleSwitchState extends State<CustomToggleSwitch> {
  bool _isOn = false;

  @override
  void initState() {
    super.initState();
    _isOn = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isOn = !_isOn;
          widget.onChanged(_isOn);
        });
      },
      child: Container(
        width: 80.0, // Adjust width as needed
        height: 40.0, // Adjust height as needed
        decoration: BoxDecoration(
          color: _isOn ? widget.activeColor : widget.inactiveColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Stack(
          children: [
            // Animated Track
            AnimatedAlign(
              duration: Duration(milliseconds: 200),
              alignment: _isOn ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 30.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            // Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.white),
                Icon(Icons.lightbulb, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
