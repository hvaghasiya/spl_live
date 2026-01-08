import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../Custom Controllers/wallet_controller.dart';
import '../../../../components/simple_button_with_corner.dart';
import '../../../../helper_files/app_colors.dart';
import '../../../../helper_files/common_textfield_border.dart';
import '../../../../helper_files/constant_image.dart';
import '../../../../helper_files/custom_text_style.dart';
import '../../../../helper_files/dimentions.dart';
import '../../../More Details Screens/My Account Page/controller/myaccount_page_controller.dart';
import '../../../home_screen/controller/homepage_controller.dart';

class AddBankDetails extends StatefulWidget {
  const AddBankDetails({super.key});

  @override
  State<AddBankDetails> createState() => _AddBankDetailsState();
}

class _AddBankDetailsState extends State<AddBankDetails> {
  final homeCon = Get.put(HomePageController());
  final walletCon = Get.find<WalletController>();

  // var walletCon = Get.find<WalletController>();
  final controller = Get.put<MyAccountPageController>(MyAccountPageController());

  // final exitController = Get.put<DoubleTapExitController>(DoubleTapExitController());
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      controller.fetchStoredUserDetailsAndGetBankDetailsByUserId();
    });

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
        walletCon.selectedIndex.value = null;
        controller.bankNameController.clear();
        controller.accHolderNameController.clear();
        controller.accNoController.clear();
        controller.ifscCodeController.clear();
      },
      child: Expanded(
        child: Material(
          child: Stack(
            children: [
              Obx(
                () => controller.loadGetBalance.value == true
                    ? Container()
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: Dimensions.h10),
                            Obx(
                              () => CommonTextFieldBorder(
                                con: controller.accNoController,
                                labelText: "Account No.",
                                keyBoardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                readOnly: !controller.isEditDetails.value,
                              ),
                            ),
                            Obx(
                              () => CommonTextFieldBorder(
                                con: controller.ifscCodeController,
                                labelText: "IFSC Code",
                                readOnly: !controller.isEditDetails.value,
                              ),
                            ),
                            Obx(
                              () => CommonTextFieldBorder(
                                con: controller.accHolderNameController,
                                labelText: "Account Holder Name",
                                readOnly: !controller.isEditDetails.value,
                              ),
                            ),
                            Obx(
                              () => CommonTextFieldBorder(
                                con: controller.bankNameController,
                                labelText: "Bank Name",
                                readOnly: !controller.isEditDetails.value,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Obx(
                              () => !controller.isEditDetails.value
                                  ? const SizedBox()
                                  : RoundedCornerButton(
                                      text: "SUBMIT",
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
                                    ),
                            ),
                            Obx(
                              () => controller.isEditDetailsButton.value
                                  ? RoundedCornerButton(
                                      text: "EDIT BANK DETAILS",
                                      color: AppColors.wpColor1,
                                      borderColor: AppColors.appbarColor,
                                      fontSize: Dimensions.h13,
                                      fontWeight: FontWeight.bold,
                                      fontColor: AppColors.black,
                                      letterSpacing: 1,
                                      borderRadius: 5,
                                      borderWidth: 0,
                                      textStyle: CustomTextStyle.textRobotoMedium,
                                      onTap: () => _showExitDialog(),
                                      height: 40,
                                      width: 200,
                                    )
                                  : Container(),
                            ),
                          ],
                        ),
                      ),
              ),
              Obx(() =>
                  controller.loadGetBalance.value == true ? Center(child: CircularProgressIndicator()) : Container())
            ],
          ),
        ),
      ),
    );
  }

  void _showExitDialog() {
    Get.dialog(
      barrierDismissible: false,
      ConstrainedBox(
        constraints: BoxConstraints(maxHeight: Get.width - 30, minWidth: Get.width - 40),
        child: AlertDialog(
          insetPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          content: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SvgPicture.asset(ConstantImage.close, height: Dimensions.h60, width: Dimensions.w60),
                const SizedBox(height: 20),
                Text(
                  "Please Contact Admin to edit",
                  textAlign: TextAlign.center,
                  style: CustomTextStyle.textRamblaMedium.copyWith(
                    color: AppColors.appbarColor,
                    fontWeight: FontWeight.w700,
                    fontSize: Dimensions.h16,
                  ),
                ),
                Text(
                  "Bank details",
                  textAlign: TextAlign.center,
                  style: CustomTextStyle.textRamblaMedium.copyWith(
                    color: AppColors.appbarColor,
                    fontWeight: FontWeight.w700,
                    fontSize: Dimensions.h16,
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    decoration: BoxDecoration(color: AppColors.appbarColor, borderRadius: BorderRadius.circular(8)),
                    height: Dimensions.h40,
                    width: Dimensions.w150,
                    child: Center(
                      child: Text(
                        'OK',
                        style: CustomTextStyle.textRobotoSansBold.copyWith(color: AppColors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
