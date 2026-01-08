import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../Custom Controllers/doubletap_exitcontroller.dart';
import '../../../components/edit_text_field_with_icon.dart';
import '../../../components/simple_button_with_corner.dart';
import '../../../helper_files/app_colors.dart';
import '../../../helper_files/custom_text_style.dart';
import '../../../helper_files/dimentions.dart';
import '../../../helper_files/ui_utils.dart';
import 'controller/myaccount_page_controller.dart';

class MyAccountPage extends StatefulWidget {
  MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  final controller = Get.put<MyAccountPageController>(MyAccountPageController());
  final exitController = Get.put<DoubleTapExitController>(DoubleTapExitController());
  @override
  void initState() {
    controller.fetchStoredUserDetailsAndGetBankDetailsByUserId();
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
        exitController.onWillPop();
      },
      child: Scaffold(
        appBar: AppUtils().simpleAppbar(
          appBarTitle: "MYACCOUNT".tr,
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () => _showExitDialog(),
                child: Icon(
                  Icons.note_alt_rounded,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Obx(
            () => Column(
              children: [
                SizedBox(height: Dimensions.h10),
                listTileDetails(
                    text: "BANK_TEXT".tr,
                    value: controller.bankName.value,
                    fieldController: controller.bankNameController,
                    autofocus: true),
                listTileDetails(
                    text: "ACNAME_TEXT".tr,
                    value: controller.accountName.value,
                    fieldController: controller.accHolderNameController),
                listTileDetails(
                  text: "ACNO_TEXT".tr,
                  value: controller.accountNumber.value,
                  fieldController: controller.accNoController,
                  formatter: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                ),
                listTileDetails(
                    text: "IFSC_TEXT".tr,
                    value: controller.ifcsCode.value,
                    fieldController: controller.ifscCodeController),
                controller.isEditDetails.value == true
                    ? RoundedCornerButton(
                        text: "Submit",
                        color: AppColors.appbarColor,
                        borderColor: AppColors.appbarColor,
                        fontSize: Dimensions.h13,
                        fontWeight: FontWeight.bold,
                        fontColor: AppColors.white,
                        letterSpacing: 1,
                        borderRadius: 5,
                        borderWidth: 0,
                        textStyle: CustomTextStyle.textPTsansMedium,
                        onTap: () => controller.validationFied(),
                        height: 40,
                        width: 200,
                      )
                    // ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //         backgroundColor: AppColors.appbarColor),
                    //     onPressed: () {
                    //       controller.onTapOfEditDetails();
                    //     },
                    //     child: Text(
                    //       "Submit",
                    //       style: CustomTextStyle.textPTsansMedium.copyWith(
                    //         fontSize: Dimensions.h14,
                    //         color: AppColors.white,
                    //       ),
                    //     ),
                    //   )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding listTileDetails({
    required String text,
    required String value,
    required TextEditingController fieldController,
    bool? autofocus,
    List<TextInputFormatter>? formatter,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.w8),
      child: Container(
        height: Dimensions.h60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.grey, width: 0.5),
          borderRadius: BorderRadius.circular(Dimensions.r5),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: Dimensions.w10),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  text,
                  style: CustomTextStyle.textPTsansBold.copyWith(
                    color: AppColors.black,
                    fontSize: Dimensions.h16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: controller.isEditDetails.value == false
                    ? Text(
                        value,
                        style: CustomTextStyle.textRobotoSansMedium.copyWith(
                          fontSize: Dimensions.h14,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: bidHistoryList(
                          fieldController,
                          autofocus: autofocus,
                          formatter: formatter,
                          keyboardType: keyboardType,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bidHistoryList(TextEditingController controller,
      {bool? autofocus, List<TextInputFormatter>? formatter, TextInputType? keyboardType}) {
    return RoundedCornerEditTextWithIcon(
      controller: controller,
      hintText: "",
      imagePath: "",
      height: Dimensions.h42,
      keyboardType: keyboardType ?? TextInputType.text,
      textStyle: CustomTextStyle.textRobotoSansMedium.copyWith(fontSize: Dimensions.h15, fontWeight: FontWeight.w500),
      autofocus: autofocus,
      formatter: formatter ?? [FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9\s]+$'))],
    );
  }

  void _showExitDialog() {
    Get.defaultDialog(
      barrierDismissible: false,
      title: "Contact Admin",
      onWillPop: () async => false,
      titleStyle: CustomTextStyle.textRobotoSansMedium,
      content: Column(
        children: [Text("SNACKMSG_TEXT".tr, style: CustomTextStyle.textRobotoSansMedium)],
      ),
      actions: [
        InkWell(
          onTap: () async {
            Get.back();
          },
          child: Container(
            color: AppColors.appbarColor,
            height: Dimensions.h40,
            width: Dimensions.w150,
            child: Center(
              child: Text(
                'OK',
                style: CustomTextStyle.textRobotoSansBold.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// bidHistoryList(TextEditingController controller) {
//   return TextField(
//       controller: controller,
//       style: CustomTextStyle.textPTsansMedium.copyWith(
//         fontSize: Dimensions.h14,
//       ));
// }
