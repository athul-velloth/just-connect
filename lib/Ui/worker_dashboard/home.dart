import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:justconnect/Ui/job_detail_page.dart';
import 'package:justconnect/Ui/owner_dashboard/owner_dashboard.dart';
import 'package:justconnect/Ui/user_profile.dart';
import 'package:justconnect/Ui/worker_dashboard/user_list.dart';
import 'package:justconnect/constants/strings.dart';
import 'package:justconnect/controller/worker_controller.dart';
import 'package:justconnect/model/job_details_model.dart';
import 'package:justconnect/model/job_list.dart';
import 'package:justconnect/model/user_details.dart';
import 'package:justconnect/widget/helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../constants/color_constants.dart';
import '../../constants/size_constants.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final WorkerController _ownerController = Get.put(WorkerController());
  List<JobDetailsModel> userList = [];
  List<String> resultId = [];
  String jobResult = "";
  String imageUrl = "";
  String name = "";
  List<JobList> jobList = [];
  final storage = GetStorage();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAllUsers();
      fetchAllJob();
      setState(() {
        name = storage.read('Name');
        imageUrl = storage.read('ImageUrl') ?? "";
      });
    });

    super.initState();
  }

  Future<void> fetchAllUsers() async {
    try {
      Helper.progressDialog(context, "Loading...");
      // final response = await Supabase.instance.client
      //     .from('job_create_list') // Replace 'users' with your table name
      //     .select()
      //     .eq('job_status', 'Active'); // Fetch all rows
// Fetch all rows
      dynamic response = "";
      if (jobResult.isNotEmpty) {
        response = await Supabase.instance.client
            .from('job_create_list') // Replace 'users' with your table name
            .select()
            .eq('job_status', 'Active')
            .filter('job_type', 'eq', jsonEncode(resultId));
      } else {
        response = await Supabase.instance.client
            .from('job_create_list') // Replace 'users' with your table name
            .select()
            .eq('job_status', 'Active');
      }
      // Fe
      if (response.isNotEmpty) {
        Helper.close();
        print('User List: $response');
        setState(() {
          userList = (response as List)
              .map((data) => JobDetailsModel.fromJson(data))
              .toList();
        });
      } else {
        setState(() {
          userList.clear();
        });
        Helper.close();
        print('No users found.');
      }
    } catch (e) {
      Helper.close();
      print('Error fetching user list: $e');
    }
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
        });
      } else {
        print('No users found.');
      }
    } catch (e) {
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

  String jobTypeConvert(String job) {
    List<String> jobTypes = List<String>.from(jsonDecode(job));
    String jobTypesString = jobTypes.join(', ');
    return jobTypesString;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: ColorConstant.white,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(() => const UserProfile());
                          },
                          child: CircleAvatar(
                            radius: 20.0,
                            backgroundImage: imageUrl == null ||
                                    imageUrl.toString().isEmpty
                                ? null // No background image (we will show the icon instead)
                                : isBase64(imageUrl)
                                    ? MemoryImage(base64Decode(imageUrl
                                        .toString())) // If imageUrl is base64
                                    : NetworkImage(imageUrl
                                        .toString()), // If imageUrl is a URL
                            child: imageUrl == null ||
                                    imageUrl.toString().isEmpty
                                ? const Icon(Icons.person,
                                    size: 40,
                                    color: Colors
                                        .white) // Show person icon when image is missing
                                : null, // Don't show icon if there's an image
                          ),
                        ),
                        SizedBox(
                          width: SizeConstant.getHeightWithScreen(15),
                        ),
                        Text(
                          name,
                          style: TextStyle(
                            color: ColorConstant.black.withOpacity(0.88),
                            fontSize: SizeConstant.largeFont,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ]),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showModal(jobList);
                            },
                            child: Icon(
                              Icons.filter_list,
                              size: SizeConstant.getHeightWithScreen(26),
                              color: ColorConstant.black.withOpacity(0.88),
                            ),
                          ),
                          SizedBox(
                            width: SizeConstant.getHeightWithScreen(10),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const UserList());
                            },
                            child: Icon(
                              Icons.list_alt,
                              size: SizeConstant.getHeightWithScreen(26),
                              color: ColorConstant.black.withOpacity(0.88),
                            ),
                          ),
                        ],
                      )
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        JobDetailPage(job: job),
                                  ),
                                );
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
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          SizeConstant.getHeightWithScreen(
                                              15))),
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
                                      backgroundImage: job.ownerProfileImage ==
                                                  null ||
                                              job.ownerProfileImage
                                                  .toString()
                                                  .isEmpty
                                          ? null // No background image (we will show the icon instead)
                                          : isBase64(job.ownerProfileImage)
                                              ? MemoryImage(base64Decode(job
                                                  .ownerProfileImage
                                                  .toString())) // If imageUrl is base64
                                              : NetworkImage(job
                                                  .ownerProfileImage
                                                  .toString()), // If imageUrl is a URL
                                      child: job.ownerProfileImage == null ||
                                              job.ownerProfileImage
                                                  .toString()
                                                  .isEmpty
                                          ? const Icon(Icons.person,
                                              size: 40,
                                              color: Colors
                                                  .white) // Show person icon when image is missing
                                          : null, // Don't show icon if there's an image
                                    ),
                                    SizedBox(
                                      width:
                                          SizeConstant.getHeightWithScreen(16),
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
                                                job.date.toString(),
                                                style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize:
                                                      SizeConstant.xSmallFont,
                                                  fontWeight: FontWeight.w500,
                                                  color: ColorConstant.grey26,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: SizeConstant
                                                  .getHeightWithScreen(5),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              color: ColorConstant.primaryColor,
                                              size: SizeConstant
                                                  .getHeightWithScreen(12),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height:
                                              SizeConstant.getHeightWithScreen(
                                                  5),
                                        ),
                                        Text(
                                          job.ownerName,
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: SizeConstant.mediumFont,
                                            fontWeight: FontWeight.w600,
                                            color: ColorConstant.black3,
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                              SizeConstant.getHeightWithScreen(
                                                  4),
                                        ),
                                        Text(
                                          jobTypeConvert(job.jobType),
                                          style: TextStyle(
                                            overflow: TextOverflow.visible,
                                            fontSize: SizeConstant.xSmallFont,
                                            fontWeight: FontWeight.w500,
                                            color: ColorConstant.grey26,
                                          ),
                                        ),
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
      ),
    );
  }

  _showModal(List<JobList> jobList) async {
    final result = await showModalBottomSheet<List<String>>(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        builder: (context) =>
            JobFilterSelectionModal(jobList: jobList, resultId: resultId));
    if (result != null) {
      if (result.isEmpty) {
        setState(() {
          jobResult = "";
          resultId = [];
          fetchAllUsers();
        });
      } else {
        setState(() {
          jobResult = result.toString();
          resultId = result;
          fetchAllUsers();
        });
      }
    }
  }
}
