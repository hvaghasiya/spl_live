  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:flutter_svg/flutter_svg.dart';
  import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
  import 'package:spllive/screens/home_screen/utils/scan_to_pay_view.dart';
  import 'dart:convert';
  import 'package:http/http.dart' as http;

  import '../../Custom Controllers/wallet_controller.dart';
  import '../../api_services/api_urls.dart';
  import '../../components/simple_button_with_corner.dart';
  import '../../helper_files/app_colors.dart';
  import '../../helper_files/constant_image.dart';
  import '../../helper_files/constant_variables.dart';
import '../../helper_files/custom_text_style.dart';
  import '../../helper_files/dimentions.dart';
  import '../../helper_files/ui_utils.dart';
  import '../../widget/promo_video_player.dart';
  import 'controller/homepage_controller.dart';

  class AddFund extends StatefulWidget {
    final String? wallet;


    const AddFund({super.key, this.wallet});

    @override
    State<AddFund> createState() => _AddFundState();
  }

  class _AddFundState extends State<AddFund> with WidgetsBindingObserver {
    final homeCon = Get.put(HomePageController());
    final walletCon = Get.find<WalletController>();

    final String promotionalVideoLink = "https://www.youtube.com/watch?v=2ky-tWGD13Q";
    bool isProcessing = false;

    @override
    void initState() {
      super.initState();
      WidgetsBinding.instance.addObserver(this);
      homeCon.getTickets();
    }

    @override
    void dispose() {
      WidgetsBinding.instance.removeObserver(this);
      super.dispose();
    }

    @override
    void didChangeAppLifecycleState(AppLifecycleState state) {
      super.didChangeAppLifecycleState(state);
      switch (state) {
        case AppLifecycleState.resumed:
          if (walletCon.addFundID != null) {
            walletCon.paymentStatus(walletCon.addFundID);
          }
          walletCon.getUserBalance();
          break;
        case AppLifecycleState.inactive:
          break;
        case AppLifecycleState.paused:
          break;
        case AppLifecycleState.detached:
          break;
        default:
      }
    }

    Future<void> processPayment(String amount) async {
      setState(() {
        isProcessing = true;
      });

      try {
        final String url = ApiUtils.addFund;


        String token = GetStorage().read(ConstantsVariables.authToken) ?? "";

        Map<String, dynamic> body = {
          "amount": amount,
        };

        print("Calling API: $url with body: $body");
        print("Token being used: $token");

        final response = await http.post(
          Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode(body),
        );

        print("API Response: ${response.body}");

        setState(() {
          isProcessing = false;
        });

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);

          if (jsonResponse['status'] == true) {
            final paymentData = jsonResponse['data'];

            Get.to(() => ScanToPayScreen(
              amount: amount,
              payeeName: "SKYLINE TRADERS",
              paymentData: paymentData,
            ));
          } else {
            if (response.statusCode == 401 || jsonResponse['message'] == "Access Denied!") {
              AppUtils.showErrorSnackBar(bodyText: "Session Expired. Please Login Again.");
            } else {
              AppUtils.showErrorSnackBar(bodyText: jsonResponse['message'] ?? "Failed to initiate payment");
            }
          }
        } else {
          AppUtils.showErrorSnackBar(bodyText: "Server Error: ${response.statusCode}");
        }
      } catch (e) {
        setState(() {
          isProcessing = false;
        });
        print("Error: $e");
        AppUtils.showErrorSnackBar(bodyText: "Connection Error. Check internet/server.");
      }
    }

    @override
    Widget build(BuildContext context) {
      return PopScope(
        canPop: false,
        onPopInvoked: (value) async {
          if (value) {
            return;
          }
          if (walletCon.selectedIndex.value != null) {
            walletCon.selectedIndex.value = null;
          } else {
            Get.back();
          }
        },
        child: Material(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6,
                          spreadRadius: 2,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              AspectRatio(
                                aspectRatio: 11 / 5.0,
                                child: PromoVideoPlayer(
                                  videoUrl: promotionalVideoLink,
                                  isAutoPlay: false,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(19.w),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.8),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                  child: Text(
                                    "How to Add Funds",
                                    style: CustomTextStyle.textRobotoMedium.copyWith(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          offset: const Offset(0, 1),
                                          blurRadius: 10.0,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 0.1.h),
                SizedBox(height: 1.h),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: Get.width,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "WALLETBALANCE".tr,
                          style: CustomTextStyle.textRobotoMedium.copyWith(fontSize: Dimensions.h22),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: Dimensions.w40,
                                width: Dimensions.w40,
                                child: SvgPicture.asset(
                                  ConstantImage.walletAppbar,
                                  color: AppColors.appbarColor,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  walletCon.walletBalance.value ?? "",
                                  textAlign: TextAlign.center,
                                  style: CustomTextStyle.textRobotoMedium
                                      .copyWith(fontSize: Dimensions.h28, color: AppColors.appbarColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextFormField(
                    controller: homeCon.addFundCon,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                    ],
                    keyboardType: TextInputType.number,
                    style: CustomTextStyle.textGothamMedium,
                    cursorColor: AppColors.appbarColor,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: "Enter Amount",
                      hintStyle: CustomTextStyle.textRobotoMedium,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.r10),
                        borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.r10),
                        borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.r10),
                        borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 0.5.h),
                Obx(
                      () => Wrap(
                    alignment: WrapAlignment.center,
                    children: List.generate(
                      homeCon.newTicketsList.length,
                          (index) => Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: InkWell(
                          onTap: () {
                            homeCon.newTicketsList.forEach((element) => element.isSelected.value = false);
                            homeCon.addFundCon.text = homeCon.newTicketsList[index].name ?? "";
                            homeCon.newTicketsList[index].isSelected.value =
                            !homeCon.newTicketsList[index].isSelected.value;
                          },
                          child: Container(
                            height: 40,
                            width: Get.width * 0.25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: homeCon.newTicketsList[index].isSelected.value
                                  ? AppColors.appbarColor
                                  : AppColors.greywhite.withOpacity(0.55),
                            ),
                            child: Center(
                              child: Text(
                                "₹ ${homeCon.newTicketsList[index].name}",
                                style: CustomTextStyle.textRobotoMedium.copyWith(
                                  fontSize: 16,
                                  color:
                                  homeCon.newTicketsList[index].isSelected.value ? AppColors.white : AppColors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ).toList(),
                  ),
                ),
                SizedBox(height: 0.2.h),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: isProcessing
                      ? const CircularProgressIndicator()
                      : RoundedCornerButton(
                    text: "SUBMIT".tr,
                    color: AppColors.appbarColor,
                    borderColor: AppColors.appbarColor,
                    fontSize: Dimensions.h15,
                    fontWeight: FontWeight.w500,
                    fontColor: AppColors.white,
                    letterSpacing: 0,
                    borderRadius: Dimensions.r5,
                    borderWidth: 0,
                    textStyle: CustomTextStyle.textRobotoMedium,
                    onTap: () async {
                      if (homeCon.addFundCon.text.isEmpty) {
                        AppUtils.showErrorSnackBar(bodyText: "Please enter amount");
                      } else {
                        int enteredAmount = int.tryParse(homeCon.addFundCon.text) ?? 0;

                        if (enteredAmount < 100) {
                          AppUtils.showErrorSnackBar(bodyText: "Please add minimum amount of ₹ 100");
                        } else {
                          FocusScope.of(context).unfocus();

                          await processPayment(homeCon.addFundCon.text);
                        }
                      }
                    },
                    height: Dimensions.h35,
                    width: Get.width / 2,
                  ),
                ),

                SizedBox(height: Get.height * 0.0001),
                // Divider(endIndent: 20, indent: 20, color: AppColors.black),
                // const SizedBox(height: 10),
                // Text(
                //   "Pay using any UPI app",
                //   style: CustomTextStyle.textRobotoMedium.copyWith(
                //     fontSize: 16,
                //     color: AppColors.black,
                //   ),
                // ),
                // SizedBox(height: 0.2.h),
                // Wrap(
                //   alignment: WrapAlignment.spaceBetween,
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.only(right: 15.0),
                //       child: Image.asset(ConstantImage.gPay, height: 44, width: 44),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.only(right: 15.0),
                //       child: Image.asset(ConstantImage.paytm, height: 44, width: 44),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.only(right: 15.0),
                //       child: Image.asset(ConstantImage.amazon, height: 44, width: 44),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.only(right: 15.0),
                //       child: Image.asset(ConstantImage.phonepay, height: 44, width: 44),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.only(right: 15.0),
                //       child: Image.asset(ConstantImage.icici_bank, height: 44, width: 44),
                //     ),
                //   ],
                // ),
                // SizedBox(height: 1.h),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.only(right: 10.0),
                //       child: Image.asset(ConstantImage.bhim),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.only(right: 10.0),
                //       child: Image.asset(ConstantImage.upi),
                //     ),
                //   ],
                // )
              ],
            ),
          ),
        ),
      );
    }
  }