import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justconnect/Ui/login.dart';
import 'package:justconnect/controller/login_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  final LoginController _loginController = Get.put(LoginController());
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

  Future<void> showDownloadSnackbar(String message) async {
    Future.delayed(const Duration(milliseconds: 100), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
          ),
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
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
                          _loginController.typeController.clear();
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
                    controller: _loginController.nameController,
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
                    controller: _loginController.emailController,
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
                    controller: _loginController.mobileNoController,
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
                    controller: _loginController.faltNoController,
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
                          controller: _loginController.typeController,
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
                    controller: _loginController.passwordController,
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
                    controller: _loginController.confirmPasswordController,
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
                  onTap: () async {
                    final email = _loginController.emailController.text.trim();
                    final password =
                        _loginController.passwordController.text.trim();
                    String pattern =
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                    RegExp regex = RegExp(pattern);
                    if (_loginController.nameController.text.isEmpty ||
                        _loginController.nameController.text.length < 3) {
                      // Show error if fields are empty
                      showDownloadSnackbar("Please enter the name");
                    } else if (!regex.hasMatch(
                        _loginController.emailController.text.trim())) {
                      showDownloadSnackbar("Please enter the valid email");
                    } else if (_loginController.mobileNoController.text
                            .trim()
                            .length <
                        9) {
                      showDownloadSnackbar("Please enter the valid number");
                    } else if (_loginController.faltNoController.text
                        .trim()
                        .isEmpty) {
                      showDownloadSnackbar("Please enter the flat no");
                    } else if (_userType == "Maid" &&
                        _loginController.typeController.text.trim().isEmpty) {
                      showDownloadSnackbar("Please enter the job type");
                    } else if (_loginController.passwordController.text
                        .trim()
                        .isEmpty) {
                      showDownloadSnackbar("Please enter the password");
                    } else if (_loginController.passwordController.text
                            .trim() !=
                        _loginController.confirmPasswordController.text
                            .trim()) {
                      showDownloadSnackbar("Password did not match");
                    } else {
                      try {
                        // Sign in with Supabase
                        final response = await Supabase.instance.client
                            .from('user') // Your table name
                            .insert({
                          'email': email,
                          'password': password,
                          'name': _loginController.nameController.text.trim(),
                          'phone_number':
                              _loginController.mobileNoController.text.trim(),
                          'flat_no':
                              _loginController.faltNoController.text.trim(),
                          'job_type':
                              _loginController.typeController.text.trim(),
                          'sign_up_type': _userType.trim(),
                        }).select();
                        // final response = await Supabase.instance.client.auth
                        //     .signUp(
                        //   email: email,
                        //   password: password,
                        // );

                        // Check for successful sign-in
                        // if (response.user != null) {
                        showDownloadSnackbar("SignUP successful");
                        _loginController.nameController.clear();
                        _loginController.emailController.clear();
                        _loginController.mobileNoController.clear();
                        _loginController.faltNoController.clear();
                        _loginController.passwordController.clear();
                        _loginController.confirmPasswordController.clear();
                        _loginController.typeController.clear();
                        //   Get.to(() => const Home());
                        // } else {
                        //   showDownloadSnackbar("Login failed: No user found");
                        // }
                      } on AuthException catch (e) {
                        // Handle Supabase-specific authentication errors
                        showDownloadSnackbar("Login failed: ${e.message}");
                      } catch (e) {
                        // Handle unexpected errors
                        showDownloadSnackbar("Unexpected error: $e");
                        print("$e");
                      } finally {
                        setState(() {
                          //_loading = false; // Reset loading state
                        });
                      }

                      //  Get.to(() => const Home());
                    }
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
