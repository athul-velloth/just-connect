import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:justconnect/Ui/owner_dashboard/owner_dashboard.dart';
import 'package:justconnect/Ui/worker_dashboard/home.dart';

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
  final storage = GetStorage();
  String signUpType = "";

  @override
  void initState() {
     WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          signUpType = storage.read('SignUpType');
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
     
      if (signUpType.isEmpty || signUpType == null) {
        Get.to(() => const Login());
      } else {
        if (signUpType == "Owner") {
          Get.to(() => const OwnerDashboard());
        } else {
          Get.to(() => const Home());
        }
      }
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
