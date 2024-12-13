import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justconnect/Ui/login.dart';
import 'package:permission_handler/permission_handler.dart';
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
  final TextEditingController faltNoController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  String _userType = '';
  File? _selfieImage; // To store the captured image
  final ImagePicker _picker = ImagePicker();
  Future<void> _takeSelfie() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera, // Use camera for selfie
      preferredCameraDevice: CameraDevice.front, // Front camera for selfies
    );
    if (image != null) {
      setState(() {
        _selfieImage = File(image.path); // Store the image file
      });
    }
  }

  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.status;

    if (status.isPermanentlyDenied) {
      openAppSettings(); // This function navigates the user to app settings
      return;
    }
    if (!status.isGranted) {
      // Request the permission if not already granted
      status = await Permission.camera.request();
    }

    if (status.isGranted) {
      _takeSelfie(); // Call the function to capture an image if permission is granted
    } else if (status.isDenied || status.isPermanentlyDenied) {
      // Show a dialog or handle permission denial
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Camera permission is required to take selfies.")),
      );
    }
  }

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
                SizedBox(height: SizeConstant.getHeightWithScreen(50)),
                Text(
                  "Sign Up",
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
                      child: Text('Owner'),
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
                CircleAvatar(
                  radius: 50, // Size of the avatar
                  backgroundImage: _selfieImage != null
                      ? FileImage(_selfieImage!) // Display captured selfie
                      : null,
                  child: _selfieImage == null
                      ? const Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Colors.grey,
                        )
                      : null, // Show a camera icon if no selfie is taken
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _requestCameraPermission, // Trigger selfie capture
                  child: const Text('Take Selfie'),
                ),
                const SizedBox(height: 20),
                CommonTextInputField(
                  textInputType: TextInputType.number,
                  showLabel: false,
                  height: SizeConstant.getHeightWithScreen(50),
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
                  textInputType: TextInputType.number,
                  showLabel: false,
                  height: SizeConstant.getHeightWithScreen(50),
                  controller: mobileNoController,
                  hintText: "Enter mobile no.",
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
                  height: SizeConstant.getHeightWithScreen(50),
                  controller: faltNoController,
                  hintText: "Enter Flat No.",
                  isAteriskRequired: false,
                  enableInteractiveSelection: false,
                  onChanged: (p0) {
                    setState(() {});
                  },
                ),
                SizedBox(
                    height: SizeConstant.getHeightWithScreen(
                        _userType == "Owner" ? 0 : 10)),
                _userType == "Owner"
                    ? const SizedBox()
                    : CommonTextInputField(
                        textInputType: TextInputType.text,
                        showLabel: false,
                        height: SizeConstant.getHeightWithScreen(50),
                        controller: typeController,
                        hintText: "Enter Type of Job",
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
                      if (!regex.hasMatch(emailController.text.trim())) {}
                    },
                    label: 'Sign Up'),
                SizedBox(height: SizeConstant.getHeightWithScreen(10)),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const Login());
                  },
                  child: Text(
                    "Login",
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
