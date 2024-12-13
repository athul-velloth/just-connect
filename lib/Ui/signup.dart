

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:justconnect/Ui/login.dart';

import '../constants/color_constants.dart';
import '../constants/size_constants.dart';
import '../widget/commontextInputfield.dart';
import '../widget/common_button.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController nameController = TextEditingController();
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
                Text("Sign Up", style: TextStyle(
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
                  controller: nameController,
                  hintText: "Enter Name",
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
                          .hasMatch(emailController.text.trim())) {}
                    },
                    label: 'Sign Up'),
                SizedBox(height: SizeConstant.getHeightWithScreen(10)),
                GestureDetector(
                  onTap: (){
                    Get.to(() => const Login());
                  },
                  child: Text("Login", style: TextStyle(
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
