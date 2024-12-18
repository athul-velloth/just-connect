import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:intl/intl.dart';
import 'package:justconnect/Ui/owner_dashboard/create_job.dart';
import 'package:justconnect/Ui/owner_dashboard/job_card.dart';
import 'package:justconnect/Ui/owner_dashboard/job_details.dart';
import 'package:justconnect/Ui/worker_dashboard/home.dart';
import 'package:justconnect/Ui/worker_dashboard/user_list.dart';
import 'package:justconnect/constants/color_constants.dart';
import 'package:justconnect/constants/size_constants.dart';
import 'package:justconnect/constants/strings.dart';
import 'package:justconnect/controller/owner_controller.dart';
import 'package:justconnect/model/job_details_model.dart';
import 'package:justconnect/model/user_details.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OwnerDashboard extends StatefulWidget {
  const OwnerDashboard({super.key});

  @override
  State<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  final OwnerController _ownerController = Get.put(OwnerController());
  List<JobDetailsModel> userList = [];
  @override
  void initState() {
    fetchAllUsers();
    super.initState();
  }

  Future<void> fetchAllUsers() async {
    try {
      final response = await Supabase.instance.client
          .from('job_create_list') // Replace 'users' with your table name
          .select()
          .eq('job_status', 'Active'); // Fetch all rows

      if (response.isNotEmpty) {
        print('User List: $response');
        setState(() {
          userList = (response as List)
              .map((data) => JobDetailsModel.fromJson(data))
              .toList();
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: ColorConstant.white,
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorConstant.primaryColor,
          onPressed: () {
            Get.to(() => const CreateJob(
                  ownerName: "John Doe",
                  ownerImage:
                      "https://images.pexels.com/photos/2128807/pexels-photo-2128807.jpeg?auto=compress&cs=tinysrgb&w=800",
                ));
          },
          child: Icon(
            Icons.add,
            color: ColorConstant.white,
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).viewPadding.top,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConstant.horizontalPadding,
                  top: SizeConstant.topPadding,
                  right: SizeConstant.horizontalPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Strings.ownerDashboard,
                    style: TextStyle(
                      color: ColorConstant.black.withOpacity(0.88),
                      fontSize: SizeConstant.largeFont,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const UserList());
                    },
                    child: Icon(
                      Icons.exit_to_app,
                      size: SizeConstant.getHeightWithScreen(26),
                      color: ColorConstant.black.withOpacity(0.88),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConstant.getHeightWithScreen(20)),
            userList.isNotEmpty
                ? Expanded(
                    child: ListView.separated(
                        padding: EdgeInsets.zero,
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: SizeConstant.getHeightWithScreen(10),
                          );
                        },
                        shrinkWrap: true,
                        itemCount: userList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                 Get.to(
                                     () => JobDetails(job: userList[index]));
                              },
                              child: JobCard(model: userList[index]));
                        }),
                  )
                : const Expanded(
                    child: Center(
                      child: Text("No data Found"),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
