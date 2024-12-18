import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:justconnect/constants/color_constants.dart';
import 'package:justconnect/constants/size_constants.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart' as perm;

import 'package:url_launcher/url_launcher.dart';

class Helper {
  static progressDialog(
    BuildContext context,
    String? message, {
    bool canPop = false,
  }) {
    showGeneralDialog(
      barrierDismissible: false,
      barrierColor: ColorConstant.black.withOpacity(0.6),
      context: context,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return PopScope(
          canPop: canPop,
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: SizeConstant.getHeightWithScreen(105),
                    width: SizeConstant.getHeightWithScreen(105),
                    child: Lottie.asset(
                      'assets/json_assets/loader.json',
                      height: SizeConstant.getHeightWithScreen(105),
                      width: SizeConstant.getHeightWithScreen(105),
                      delegates: LottieDelegates(
                        values: [
                          ValueDelegate.blurRadius(
                            ['**'],
                            value: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    "loading".tr,
                    style: TextStyle(
                      color: ColorConstant.white,
                      fontSize: SizeConstant.mediumFont,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void showCustomSnackbar(String message) {
    Get.showSnackbar(
      GetSnackBar(
        padding: EdgeInsets.all(SizeConstant.getHeightWithScreen(10)),
        messageText: Row(
          children: [
            SizedBox(width: SizeConstant.getHeightWithScreen(12)),
            Text(
              message,
              style: TextStyle(
                color: ColorConstant.black3,
                fontSize: SizeConstant.xSmallFont,
              ),
            ),
          ],
        ),
        backgroundColor: ColorConstant.green5,
        snackPosition: SnackPosition.TOP,
        borderRadius: SizeConstant.getHeightWithScreen(10),
        borderColor: ColorConstant.green6,
        margin: EdgeInsets.only(
          left: SizeConstant.getHeightWithScreen(16),
          right: SizeConstant.getHeightWithScreen(16),
          bottom: SizeConstant.getHeightWithScreen(144),
        ),
        icon: Container(
          height: SizeConstant.getHeightWithScreen(20),
          width: SizeConstant.getHeightWithScreen(20),
          decoration: BoxDecoration(
            color: ColorConstant.green4,
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(
            SizeConstant.getHeightWithScreen(5),
          ),
          child: Icon(
            Icons.check,
            color: ColorConstant.white,
            size: SizeConstant.getHeightWithScreen(10),
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void showAssetSnackbar(String title, String message,
      {bool isSuccess = true}) {
    Get.showSnackbar(
      GetSnackBar(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConstant.getHeightWithScreen(16),
          vertical: SizeConstant.getHeightWithScreen(20),
        ),
        titleText: Text(
          title,
          style: TextStyle(
            color: ColorConstant.black3,
            fontSize: SizeConstant.smallFont,
            fontWeight: FontWeight.w500,
          ),
        ),
        messageText: Text(
          message,
          style: TextStyle(
            color: ColorConstant.grey42,
            fontSize: SizeConstant.smallXFont,
          ),
        ),
        mainButton: GestureDetector(
          onTap: () {
            Helper.close();
          },
          child: Icon(
            Icons.close,
            color: ColorConstant.grey11,
            size: SizeConstant.getHeightWithScreen(16),
          ),
        ),
        backgroundColor: isSuccess ? ColorConstant.green5 : ColorConstant.red3,
        snackPosition: SnackPosition.TOP,
        icon: Image(
          fit: BoxFit.contain,
          image: AssetImage(
            isSuccess
                ? "assets/images/success.png"
                : "assets/images/failed.png",
          ),
          height: SizeConstant.getHeightWithScreen(20),
          width: SizeConstant.getHeightWithScreen(20),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static assetSuccessDialog(
    BuildContext context,
    String title,
    String content,
    AssetImage asset,
  ) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pop(true);
        });
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Dialog(
            insetPadding: EdgeInsets.all(SizeConstant.getHeightWithScreen(20)),
            child: Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: ColorConstant.white,
                borderRadius:
                    BorderRadius.circular(SizeConstant.getHeightWithScreen(16)),
              ),
              padding: EdgeInsets.symmetric(
                  vertical: SizeConstant.getHeightWithScreen(30),
                  horizontal: SizeConstant.getHeightWithScreen(10)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image(
                    fit: BoxFit.contain,
                    image: asset,
                    height: SizeConstant.getHeightWithScreen(50),
                    width: SizeConstant.getHeightWithScreen(50),
                  ),
                  SizedBox(
                    height: SizeConstant.getHeightWithScreen(10),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                        color: ColorConstant.pgvDescTextColor,
                        fontSize: SizeConstant.mediumFont,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: SizeConstant.getHeightWithScreen(9),
                  ),
                  Text(
                    content,
                    style: TextStyle(
                        color: ColorConstant.grey5,
                        fontSize: SizeConstant.mediumFont,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static confirmationDialog(BuildContext context, String title, String content,
      VoidCallback onClick) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Helper.close();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onClick,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Yes, proceed",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
            ],
          );
        });
  }

  static hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static String? validateLatLong(String? value) {
    final RegExp latLongRegex = RegExp(
      r'^\s*([-+]?([1-8]?\d(\.\d+)?|90(\.0+)?)),\s*([-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?))\s*$',
    );
    if (value == null || value.isEmpty) {
      return 'Please enter latitude and longitude';
    }
    if (!value.contains(",") || !latLongRegex.hasMatch(value)) {
      return 'Wrong format (format: 00.0000, 00.0000)';
    }
    return null;
  }

  static String? validatePin(String? value) {
    final RegExp pinRegex = RegExp(r'^\d{6}$');
    if (value == null || value.isEmpty) {
      return 'Please enter PIN code';
    }
    if (!pinRegex.hasMatch(value)) {
      return 'Please enter valid PIN code (6 digits)';
    }
    return null;
  }

  static Widget searchAnimation() {
    return SizedBox(
      height: SizeConstant.getHeightWithScreen(70),
      width: double.maxFinite,
      child: Lottie.asset(
        'assets/json_assets/loading.json',
        package: "common",
        height: SizeConstant.getHeightWithScreen(70),
        width: double.maxFinite,
      ),
    );
  }

  static Widget linearAnimation() {
    return SizedBox(
      height: SizeConstant.getHeightWithScreen(2),
      width: double.maxFinite,
      child: LinearProgressIndicator(
        color: ColorConstant.primaryColor,
        valueColor: AlwaysStoppedAnimation(
          ColorConstant.primaryColor,
        ),
      ),
    );
  }

  static Future copyToClipBoard(String? text) async {
    if (text == null) {
      return;
    }
    await Clipboard.setData(
      ClipboardData(text: text),
    );

    Get.showSnackbar(
      GetSnackBar(
        title: "Copied !",
        message: "$text copied to clipboard",
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// helper function to close the screen, popup etc.
  static void close() {
    BuildContext context = Get.context!;
    Navigator.of(context).pop();
  }

  static String formatDateInTimeZone(DateTime dateTime) {
    // Convert to the desired time zone (for example, UTC+7)
    final utcDateTime = dateTime.toUtc();
    const timeZoneOffset = Duration(hours: 7); // Offset for UTC+7
    final localDateTime = utcDateTime.add(timeZoneOffset);

    // Format the date-time
    final formatter = DateFormat("dd MMM yyyy, hh:mm a");
    return formatter.format(localDateTime);
  }

  // Helper function to format the percentage
  static String formatPercentage(String? percentage) {
    if (percentage == null || percentage.isEmpty) {
      return '0';
    }

    double value = double.parse(percentage);

    if (value >= 1000) {
      // Convert the value to a rounded integer and then to a string with a 'k' suffix
      return '${(value / 1000).round()}k';
    } else {
      // Round and return the value as an integer string
      return value.round().toString();
    }
  }

  static String getFromDate() {
    DateTime now = DateTime.now();

    DateTime startOfYear = DateTime(now.year, 1, 1);
    String formattedDate = startOfYear.toIso8601String();
    String formattedDateWithTimezone = '$formattedDate+07:00';

    return formattedDateWithTimezone;
  }

  static String getEndDate() {
    DateTime today = DateTime.now();
    String formattedDate = today.toIso8601String();
    String formattedDateWithTimezone = '$formattedDate+07:00';

    return formattedDateWithTimezone;
  }
}

enum UrlType { IMAGE, VIDEO, DOC, UNKNOWN }
