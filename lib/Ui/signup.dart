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
  String _userType = 'Owner';
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const SizedBox(height: 60.0),
                  const Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Create your account",
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  )
                ],
              ),
              SizedBox(height: SizeConstant.getHeightWithScreen(20)),
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
              SizedBox(height: SizeConstant.getHeightWithScreen(5)),
              GestureDetector(
                onTap: () {
                  _requestCameraPermission();
                },
                child: Center(
                  child: Text(
                    'Take Selfie',
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: SizeConstant.largeFont,
                      fontWeight: FontWeight.w500,
                      color: ColorConstant.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: SizeConstant.getHeightWithScreen(20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _userType = 'Owner';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _userType == 'Owner'
                            ? Colors.blue
                            : Colors.white, // Change color
                        foregroundColor: _userType == 'Owner'
                            ? Colors.white
                            : Colors.black, // Text color
                      ),
                      child: const Text('Owner'),
                    ),
                  ),
                  const SizedBox(width: 8), // Add space between buttons
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _userType = 'Maid';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _userType == 'Maid'
                            ? Colors.blue
                            : Colors.white, // Change color
                        foregroundColor: _userType == 'Maid'
                            ? Colors.white
                            : Colors.black, // Text color
                      ),
                      child: const Text('Maid'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConstant.getHeightWithScreen(20)),
              Column(
                children: <Widget>[
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                        hintText: "Enter Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none),
                        fillColor: Colors.purple.withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.person)),
                  ),
                  SizedBox(height: SizeConstant.getHeightWithScreen(10)),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: "Enter Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none),
                        fillColor: Colors.purple.withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.email)),
                  ),
                  SizedBox(height: SizeConstant.getHeightWithScreen(10)),
                  TextField(
                    controller: mobileNoController,
                    decoration: InputDecoration(
                        hintText: "Enter Mobile No.",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none),
                        fillColor: Colors.purple.withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.email)),
                  ),
                  SizedBox(height: SizeConstant.getHeightWithScreen(10)),
                  TextField(
                    controller: faltNoController,
                    decoration: InputDecoration(
                        hintText: "Enter Flat No.",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none),
                        fillColor: Colors.purple.withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.email)),
                  ),
                  SizedBox(
                      height: SizeConstant.getHeightWithScreen(
                          _userType == "Owner" ? 0 : 10)),
                  _userType == "Owner"
                      ? const SizedBox()
                      : TextField(
                          controller: typeController,
                          decoration: InputDecoration(
                              hintText: "Enter Type of Job.",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor: Colors.purple.withOpacity(0.1),
                              filled: true,
                              prefixIcon: const Icon(Icons.email)),
                        ),
                  SizedBox(height: SizeConstant.getHeightWithScreen(10)),
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
                  SizedBox(height: SizeConstant.getHeightWithScreen(10)),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none),
                      fillColor: Colors.purple.withOpacity(0.1),
                      filled: true,
                      prefixIcon: const Icon(Icons.password),
                    ),
                    obscureText: true,
                  ),
                ],
              ),
              SizedBox(height: SizeConstant.getHeightWithScreen(40)),
              CommonButton(
                  bgColor: ColorConstant.outletButtonColor,
                  btnHeight: SizeConstant.getHeightWithScreen(55),
                  borderRadius: SizeConstant.getHeightWithScreen(20),
                  onTap: () {
                    String pattern =
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                    RegExp regex = RegExp(pattern);
                    if (!regex.hasMatch(emailController.text.trim())) {}
                  },
                  label: 'Sign Up'),
              SizedBox(height: SizeConstant.getHeightWithScreen(10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Already have an account?"),
                  TextButton(
                      onPressed: () {
                        Get.to(() => const Login());
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.purple),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
