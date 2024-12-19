import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:justconnect/Ui/job_detail_page.dart';
import 'package:justconnect/Ui/owner_dashboard/owner_dashboard.dart';
import 'package:justconnect/Ui/worker_dashboard/maid_filter_bottomsheet.dart';
import 'package:justconnect/constants/strings.dart';
import 'package:justconnect/controller/worker_controller.dart';
import 'package:justconnect/model/job_list.dart';
import 'package:justconnect/model/location_list.dart';
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
  List<JobList> jobList = [];
  List<LocationList> locationList = [];
  List<UserDetails> filteredJobs = [];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        signUpType = storage.read('SignUpType');
        fetchAllUsers(signUpType);
        fetchAllJob();
        fetchAllLocation();
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
          _ownerController.userList.value = userList;
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

  Future<void> fetchAllJob() async {
    try {
      final response =
          await Supabase.instance.client.from('job_type_list').select();
      if (response.isNotEmpty) {
        print('User List: $response');
        setState(() {
          jobList =
              (response as List).map((data) => JobList.fromJson(data)).toList();
          _ownerController.jobList.value = jobList;
        });
      } else {
        print('No users found.');
      }
    } catch (e) {
      print('Error fetching user list: $e');
    }
  }

  Future<void> fetchAllLocation() async {
    try {
      final response =
          await Supabase.instance.client.from('location_list').select();
      if (response.isNotEmpty) {
        print('Location List: $response');
        setState(() {
          locationList = (response as List)
              .map((data) => LocationList.fromJson(data))
              .toList();
        _ownerController.locationList.value = locationList;
        });
      } else {
        print('No users found.');
      }
    } catch (e) {
      print('Error fetching user list: $e');
    }
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
                padding: EdgeInsets.only(top: SizeConstant.topPadding),
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
                    Spacer(),
                   signUpType == "Owner" ?  GestureDetector(
                      onTap: () {
                        MaidFilterBottomsheet()
                            .filterMultipleStatusBottomsheet(
                                context: context,
                                title: "filter",
                                jobList: jobList,
                                locationList: locationList,
                                onFilter: (jobType, price, location, time) {
                                  int maxPrice = 0;
                                  int minPrice = 0;

                                  // Price logic
                                  if (price != null && price.contains(' - ')) {
                                    List<String> priceRange = price
                                        .split(' - ')
                                        .map((e) => e.trim())
                                        .toList();
                                    if (priceRange.length == 2) {
                                      minPrice = int.tryParse(priceRange[0]) ??
                                          0; // Default to 0 if parsing fails
                                      maxPrice = int.tryParse(priceRange[1]) ??
                                          0; // Default to 0 if parsing fails
                                    }
                                  } else if (price != null &&
                                      price.contains('and Below')) {
                                    String priceString =
                                        price.split(' and Below')[0].trim();
                                    maxPrice = int.tryParse(priceString) ?? 0;
                                  } else if (price != null &&
                                      price.contains('and above')) {
                                    String priceString =
                                        price.split(' and above')[0].trim();
                                    minPrice = int.tryParse(priceString) ?? 0;
                                    maxPrice =
                                        100000000; // Arbitrary large number for "above" condition
                                  }

                                  // Filter logic
                                  setState(() {
                                    userList = _ownerController.userList.value
                                        .where((job) {
                                      bool matchesJobType = (jobType != null &&
                                              jobType.isNotEmpty)
                                          ? (job.jobType.contains(jobType ??
                                              '')) // If jobType is available, filter based on jobType
                                          : true; // Otherwise, ignore jobType in the filter

                                      bool matchesPrice =
                                          (price != null && price.isNotEmpty)
                                              ? (job.price != null) &&
                                                  job.price! >= minPrice &&
                                                  job.price! <= maxPrice
                                              : true;

                                      bool matchesLocation = (location !=
                                                  null &&
                                              location.isNotEmpty)
                                          ? (job.city ?? '').contains(location.trim() ??
                                              '') // Match location if provided
                                          : true; // Ignore location filter if it's empty or null

                                      bool matchesTime = (time != null &&
                                              time.isNotEmpty)
                                          ? (job.availableTime ?? '') ==
                                              time // If time is provided, match the time
                                          : true; // Otherwise, ignore time in the filter

                                      return matchesJobType &&
                                          matchesPrice &&
                                          matchesLocation &&
                                          matchesTime;
                                    }).toList();
                                  });

                                  print("object data   ${filteredJobs}");
                                },
                                onClear: () {
                                  setState(
                                    () {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((timeStamp) {
                                        fetchAllUsers(signUpType);
                                      });
                                    },
                                  );
                                });
                      },
                      child: Icon(
                        Icons.filter_list,
                        size: SizeConstant.getHeightWithScreen(26),
                        color: ColorConstant.black.withOpacity(0.88),
                      ),
                    ) : const SizedBox(),
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
                                                  "Price : ${job.price == 0 ? "-" : 'Rs.${job.price}/hr'}",
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
                                                      .getHeightWithScreen(4),
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
                                                    ]),
                                                SizedBox(
                                                  height: SizeConstant
                                                      .getHeightWithScreen(4),
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

  String jobTypeConvert(String job) {
    List<String> jobTypes = List<String>.from(jsonDecode(job));
    String jobTypesString = jobTypes.join(', ');
    return jobTypesString;
  }
}
