import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:justconnect/constants/color_constants.dart';
import 'package:justconnect/constants/size_constants.dart';
import 'package:justconnect/constants/strings.dart';
import 'package:justconnect/model/Job.dart';
import 'package:justconnect/model/user_details.dart';
import 'package:justconnect/widget/ventas_primary_button.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetailPage extends StatelessWidget {
  final UserDetails job;

  const JobDetailPage({Key? key, required this.job}) : super(key: key);

  void _launchWhatsApp(String number) async {
    final url = 'https://wa.me/$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch WhatsApp';
    }
  }

  void _makePhoneCall(String number) async {
    final url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not make the phone call';
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
        backgroundColor: ColorConstant.white,
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
                                  Strings.jobDetails,
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
                          Row(children: [
                            GestureDetector(
                              onTap: () {
                                _makePhoneCall(job.phoneNumber.toString());
                              },
                              child: Image(
                                image:
                                    const AssetImage("assets/images/phone.png"),
                                height: SizeConstant.getHeightWithScreen(24),
                                width: SizeConstant.getHeightWithScreen(24),
                              ),
                            ),
                            SizedBox(
                              width: SizeConstant.getHeightWithScreen(10),
                            ),
                            GestureDetector(
                              onTap: () {
                                _launchWhatsApp(job.phoneNumber.toString());
                              },
                              child: Image(
                                image: const AssetImage(
                                  "assets/images/whatsapp.png",
                                ),
                                height: SizeConstant.getHeightWithScreen(24),
                                width: SizeConstant.getHeightWithScreen(24),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                    SizedBox(height: SizeConstant.getHeightWithScreen(40)),
                    Center(
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundImage: job.imageUrl == null ||
                                job.imageUrl.toString().isEmpty
                            ? null // No background image (we will show the icon instead)
                            : isBase64(job.imageUrl)
                                ? MemoryImage(base64Decode(job.imageUrl
                                    .toString())) // If imageUrl is base64
                                : NetworkImage(job.imageUrl
                                    .toString()), // If imageUrl is a URL
                        child: job.imageUrl == null ||
                                job.imageUrl.toString().isEmpty
                            ? const Icon(Icons.person,
                                size: 40,
                                color: Colors
                                    .white) // Show person icon when image is missing
                            : null, // Don't show icon if there's an image
                      ),
                    ),
                    SizedBox(height: SizeConstant.getHeightWithScreen(20)),
                    Text(
                      'Flat No: ${job.flatNo}',
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Date: ${dateConvert(job.createdAt)}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      'Type of Job: ${job.jobType}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      'Full Name: ${job.name}',
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
                    InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Job Decline!')),
                        );
                      },
                      child: Container(
                          width: (MediaQuery.of(context).size.width / 2) -
                              SizeConstant.getHeightWithScreen(45),
                          height: SizeConstant.getHeightWithScreen(40),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: ColorConstant.primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(
                                SizeConstant.getHeightWithScreen(10)),
                          ),
                          child: Center(
                            child: Text(
                              "Decline Job",
                              style: TextStyle(
                                fontSize: SizeConstant.mediumFont,
                                fontWeight: FontWeight.w500,
                                color: ColorConstant.primaryColor,
                              ),
                            ),
                          )),
                    ),
                    SizedBox(
                      width: SizeConstant.getHeightWithScreen(10),
                    ),
                    VentasPrimaryButton(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Job Accepted!')),
                        );
                      },
                      label: "Accept Job",
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

  // @override
  // Widget build(BuildContext context) {
  //   return SafeArea(
  //     top: false,
  //     child: Scaffold(
  //       backgroundColor: ColorConstant.white,
  //       body: Padding(
  //         padding: EdgeInsets.only(
  //             left: SizeConstant.getHeightWithScreen(15),
  //             right: SizeConstant.getHeightWithScreen(15)),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             SizedBox(
  //               height: MediaQuery.of(context).viewPadding.top,
  //             ),
  //             Padding(
  //               padding: EdgeInsets.only(
  //                   top: SizeConstant.topPadding,
  //                   right: SizeConstant.getHeightWithScreen(15)),
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   GestureDetector(
  //                     onTap: () {
  //                       Navigator.of(context).pop();
  //                     },
  //                     child: Container(
  //                       height: SizeConstant.getHeightWithScreen(35),
  //                       width: SizeConstant.getHeightWithScreen(35),
  //                       padding: EdgeInsets.only(
  //                           left: SizeConstant.getHeightWithScreen(12),
  //                           bottom: SizeConstant.getHeightWithScreen(10),
  //                           right: SizeConstant.getHeightWithScreen(9),
  //                           top: SizeConstant.getHeightWithScreen(9)),
  //                       decoration: BoxDecoration(
  //                         color: ColorConstant.vibBgColor,
  //                         borderRadius: const BorderRadius.all(
  //                           Radius.circular(10),
  //                         ),
  //                       ),
  //                       child: Icon(
  //                         Icons.arrow_back_ios,
  //                         color: ColorConstant.black,
  //                         size: SizeConstant.getHeightWithScreen(16),
  //                       ),
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: EdgeInsets.only(
  //                         left: SizeConstant.getHeightWithScreen(15)),
  //                     child: Text(
  //                       Strings.createJob,
  //                       style: TextStyle(
  //                         color: ColorConstant.black.withOpacity(0.88),
  //                         fontSize: SizeConstant.largeFont,
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             SizedBox(height: SizeConstant.getHeightWithScreen(40)),
  //             Center(
  //               child: CircleAvatar(
  //                 radius: 50.0,
  //                 backgroundImage: NetworkImage(job.ownerImage),
  //               ),
  //             ),
  //             SizedBox(height: SizeConstant.getHeightWithScreen(20)),
  //             Text(
  //               'Flat No: ${job.flatNo}',
  //               style:
  //               const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
  //             ),
  //             Text(
  //               'Date: ${job.date}',
  //               style: const TextStyle(fontSize: 16.0),
  //             ),
  //             Text(
  //               'Type of Job: ${job.jobType}',
  //               style: const TextStyle(fontSize: 16.0),
  //             ),
  //             Text(
  //               'Full Name: ${job.fullName}',
  //               style:
  //               const TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
  //             ),
  //             SizedBox(height: SizeConstant.getHeightWithScreen(20)),
  //             ElevatedButton(
  //               onPressed: () {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   const SnackBar(content: Text('Job Accepted!')),
  //                 );
  //               },
  //               child: const Text('Accept Job'),
  //             ),
  //             SizedBox(height: SizeConstant.getHeightWithScreen(20)),
  //             ElevatedButton.icon(
  //               onPressed: () => _makePhoneCall(job.contactNumber),
  //               icon: const Icon(Icons.phone),
  //               label: const Text('Call Owner'),
  //             ),
  //             SizedBox(height: SizeConstant.getHeightWithScreen(20)),
  //             ElevatedButton.icon(
  //               onPressed: () => _launchWhatsApp(job.contactNumber),
  //               icon: const Icon(Icons.message),
  //               label: const Text('Chat on WhatsApp'),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );

  // }
}
