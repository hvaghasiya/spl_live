import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/constant_variables.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/models/commun_models/user_details_model.dart';
import 'package:spllive/routes/app_routes_name.dart';
import 'package:spllive/screens/More%20Details%20Screens/myProfile/controller/myprofile_page_controller.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String gender = '';
  final controller = Get.put(MyProfilePageController());
  @override
  void initState() {
    super.initState();
    controller.userDetailsModel.value = UserDetailsModel.fromJson(GetStorage().read(ConstantsVariables.userData));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppUtils().simpleAppbar(appBarTitle: "Change Password"),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.h15),
        child: Column(
          children: [
            SizedBox(height: Dimensions.h15),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     SizedBox(height: Dimensions.h15),
            //     SizedBox(
            //       height: Dimensions.h50,
            //       width: Dimensions.w100,
            //       child: Image.asset(
            //         ConstantImage.splLogo,
            //         fit: BoxFit.contain,
            //       ),
            //     ),
            //     SizedBox(width: 10),
            //     Obx(
            //       () => Expanded(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text(
            //               "User Name : ${controller.userDetailsModel.value.userName ?? ""}",
            //               // style: TextStyle(fontSize: 17, color: AppColors.black),\
            //               textAlign: TextAlign.start,
            //               style: CustomTextStyle.textRobotoSansMedium.copyWith(
            //                 fontSize: Dimensions.h15,
            //               ),
            //             ),
            //             Text(
            //               "Mobile No : ${controller.userDetailsModel.value.phoneNumber ?? ""} ",
            //               // style: TextStyle(fontSize: 17, color: AppColors.black),\
            //               textAlign: TextAlign.start,
            //               style: CustomTextStyle.textRobotoSansMedium.copyWith(
            //                 fontSize: Dimensions.h15,
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 15),
            cardListwidget("CHANGEPASSWORD2".tr, onTap: () => Get.toNamed(AppRoutName.changePassPage)),
            const SizedBox(height: 15),
            cardListwidget("CHANGEMOBILENUMBER".tr, onTap: () => Get.toNamed(AppRoutName.changeMpinPage)),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  cardListwidget(String text, {required Function() onTap}) {
    return Container(
      decoration:
          BoxDecoration(color: AppColors.changePassTileColor, borderRadius: BorderRadius.circular(10.0), boxShadow: [
        BoxShadow(offset: Offset(0, 0), blurRadius: 2, spreadRadius: 1, color: AppColors.black.withOpacity(0.2)),
      ]),
      child: SizedBox(
        height: Dimensions.h50,
        child: ListTile(
          onTap: onTap,
          leading: Icon(Icons.lock_outline, color: AppColors.appbarColor),
          title: Text(
            text,
            // "Change Password",
            style: CustomTextStyle.textRobotoMedium
                .copyWith(color: AppColors.black, fontSize: Dimensions.h16, fontWeight: FontWeight.w600),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
          ),
        ),
      ),
    );
  }
}
