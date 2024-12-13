import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../constants/color_constants.dart';
import '../constants/size_constants.dart';
import 'login.dart';



class SplashScreen extends StatefulWidget {


  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Get.to(() => const Login());
    });
    ScreenUtil.init(
      context,
      designSize: const Size(375, 812), // Set your design size.
      minTextAdapt: true, // Initialize minTextAdapt here.
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.white,
        body: InkWell(
          onTap: () async {},
          child: Center(
            child: Text(
              "Just Connect",
              style: TextStyle(
                color: ColorConstant.primaryColor,
                fontSize: SizeConstant.largeXFont,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }



}
