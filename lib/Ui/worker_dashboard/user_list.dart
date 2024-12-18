import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:justconnect/Ui/job_detail_page.dart';
import 'package:justconnect/Ui/owner_dashboard/owner_dashboard.dart';
import 'package:justconnect/constants/strings.dart';
import 'package:justconnect/controller/worker_controller.dart';
import 'package:justconnect/model/user_details.dart';
import 'package:justconnect/widget/helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/color_constants.dart';
import '../../constants/size_constants.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _HomeState();
}

class _HomeState extends State<UserList> {
  final WorkerController _ownerController = Get.put(WorkerController());
  List<UserDetails> userList = [];
  final storage = GetStorage();
  String signUpType = "";
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        signUpType = storage.read('SignUpType');
        fetchAllUsers(signUpType);
      });
    });

    super.initState();
  }

  Future<void> fetchAllUsers(String signUpType) async {
    try {
      Helper.progressDialog(context, "Loading...");
      final response = await Supabase.instance.client
          .from('user') // Replace 'users' with your table name
          .select()
          .eq(
              'sign_up_type',
              signUpType.toString() == "Owner"
                  ? "Maid"
                  : "Owner"); // Fetch all rows

      if (response.isNotEmpty) {
        Helper.close();
        print('User List: $response');
        setState(() {
          userList = (response as List)
              .map((data) => UserDetails.fromJson(data))
              .toList();
        });
      } else {
        Helper.close();
        print('No users found.');
      }
    } catch (e) {
      Helper.close();
      print('Error fetching user list: $e');
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).viewPadding.top,
              ),
              // Wrap ListView.builder with Flexible or Expanded
              Padding(
                padding: EdgeInsets.only(
                    left: SizeConstant.horizontalPadding,
                    top: SizeConstant.topPadding,
                    right: SizeConstant.horizontalPadding),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: SizeConstant.getHeightWithScreen(35),
                        width: SizeConstant.getHeightWithScreen(35),
                        padding: EdgeInsets.only(
                            left: SizeConstant.getHeightWithScreen(12),
                            bottom: SizeConstant.getHeightWithScreen(10),
                            right: SizeConstant.getHeightWithScreen(9),
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
                        signUpType == "Owner" ? "Maid List" : "Owner List",
                        style: TextStyle(
                          color: ColorConstant.black.withOpacity(0.88),
                          fontSize: SizeConstant.largeFont,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              userList.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: userList.length,
                        itemBuilder: (context, index) {
                          final job = userList[index];
                          return GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => JobDetailPage(job: job),
                              //   ),
                              // );
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                top: SizeConstant.getHeightWithScreen(10),
                                bottom: SizeConstant.getHeightWithScreen(12),
                              ),
                              padding: EdgeInsets.only(
                                left: SizeConstant.getHeightWithScreen(10),
                                right: SizeConstant.getHeightWithScreen(12),
                                top: SizeConstant.getHeightWithScreen(10),
                                bottom: SizeConstant.getHeightWithScreen(12),
                              ),
                              decoration: BoxDecoration(
                                color: ColorConstant.white,
                                border: Border.all(
                                    color: ColorConstant.grey8, width: 2),
                                borderRadius: BorderRadius.all(Radius.circular(
                                    SizeConstant.getHeightWithScreen(15))),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorConstant.shadowColor,
                                    blurRadius: 6,
                                    blurStyle:
                                        BlurStyle.outer, //extend the shadow
                                  )
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 30.0,
                                    backgroundImage: job.imageUrl == null ||
                                            job.imageUrl.toString().isEmpty
                                        ? null // No background image (we will show the icon instead)
                                        : isBase64(job.imageUrl)
                                            ? MemoryImage(base64Decode(job
                                                .imageUrl
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
                                  SizedBox(
                                    width: SizeConstant.getHeightWithScreen(16),
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              job.name,
                                              style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontSize:
                                                    SizeConstant.mediumFont,
                                                fontWeight: FontWeight.w600,
                                                color: ColorConstant.black3,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: SizeConstant
                                                .getHeightWithScreen(5),
                                          ),
                                          // Icon(
                                          //   Icons.arrow_forward_ios,
                                          //   color: ColorConstant.primaryColor,
                                          //   size: SizeConstant
                                          //       .getHeightWithScreen(12),
                                          // ),
                                        ],
                                      ),
                                      signUpType == "Owner"
                                          ? Text(
                                              job.jobType.isEmpty ||
                                                      job.jobType == []
                                                  ? ""
                                                  : jobTypeConvert(job.jobType),
                                              style: TextStyle(
                                                overflow: TextOverflow.visible,
                                                fontSize:
                                                    SizeConstant.xSmallFont,
                                                fontWeight: FontWeight.w500,
                                                color: ColorConstant.grey26,
                                              ),
                                            )
                                          : const SizedBox(),
                                      signUpType == "Owner"
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: SizeConstant
                                                      .getHeightWithScreen(2),
                                                ),
                                                Text(
                                                  "Price : ${job.price == null ? "0" : job.price.toString()}",
                                                  style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontSize:
                                                        SizeConstant.xSmallFont,
                                                    fontWeight: FontWeight.w500,
                                                    color: ColorConstant.grey26,
                                                  ),
                                                ),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        job.city.toString(),
                                                        style: TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize: SizeConstant
                                                              .xSmallFont,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: ColorConstant
                                                              .grey26,
                                                        ),
                                                      ),
                                                      Text(
                                                        job.availableTime
                                                            .toString(),
                                                        style: TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize: SizeConstant
                                                              .xSmallFont,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: ColorConstant
                                                              .grey26,
                                                        ),
                                                      ),
                                                    ])
                                              ],
                                            )
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: SizeConstant
                                                      .getHeightWithScreen(4),
                                                ),
                                                Text(
                                                  "Flat No : ${job.flatNo}",
                                                  style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontSize:
                                                        SizeConstant.xSmallFont,
                                                    fontWeight: FontWeight.w500,
                                                    color: ColorConstant.grey26,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: SizeConstant
                                                      .getHeightWithScreen(0),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      job.phoneNumber
                                                          .toString(),
                                                      style: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: SizeConstant
                                                            .xSmallFont,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: ColorConstant
                                                            .grey26,
                                                      ),
                                                    ),
                                                    Row(children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          _makePhoneCall(job
                                                              .phoneNumber
                                                              .toString());
                                                        },
                                                        child: Image(
                                                          image: const AssetImage(
                                                              "assets/images/phone.png"),
                                                          height: SizeConstant
                                                              .getHeightWithScreen(
                                                                  24),
                                                          width: SizeConstant
                                                              .getHeightWithScreen(
                                                                  24),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: SizeConstant
                                                            .getHeightWithScreen(
                                                                10),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          _launchWhatsApp(job
                                                              .phoneNumber
                                                              .toString());
                                                        },
                                                        child: Image(
                                                          image:
                                                              const AssetImage(
                                                            "assets/images/whatsapp.png",
                                                          ),
                                                          height: SizeConstant
                                                              .getHeightWithScreen(
                                                                  24),
                                                          width: SizeConstant
                                                              .getHeightWithScreen(
                                                                  24),
                                                        ),
                                                      ),
                                                    ]),
                                                  ],
                                                )
                                              ],
                                            )
                                    ],
                                  ))
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : const Expanded(
                      child: Center(
                        child: Text("No data Found"),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

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

  String jobTypeConvert(String job) {
    List<String> jobTypes = List<String>.from(jsonDecode(job));
    String jobTypesString = jobTypes.join(', ');
    return jobTypesString;
  }
}
