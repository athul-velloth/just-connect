import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:justconnect/Ui/owner_dashboard/create_job.dart';
import 'package:justconnect/Ui/owner_dashboard/job_card.dart';
import 'package:justconnect/Ui/owner_dashboard/job_details.dart';
import 'package:justconnect/Ui/user_profile.dart';
import 'package:justconnect/Ui/worker_dashboard/home.dart';
import 'package:justconnect/Ui/worker_dashboard/user_list.dart';
import 'package:justconnect/constants/color_constants.dart';
import 'package:justconnect/constants/size_constants.dart';
import 'package:justconnect/constants/strings.dart';
import 'package:justconnect/controller/owner_controller.dart';
import 'package:justconnect/main.dart';
import 'package:justconnect/model/job_details_model.dart';
import 'package:justconnect/model/job_list.dart';
import 'package:justconnect/model/user_details.dart';
import 'package:justconnect/widget/common_button.dart';
import 'package:justconnect/widget/helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OwnerDashboard extends StatefulWidget {
  const OwnerDashboard({super.key});

  @override
  State<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> with RouteAware {
  final OwnerController _ownerController = Get.put(OwnerController());
  List<JobDetailsModel> userList = [];
  List<String> resultId = [];
  String jobResult = "";
  List<JobList> jobList = [];
  String imageUrl = "";
  String name = "";
  String UserId = "";
  final storage = GetStorage();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        name = storage.read('Name');
        UserId = storage.read('UserId') ?? "";
        imageUrl = storage.read('ImageUrl') ?? "";
      });
      fetchAllUsers();
      fetchAllJob();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute<dynamic>? route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    super.didPopNext();
    fetchAllUsers();
    fetchAllJob();
  }

  Future<void> fetchAllUsers() async {
    try {
      Helper.progressDialog(context, "Loading...");
      dynamic response = "";
      if (jobResult.isNotEmpty) {
        response = await Supabase.instance.client
            .from('job_create_list') // Replace 'users' with your table name
            .select()
            .eq('job_status', 'Active')
            .eq('owner_id', UserId)
            .filter('job_type', 'eq', jsonEncode(resultId));
      } else {
        response = await Supabase.instance.client
            .from('job_create_list') // Replace 'users' with your table name
            .select()
            .eq('job_status', 'Active')
            .eq('owner_id', UserId);
      }
      // Fetch all rows

      if (response.isNotEmpty) {
        Helper.close();
        print('User List: $response');
        setState(() {
          userList = (response as List)
              .map((data) => JobDetailsModel.fromJson(data))
              .toList();
        });
      } else {
        Helper.close();
        setState(() {
          userList.clear();
        });
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
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
                          child: imageUrl == null || imageUrl.toString().isEmpty
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
      }
      setState(() {
        jobResult = result.toString();
        resultId = result;
        fetchAllUsers();
      });
    }
  }
}

class JobFilterSelectionModal extends StatefulWidget {
  final List<JobList> jobList;
  final List<String> resultId;

  const JobFilterSelectionModal(
      {super.key, required this.jobList, required this.resultId});

  @override
  State<JobFilterSelectionModal> createState() => _JobSelectionModalState();
}

class _JobSelectionModalState extends State<JobFilterSelectionModal> {
  String selectedRadioValue = 'any'.tr;
  String selectedNumber = "";
  List<String> selectedItems = [];
  @override
  void initState() {
    selectedItems = widget.resultId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: SizeConstant.getHeightWithScreen(50)),
          color: const Color(0xff757575),
          child: Container(
            padding: EdgeInsets.only(top: SizeConstant.getHeightWithScreen(5)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SizeConstant.getHeightWithScreen(30)),
                topRight: Radius.circular(SizeConstant.getHeightWithScreen(30)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(top: 0, left: 16, right: 10),
                      child: Text(
                        "Maid Filter",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Outfit",
                          fontWeight: FontWeight.w600,
                          fontSize: SizeConstant.mediumFont,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: ColorConstant.grey2,
                        size: SizeConstant.getHeightWithScreen(25),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 0, bottom: 27),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.jobList.length,
                    itemBuilder: (context, index) {
                      final job = widget.jobList[index];
                      final isSelected = selectedItems.contains(job.jobName);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedItems.remove(job.jobName); // Deselect
                            } else {
                              selectedItems.add(job.jobName); // Select
                            }
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            top: SizeConstant.getHeightWithScreen(10),
                            left: SizeConstant.getHeightWithScreen(15),
                            right: SizeConstant.getHeightWithScreen(15),
                          ),
                          padding: EdgeInsets.only(
                            left: SizeConstant.getHeightWithScreen(16),
                            right: SizeConstant.getHeightWithScreen(16),
                            top: SizeConstant.getHeightWithScreen(16),
                            bottom: SizeConstant.getHeightWithScreen(14),
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? ColorConstant.orange4
                                : ColorConstant.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: SizeConstant.getHeightWithScreen(1),
                              color: isSelected
                                  ? ColorConstant.white
                                  : ColorConstant.vibBgColor,
                            ),
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: isSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      selectedItems.add(job.jobName); // Select
                                    } else {
                                      selectedItems
                                          .remove(job.jobName); // Deselect
                                    }
                                  });
                                },
                                activeColor: ColorConstant.primaryColor,
                              ),
                              SizedBox(
                                width: SizeConstant.getHeightWithScreen(10),
                              ),
                              Text(
                                job.jobName,
                                style: TextStyle(
                                  fontSize: SizeConstant.mediumFont,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 60,
                )
              ],
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 6,
                  blurRadius: 6,
                  offset: const Offset(0, -3),
                ),
              ],
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: CommonButton(
                    btnHeight: SizeConstant.getHeightWithScreen(48),
                    onTap: () {
                      selectedItems.clear();
                      Navigator.pop(
                          context, selectedItems); // Return selected items
                    },
                    label: 'Clean',
                    bgColor: ColorConstant.paymentBtnColor,
                    textColor: ColorConstant.white,
                    borderColor: ColorConstant.white,
                  ),
                ),
                Expanded(
                  child: CommonButton(
                    btnHeight: SizeConstant.getHeightWithScreen(48),
                    onTap: () {
                      Navigator.pop(
                          context, selectedItems); // Return selected items
                    },
                    label: 'Filter',
                    bgColor: ColorConstant.paymentBtnColor,
                    textColor: ColorConstant.white,
                    borderColor: ColorConstant.white,
                  ),
                ),
              ],
            )),
      ),
    ]);
  }
}
