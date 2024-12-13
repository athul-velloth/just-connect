import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SizeConstant {
  final BuildContext context;

  SizeConstant({
    required this.context,
  });

  factory SizeConstant.fromBuildContext(BuildContext context) {
    // Adjust this multiplier to set your font size scaling

    return SizeConstant(
      context: context,
    );
  }

  static var defaultDesignSize = const Size(360, 760);

  static double verySmallFont = 8.0.sp;
  static double xxSmallFont = 9.0.sp;
  static double xSmallFont = 10.0.sp;
  static double smallXFont = 11.0.sp;
  static double smallFont = 12.0.sp;
  static double mediumSmallFont = 13.0.sp;
  static double mediumFont = 14.0.sp;
  static double mediumLargeFont = 15.0.sp;
  static double largeFont = 16.0.sp;
  static double xlargeFont = 18.0.sp;
  static double xxlargeFont = 20.0.sp;
  static double largeXFont = 21.0.sp;
  static double xxxlargeFont = 22.0.sp;
  static double large25Font = 25.0.sp;
  static double large26Font = 26.0.sp;
  static double large28Font = 28.0.sp;
  static double heavyFont = 32.0.sp;

  // Button sizes
  static double btnHeight = getHeightWithScreen(48);
  static double searchBarHeight = getHeightWithScreen(40);
  static double onboardingTextInputHeight = getHeightWithScreen(52);

  // Horizontal Padding
  static double horizontalPadding = getHeightWithScreen(16);

  //page view
  static double pgvDescTextFontSize = 16.sp;

  //otp field
  static double otpFieldTextSize = 22.sp;

  static double topPadding = getHeightWithScreen(25);
  static double iconSize = getHeightWithScreen(24);

  static double getHeightWithScreen(double value) {
    return ScreenUtil().orientation == Orientation.portrait ? value.h : value.w;
  }

  static double getFontSizeInDp(double value) {
    return value.sp;
  }
}
