import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:justconnect/Ui/owner_dashboard/owner_dashboard.dart';
import 'package:justconnect/Ui/signup.dart';
import 'package:justconnect/constants/color_constants.dart';
import 'package:justconnect/constants/size_constants.dart';

import '../widget/commontextInputfield.dart';
import '../widget/common_button.dart';
import 'worker_dashboard/home.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(context),
              _inputField(context),
               SizedBox(),
              _signup(context),
            ],
          ),
        ),
      ),
    );
  }

  _header(context) {
    return const Column(
      children: [
        Text(
          "Welcome Back",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text("Enter your credential to login"),
      ],
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // CommonTextInputField(
        //   textInputType: TextInputType.emailAddress,
        //   showLabel: false,
        //   height: SizeConstant.getHeightWithScreen(55),
        //   controller: emailController,
        //   hintText: "Enter Email",
        //   isAteriskRequired: false,
        //   enableInteractiveSelection: false,
        //   onChanged: (p0) {
        //     setState(() {});
        //   },
        //   fillColor: Colors.purple.withOpacity(0.1),
        //   borderRadius: 18,
        //   prefixIcon: const Icon(Icons.person)
        //
        // ),
        TextField(
          decoration: InputDecoration(
              hintText: "Email",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              fillColor: Colors.purple.withOpacity(0.1),
              filled: true,
              prefixIcon: const Icon(Icons.person)),
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Colors.purple.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.password),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 40),
        CommonButton(
            bgColor: ColorConstant.outletButtonColor,
            btnHeight: SizeConstant.getHeightWithScreen(55),
            borderRadius: 20.0,
            onTap: () {
              String pattern =
                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
              RegExp regex = RegExp(pattern);

              final username = emailController.text;
              final password = passwordController.text;
              Get.to(() => const Home());
              if (username.isEmpty || password.isEmpty) {
                // Show error if fields are empty
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Please enter both email and password')),
                );
              } else if (!regex.hasMatch(emailController.text.trim())) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter valid email')),
                );
              } else {
                Get.to(() => const Home());
              }
            },
            label: 'Login'),
      ],
    );
  }

  _forgotPassword(context) {
    return TextButton(
      onPressed: () {},
      child: const Text(
        "Forgot password?",
        style: TextStyle(color: Colors.purple),
      ),
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Dont have an account? "),
        TextButton(
            onPressed: () {},
            child: const Text(
              "Sign Up",
              style: TextStyle(color: Colors.purple),
            ))
      ],
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: ColorConstant.white,
  //     body: SafeArea(
  //       top: true,
  //       child: Padding(
  //         padding: EdgeInsets.symmetric(
  //             horizontal: SizeConstant.getHeightWithScreen(16),
  //             vertical: MediaQuery.of(context).viewPadding.top),
  //         child: SingleChildScrollView(
  //           padding: const EdgeInsets.only(bottom: 10),
  //           child: Column(
  //             children: [
  //               SizedBox(height: SizeConstant.getHeightWithScreen(100)),
  //               Text(
  //                 "Login",
  //                 style: TextStyle(
  //                     color: ColorConstant.black,
  //                     fontSize: SizeConstant.largeFont),
  //               ),
  //               SizedBox(height: SizeConstant.getHeightWithScreen(20)),
  //
  //               CommonTextInputField(
  //                 textInputType: TextInputType.emailAddress,
  //                 showLabel: false,
  //                 height: SizeConstant.getHeightWithScreen(50),
  //                 controller: emailController,
  //                 hintText: "Enter Email",
  //                 isAteriskRequired: false,
  //                 enableInteractiveSelection: false,
  //                 onChanged: (p0) {
  //                   setState(() {});
  //                 },
  //
  //               ),
  //               SizedBox(height: SizeConstant.getHeightWithScreen(10)),
  //               CommonTextInputField(
  //                 textInputType: TextInputType.visiblePassword,
  //                 showLabel: false,
  //                 height: SizeConstant.getHeightWithScreen(50),
  //                 controller: passwordController,
  //                 hintText: "Enter Password",
  //                 isAteriskRequired: false,
  //                 enableInteractiveSelection: false,
  //                 onChanged: (p0) {
  //                   setState(() {});
  //                 },
  //               ),
  //               SizedBox(height: SizeConstant.getHeightWithScreen(10)),
  //               CommonButton(
  //                   bgColor: ColorConstant.outletButtonColor,
  //                   btnHeight: SizeConstant.getHeightWithScreen(48),
  //                   onTap: () {
  //                     String pattern =
  //                         r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  //                     RegExp regex = RegExp(pattern);
  //
  //                     final username = emailController.text;
  //                     final password = passwordController.text;
  //                     Get.to(() =>
  //                     const Home());
  //                     if (username.isEmpty || password.isEmpty) {
  //                       // Show error if fields are empty
  //                       ScaffoldMessenger.of(context).showSnackBar(
  //                         const SnackBar(
  //                             content: Text(
  //                                 'Please enter both email and password')),
  //                       );
  //                     } else if (!regex.hasMatch(emailController.text.trim())) {
  //                         ScaffoldMessenger.of(context).showSnackBar(
  //                         const SnackBar(
  //                             content: Text(
  //                                 'Please enter valid email')),
  //                       );
  //                     }
  //                     else {
  //                       Get.to(() =>
  //                       const Home());
  //                     }
  //                   },
  //                   label: 'Login'),
  //               SizedBox(height: SizeConstant.getHeightWithScreen(10)),
  //               GestureDetector(
  //                 onTap: () {
  //                   Get.to(() => const SignUp());
  //                 },
  //                 child: Text(
  //                   "Sign Up",
  //                   style: TextStyle(
  //                       color: ColorConstant.primaryColor,
  //                       fontSize: SizeConstant.largeFont),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
