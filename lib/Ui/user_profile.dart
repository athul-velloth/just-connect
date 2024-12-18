import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:justconnect/Ui/login.dart';
import 'package:justconnect/constants/color_constants.dart';
import 'package:justconnect/constants/size_constants.dart';
import 'package:justconnect/constants/strings.dart';
import 'package:justconnect/model/Job.dart';
import 'package:justconnect/model/job_details_model.dart';
import 'package:justconnect/model/user_details.dart';
import 'package:justconnect/widget/ventas_primary_button.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String imageUrl = "";
  String name = "";
  String phoneNumber = "";
  final storage = GetStorage();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        name = storage.read('Name');
        imageUrl = storage.read('ImageUrl') ?? "";
        phoneNumber = storage.read('phone_number') ?? "";
      });
    });
    super.initState();
  }

  void _launchWhatsApp(String number) async {
    String url = 'https://wa.me/$number';
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching WhatsApp: $e');
    }
  }

  void _makePhoneCall(String number) async {
    String url = 'tel:$number';
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching phone call: $e');
    }
  }

  bool isBase64(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return false;
    try {
      base64Decode(imageUrl); // Try decoding to see if it's base64
      return true;
    } catch (e) {
      return false;
    }
  }

  String dateConvert(String date) {
    // Parse the timestamp string to DateTime
    DateTime dateTime = DateTime.parse(date);

    // Format the DateTime to the desired format (yyyy-MM-dd)
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: ColorConstant.backgroundColor,
        body: Padding(
          padding: EdgeInsets.only(
              left: SizeConstant.getHeightWithScreen(15),
              right: SizeConstant.getHeightWithScreen(15)),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).viewPadding.top,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: SizeConstant.topPadding,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  height: SizeConstant.getHeightWithScreen(35),
                                  width: SizeConstant.getHeightWithScreen(35),
                                  padding: EdgeInsets.only(
                                      left:
                                          SizeConstant.getHeightWithScreen(12),
                                      bottom:
                                          SizeConstant.getHeightWithScreen(10),
                                      right:
                                          SizeConstant.getHeightWithScreen(9),
                                      top: SizeConstant.getHeightWithScreen(9)),
                                  decoration: BoxDecoration(
                                    color: ColorConstant.vibBgColor,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: ColorConstant.black,
                                    size: SizeConstant.getHeightWithScreen(16),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: SizeConstant.getHeightWithScreen(15)),
                                child: Text(
                                  Strings.profile,
                                  style: TextStyle(
                                    color:
                                        ColorConstant.black.withOpacity(0.88),
                                    fontSize: SizeConstant.largeFont,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: SizeConstant.getHeightWithScreen(40)),
                    Center(
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundImage: imageUrl == null ||
                                imageUrl.toString().isEmpty
                            ? null // No background image (we will show the icon instead)
                            : isBase64(imageUrl)
                                ? MemoryImage(base64Decode(imageUrl
                                    .toString())) // If imageUrl is base64
                                : NetworkImage(imageUrl
                                    .toString()), // If imageUrl is a URL
                        child: imageUrl == null || imageUrl.toString().isEmpty
                            ? const Icon(Icons.person,
                                size: 40,
                                color: Colors
                                    .white) // Show person icon when image is missing
                            : null, // Don't show icon if there's an image
                      ),
                    ),
                    SizedBox(height: SizeConstant.getHeightWithScreen(20)),
                    // Text(
                    //   'Flat No: ${job.flatNo}',
                    //   style: const TextStyle(
                    //       fontSize: 18.0, fontWeight: FontWeight.bold),
                    // ),
                    // Text(
                    //   'Date: ${(job.date)}',
                    //   style: const TextStyle(fontSize: 16.0),
                    // ),
                    // Text(
                    //   'Type of Job: ${job.jobType}',
                    //   style: const TextStyle(fontSize: 16.0),
                    // ),
                    Text(
                      'Full Name: ${name}',
                      style: const TextStyle(
                          fontSize: 16.0, fontStyle: FontStyle.italic),
                    ),
                    Text(
                      'Mobile Number: ${phoneNumber}',
                      style: const TextStyle(
                          fontSize: 16.0, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConstant.getHeightWithScreen(10),
                  vertical: SizeConstant.getHeightWithScreen(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    VentasPrimaryButton(
                      onTap: () {
                        storage.erase();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Logout Successfully!')),
                        );
                        Get.offAll(
                          () => const Login(),
                        );
                      },
                      label: "Logout",
                      textColor: ColorConstant.white,
                      borderRadius: 10,
                      textSize: SizeConstant.mediumFont,
                      weight: FontWeight.w500,
                      btnHeight: SizeConstant.getHeightWithScreen(40),
                      btnWidth: (MediaQuery.of(context).size.width / 2) -
                          SizeConstant.getHeightWithScreen(45),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
