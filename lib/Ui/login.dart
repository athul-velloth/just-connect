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
  String _userType = '';
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
                Text(
                  "Login",
                  style: TextStyle(
                      color: ColorConstant.black,
                      fontSize: SizeConstant.largeFont),
                ),
                SizedBox(height: SizeConstant.getHeightWithScreen(20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _userType = 'Owner';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _userType == 'Owner'
                            ? Colors.blue
                            : Colors.white, // Change color
                        foregroundColor:
                            _userType == 'Owner' ? Colors.white : Colors.black,
                      ),
                      child:  Text('Owner'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _userType = 'Worker';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _userType == 'Worker'
                            ? Colors.blue
                            : Colors.white, // Change color
                        foregroundColor: _userType == 'Worker'
                            ? Colors.white
                            : Colors.black, // Change color
                      ),
                      child: Text('Worker'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CommonTextInputField(
                  textInputType: TextInputType.emailAddress,
                  showLabel: false,
                  height: SizeConstant.getHeightWithScreen(50),
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
                  textInputType: TextInputType.visiblePassword,
                  showLabel: false,
                  height: SizeConstant.getHeightWithScreen(50),
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
                    btnHeight: SizeConstant.getHeightWithScreen(48),
                    onTap: () {
                      String pattern =
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                      RegExp regex = RegExp(pattern);
                      
                      final username = emailController.text;
                      final password = passwordController.text;
                      if (username.isEmpty || password.isEmpty) {
                        // Show error if fields are empty
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Please enter both email and password')),
                        );
                      } else if (!regex.hasMatch(emailController.text.trim())) {
                          ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Please enter valid email')),
                        );
                      }
                      
                      else if (_userType.isEmpty) {
                        // Show error if user type is not selected
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select user type')),
                        );
                      } else {
                        // Navigate based on selected user type
                        if (_userType == 'Owner') {
                          Get.to(() =>
                              const Home()); // Navigate to Owner home page
                        } else if (_userType == 'Worker') {
                          Get.to(() =>
                              const Home()); // Navigate to Worker home page
                        }
                      }
                    },
                    label: 'Login'),
                SizedBox(height: SizeConstant.getHeightWithScreen(10)),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const SignUp());
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                        color: ColorConstant.primaryColor,
                        fontSize: SizeConstant.largeFont),
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
