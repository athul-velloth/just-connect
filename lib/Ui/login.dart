import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:justconnect/Ui/owner_dashboard/owner_dashboard.dart';
import 'package:justconnect/Ui/signup.dart';
import 'package:justconnect/constants/color_constants.dart';
import 'package:justconnect/constants/size_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  final storage = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _header(context),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none),
                      fillColor: Colors.purple.withOpacity(0.1),
                      filled: true,
                      prefixIcon: const Icon(Icons.email)),
                ),
                SizedBox(height: SizeConstant.getHeightWithScreen(10)),
                TextField(
                  controller: passwordController,
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
                SizedBox(height: SizeConstant.getHeightWithScreen(40)),
                CommonButton(
                    bgColor: ColorConstant.outletButtonColor,
                    btnHeight: SizeConstant.getHeightWithScreen(55),
                    borderRadius: SizeConstant.getHeightWithScreen(20.0),
                    onTap: () async {
                      String pattern =
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                      RegExp regex = RegExp(pattern);

                      final username = emailController.text;
                      final password = passwordController.text;
                      if (username.isEmpty || password.isEmpty) {
                        // Show error if fields are empty
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Please enter both email and password')),
                        );
                      } else if (!regex.hasMatch(emailController.text.trim())) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please enter valid email')),
                        );
                      } else {
                        setState(() {
                          // _loading = true;
                        });

                        try {
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();

                          // Sign in with Supabase
                          final response = await Supabase.instance.client
                              .from('user') // Replace with your table name
                              .select()
                              .eq('email', email) // Filter by email
                              .eq('password', password) // Filter by password
                              .maybeSingle();
                          // final response = await Supabase.instance.client.auth
                          //     .signInWithPassword(
                          //   email: email,
                          //   password: password ,
                          // );

                          // Check for successful sign-in
                          if (response != null) {
                            final int id = response['id'];
                            final String signUpType = response['sign_up_type'];
                            final int phoneNumber = response['phone_number'];

                            final String name = response['name'];
                            storage.write("Name", name.toString());
                            storage.write("UserId", id.toString());
                            storage.write(
                                "phone_number", phoneNumber.toString());

                            showDownloadSnackbar("Login successful");
                            if (signUpType == "Owner") {
                              Get.to(() => const OwnerDashboard());
                            } else {
                              Get.to(() => const Home());
                            }
                          } else {
                            showDownloadSnackbar("Login failed: No user found");
                          }
                        } on AuthException catch (e) {
                          // Handle Supabase-specific authentication errors
                          showDownloadSnackbar("Login failed: ${e.message}");
                        } catch (e) {
                          // Handle unexpected errors
                          showDownloadSnackbar("invalid Login details");
                        } finally {
                          setState(() {
                            //_loading = false; // Reset loading state
                          });
                        }

                        //  Get.to(() => const Home());
                      }
                    },
                    label: 'Login'),
              ],
            ),
            SizedBox(),
            _signup(context),
          ],
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
            onPressed: () {
              Get.to(() => const SignUp());
            },
            child: const Text(
              "Sign Up",
              style: TextStyle(color: Colors.purple),
            ))
      ],
    );
  }
}
