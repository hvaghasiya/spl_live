import 'package:flutter/material.dart';

import '../helper_files/app_colors.dart';
import '../helper_files/custom_text_style.dart';
import '../helper_files/dimentions.dart';

class BidHistoryList extends StatelessWidget {
  const BidHistoryList({
    super.key,
    required this.bidType,
    required this.bidCoin,
    required this.bidNo,
    required this.onDelete,
    required this.marketName,
  });
  final String bidType;
  final String bidCoin;
  final String bidNo;
  final String marketName;
  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: Container(
        height: Dimensions.h40,
        width: size.width,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                blurRadius: 1, spreadRadius: 3, color: AppColors.grey.withOpacity(0.2), offset: const Offset(0, 1)),
          ],
        ),
        child: Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: Dimensions.w95,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$marketName : ",
                        style: CustomTextStyle.textRobotoSansBold.copyWith(
                          color: AppColors.black,
                          fontSize: Dimensions.h14,
                        ),
                      ),
                      Text(
                        bidNo,
                        style: CustomTextStyle.textRobotoSansLight.copyWith(
                          color: AppColors.black,
                          fontSize: Dimensions.h15,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: Dimensions.w80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "₹",
                        style: CustomTextStyle.textRobotoSansMedium.copyWith(
                          color: AppColors.black,
                          fontSize: Dimensions.h15,
                        ),
                      ),
                      Text(
                        bidCoin,
                        style: CustomTextStyle.textRobotoSansLight.copyWith(
                          color: AppColors.black,
                          fontSize: Dimensions.h15,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: Dimensions.w110,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 25),
                    child: Container(
                      decoration: BoxDecoration(
                          color: bidType == "" ? AppColors.white : AppColors.appbarColor.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(25)),
                      child: Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          bidType,
                          style: CustomTextStyle.textGothamBold.copyWith(
                            color: AppColors.black,
                            fontSize: Dimensions.h12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0, left: 0),
              child: InkWell(
                onTap: onDelete,
                child: Icon(
                  Icons.delete,
                  color: AppColors.redColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
