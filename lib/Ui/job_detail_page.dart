import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:justconnect/Ui/owner_dashboard/owner_dashboard.dart';
import 'package:justconnect/constants/color_constants.dart';
import 'package:justconnect/constants/size_constants.dart';
import 'package:justconnect/constants/strings.dart';
import 'package:justconnect/model/Job.dart';
import 'package:justconnect/model/job_details_model.dart';
import 'package:justconnect/model/user_details.dart';
import 'package:justconnect/widget/helper.dart';
import 'package:justconnect/widget/ventas_primary_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetailPage extends StatefulWidget {
  final JobDetailsModel job;

  const JobDetailPage({Key? key, required this.job}) : super(key: key);

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
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

  Future<void> updateJobStatus(String jobId, String newStatus) async {
    try {
      Helper.progressDialog(context, "Loading...");
      final response = await Supabase.instance.client
            .from('job_create_list')
          .update({'job_status': newStatus}) // Update the `job_status`
          .eq('id', jobId)
          .select(); // Filter by the job ID or any unique column

      if (response.isNotEmpty) {
        Helper.close();
        showDownloadSnackbar("Job Accepted!");
         Get.off(() => const OwnerDashboard());
      } else {
        Helper.close();
        showDownloadSnackbar("Error updating job status: ${response}");
        print('Error updating job status: ${response}');
      }
    } catch (e) {
      Helper.close();
      showDownloadSnackbar("Exception while updating job status: $e");
      print('Exception while updating job status: $e');
    }
  }

  String jobTypeConvert(String job) {
    List<String> jobTypes = List<String>.from(jsonDecode(job));
    String jobTypesString = jobTypes.join(', ');
    return jobTypesString;
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
                                _makePhoneCall(
                                    widget.job.phoneNumber.toString());
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
                                _launchWhatsApp(
                                    widget.job.phoneNumber.toString());
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
                        backgroundImage: widget.job.ownerProfileImage == null ||
                                widget.job.ownerProfileImage.toString().isEmpty
                            ? null // No background image (we will show the icon instead)
                            : isBase64(widget.job.ownerProfileImage)
                                ? MemoryImage(base64Decode(widget
                                    .job.ownerProfileImage
                                    .toString())) // If imageUrl is base64
                                : NetworkImage(widget.job.ownerProfileImage
                                    .toString()), // If imageUrl is a URL
                        child: widget.job.ownerProfileImage == null ||
                                widget.job.ownerProfileImage.toString().isEmpty
                            ? const Icon(Icons.person,
                                size: 40,
                                color: Colors
                                    .white) // Show person icon when image is missing
                            : null, // Don't show icon if there's an image
                      ),
                    ),
                    SizedBox(height: SizeConstant.getHeightWithScreen(20)),
                    Text(
                      'Flat No: ${widget.job.flatNo}',
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Expected Date: ${(widget.job.date)}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      'Maid Type: ${jobTypeConvert(widget.job.jobType)}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      'Owner Name: ${widget.job.ownerName}',
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
                    // InkWell(
                    //   onTap: () {
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       const SnackBar(content: Text('Job Decline!')),
                    //     );
                    //   },
                    //   child: Container(
                    //       width: (MediaQuery.of(context).size.width / 2) -
                    //           SizeConstant.getHeightWithScreen(45),
                    //       height: SizeConstant.getHeightWithScreen(40),
                    //       decoration: BoxDecoration(
                    //         border: Border.all(
                    //           width: 1,
                    //           color: ColorConstant.primaryColor,
                    //         ),
                    //         borderRadius: BorderRadius.circular(
                    //             SizeConstant.getHeightWithScreen(10)),
                    //       ),
                    //       child: Center(
                    //         child: Text(
                    //           "Decline Job",
                    //           style: TextStyle(
                    //             fontSize: SizeConstant.mediumFont,
                    //             fontWeight: FontWeight.w500,
                    //             color: ColorConstant.primaryColor,
                    //           ),
                    //         ),
                    //       )),
                    // ),
                    // SizedBox(
                    //   width: SizeConstant.getHeightWithScreen(10),
                    // ),
                    Expanded(
                      child: VentasPrimaryButton(
                        onTap: () {
                          updateJobStatus(
                              widget.job.id.toString(), "Completed");
                        },
                        label: "Accept Job",
                        textColor: ColorConstant.white,
                        borderRadius: 10,
                        textSize: SizeConstant.mediumFont,
                        weight: FontWeight.w500,
                        btnHeight: SizeConstant.getHeightWithScreen(55),
                        btnWidth: (MediaQuery.of(context).size.width / 2) -
                            SizeConstant.getHeightWithScreen(45),
                      ),
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
