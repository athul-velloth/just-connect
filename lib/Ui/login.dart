

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:justconnect/Ui/signup.dart';
import 'package:justconnect/constants/color_constants.dart';
import 'package:justconnect/constants/size_constants.dart';

import '../widget/commontextInputfield.dart';
import '../widget/common_button.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      body: SafeArea(
        top: true,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConstant.getHeightWithScreen(16),
              vertical: MediaQuery.of(context).viewPadding.top),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                SizedBox(height: SizeConstant.getHeightWithScreen(100)),
                Text("Login", style: TextStyle(
                  color: ColorConstant.black,
                  fontSize: SizeConstant.largeFont
                ),),
                SizedBox(height: SizeConstant.getHeightWithScreen(20)),
                CommonTextInputField(
                  textInputType: TextInputType.number,
                  showLabel: false,
                  height:
                  SizeConstant.getHeightWithScreen(
                      50),
                  controller: emailController,
                  hintText: "Enter Email",
                  isAteriskRequired: false,
                  enableInteractiveSelection: false,
                  onChanged: (p0) {
                    setState(() {});
                  },
                ),
                SizedBox(height: SizeConstant.getHeightWithScreen(10)),
                CommonTextInputField(
                  textInputType: TextInputType.number,
                  showLabel: false,
                  height:
                  SizeConstant.getHeightWithScreen(
                      50),
                  controller: passwordController,
                  hintText: "Enter Password",
            
                  isAteriskRequired: false,
                  enableInteractiveSelection: false,
                  onChanged: (p0) {
                    setState(() {});
                  },
                ),
                SizedBox(height: SizeConstant.getHeightWithScreen(10)),
                CommonButton(
                    bgColor: ColorConstant.outletButtonColor,
                    btnHeight:
                    SizeConstant.getHeightWithScreen(48),
                    onTap: () {
                        String pattern =
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                        RegExp regex = RegExp(pattern);
                      if (!regex
                          .hasMatch(emailController.text.trim())) {
                        Get.to(() => const Home());
                      }
                    },
                    label: 'Login'),
                SizedBox(height: SizeConstant.getHeightWithScreen(10)),
                GestureDetector(
                  onTap: (){
                    Get.to(() => const SignUp());
                  },
                  child: Text("Sign Up", style: TextStyle(
                      color: ColorConstant.primaryColor,
                      fontSize: SizeConstant.largeFont
                  ),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
