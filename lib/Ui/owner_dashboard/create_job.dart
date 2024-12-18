import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:justconnect/Ui/owner_dashboard/owner_dashboard.dart';
import 'package:justconnect/Ui/signup.dart';
import 'package:justconnect/constants/color_constants.dart';
import 'package:justconnect/constants/size_constants.dart';
import 'package:justconnect/constants/strings.dart';
import 'package:justconnect/controller/owner_controller.dart';
import 'package:justconnect/model/job_list.dart';
import 'package:justconnect/widget/common_button.dart';
import 'package:justconnect/widget/commontextInputfield.dart';
import 'package:justconnect/widget/helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateJob extends StatefulWidget {
  final String ownerImage;
  final String ownerName;
  const CreateJob(
      {super.key, required this.ownerImage, required this.ownerName});

  @override
  State<CreateJob> createState() => _CreateJobState();
}

class _CreateJobState extends State<CreateJob> {
  final OwnerController _ownerController = Get.put(OwnerController());
  final storage = GetStorage();
  String ownerId = "";
  String ownerPhoneNumber = "";
  String flatNo = "";
  String name = "";
  String imageUrl = "";
  File? _selfieImage; // To store the captured image
  final ImagePicker _picker = ImagePicker();
  List<String> resultId = [];
  String jobResult = "";
  List<JobList> jobList = [];
  Future<void> _takeSelfie() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera, // Use camera for selfie
      preferredCameraDevice: CameraDevice.front, // Front camera for selfies
    );
    if (image != null) {
      setState(() {
        _selfieImage = File(image.path);
      });
      try {
        List<int> imageBytes = await _selfieImage!.readAsBytes();
        // Convert bytes to Base64 string
        imageUrl = base64Encode(imageBytes); // Store the image file
      } catch (e) {
        debugPrint('Error converting image to Base64: $e');
        return null;
      }
    }
  }

  Future<void> fetchAllUsers() async {
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

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAllUsers();
      setState(() {
        name = storage.read('Name');
        imageUrl = storage.read('ImageUrl') ?? "";
        _ownerController.nameController.text = name;
      });
    });

    super.initState();
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

  // Future<void> _requestCameraPermission() async {
  //   var status = await Permission.camera.status;

  //   if (status.isPermanentlyDenied) {
  //     openAppSettings(); // This function navigates the user to app settings
  //     return;
  //   }
  //   if (!status.isGranted) {
  //     // Request the permission if not already granted
  //     status = await Permission.camera.request();
  //   }

  //   if (status.isGranted) {
  //     _takeSelfie(); // Call the function to capture an image if permission is granted
  //   } else if (status.isDenied || status.isPermanentlyDenied) {
  //     // Show a dialog or handle permission denial
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //           content: Text("Camera permission is required to take selfies.")),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: ColorConstant.white,
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).viewPadding.top,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConstant.getHeightWithScreen(15),
                  top: SizeConstant.topPadding,
                  right: SizeConstant.getHeightWithScreen(15)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                      Strings.createJob,
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
          //  SizedBox(height: SizeConstant.getHeightWithScreen(20)),
            // Container(
            //   width: SizeConstant.getHeightWithScreen(80),
            //   height: SizeConstant.getHeightWithScreen(80),
            //   decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     border: Border.all(
            //       color: ColorConstant.primaryColor,
            //       width: SizeConstant.getHeightWithScreen(1),
            //     ),
            //   ),
            //   child: GestureDetector(
            //     onTap: () {
            //      // _requestCameraPermission();
            //     },
            //     child: CircleAvatar(
            //       radius: 50, // Size of the avatar
            //       backgroundImage: _selfieImage != null
            //           ? FileImage(_selfieImage!) // Display captured selfie
            //           : null,
            //       child: _selfieImage == null
            //           ? const Icon(
            //               Icons.camera_alt,
            //               size: 40,
            //               color: Colors.grey,
            //             )
            //           : null, // Show a camera icon if no selfie is taken
            //     ),
            //   ),
            // ),
           
            SizedBox(height: SizeConstant.getHeightWithScreen(20)),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConstant.horizontalPadding),
              child: CommonTextInputField(
                textInputType: TextInputType.text,
                showLabel: false,
                height: SizeConstant.getHeightWithScreen(50),
                controller: _ownerController.titleController,
                hintText: "Enter Title.",
                isAteriskRequired: false,
                enableInteractiveSelection: false,
                onChanged: (p0) {
                  setState(() {});
                },
              ),
            ),
            SizedBox(height: SizeConstant.getHeightWithScreen(10)),
             Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConstant.horizontalPadding),
              child: CommonTextInputField(
                textInputType: TextInputType.text,
                showLabel: false,
                height: SizeConstant.getHeightWithScreen(50),
                controller: _ownerController.desController,
                hintText: "Enter Description.",
                isAteriskRequired: false,
                enableInteractiveSelection: false,
                onChanged: (p0) {
                  setState(() {});
                },
              ),
            ),
            SizedBox(height: SizeConstant.getHeightWithScreen(10)),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConstant.horizontalPadding),
              child: GestureDetector(
                onTap: () async {
                  await selectDate(_ownerController.dateController, (value) {});
                  setState(() {});
                },
                child: Container(
                  height: SizeConstant.getHeightWithScreen(50),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: ColorConstant.tfDisabledBorderColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.only(
                    left: SizeConstant.getHeightWithScreen(16),
                    top: SizeConstant.getHeightWithScreen(4),
                    bottom: SizeConstant.getHeightWithScreen(4),
                  ),
                  child: AbsorbPointer(
                    child: TextField(
                      readOnly: true,
                      controller: _ownerController.dateController,
                      style: TextStyle(
                        color: ColorConstant.tfTextColor,
                        fontSize: SizeConstant.smallFont,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Expected Date",
                          suffixIcon: Icon(Icons.calendar_today_rounded,
                              color: ColorConstant.grey7,
                              size: SizeConstant.getHeightWithScreen(20)),
                          labelStyle: TextStyle(
                            color: ColorConstant.textFieldHintColor,
                            fontSize: SizeConstant.smallFont,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: SizeConstant.getHeightWithScreen(10)),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConstant.horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () {
                      _showModal(jobList);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConstant.getHeightWithScreen(17)),
                      height: SizeConstant.getHeightWithScreen(55),
                      decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                              SizeConstant.getHeightWithScreen(18)),
                          border: Border.all(
                              color: Colors.purple.withOpacity(0.1),
                              width: SizeConstant.getHeightWithScreen(0.1))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Icon(
                          //   Icons.work, // Replace with your desired icon
                          //   size: SizeConstant.getHeightWithScreen(
                          //       20), // Adjust icon size
                          // ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Maid Type",
                                style: TextStyle(
                                    fontSize: SizeConstant.mediumFont,
                                    color: ColorConstant.black6,
                                    fontFamily: "Poppins-Regular",
                                    fontWeight: FontWeight.w300),
                              ),
                              Text(
                                jobResult,
                                style: TextStyle(
                                    fontSize: SizeConstant.smallFont,
                                    color: ColorConstant.black3,
                                    fontFamily: "Poppins-Medium",
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_drop_down, // Use a down arrow icon
                            size: SizeConstant.getHeightWithScreen(
                                16), // Set size dynamically
                            color: Colors.black, // Optional: Set color
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConstant.getHeightWithScreen(10)),
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //       horizontal: SizeConstant.horizontalPadding),
            //   child: CommonTextInputField(
            //     textInputType: TextInputType.text,
            //     showLabel: false,
            //     isDisabled: true,
            //     height: SizeConstant.getHeightWithScreen(50),
            //     controller: _ownerController.nameController,
            //     hintText: "Enter Name",
            //     isAteriskRequired: false,
            //     enableInteractiveSelection: false,
            //     onChanged: (p0) {
            //       setState(() {});
            //     },
            //   ),
            // ),
           // SizedBox(height: SizeConstant.getHeightWithScreen(20)),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConstant.horizontalPadding),
              child: CommonButton(
                  bgColor: ColorConstant.outletButtonColor,
                  btnHeight: SizeConstant.getHeightWithScreen(48),
                  onTap: () async {
                    ownerId = storage.read('UserId');
                    ownerPhoneNumber = storage.read('phone_number');
                    flatNo = storage.read('FlatNo') ?? "";
                    if (_ownerController.titleController.text.trim().isEmpty ||
                        _ownerController.desController.text.trim().isEmpty ||
                        _ownerController.dateController.text.trim().isEmpty ||
                        jobResult.trim().isEmpty ||
                        imageUrl.isEmpty) {
                      showDownloadSnackbar("Please enter full details");
                    } else {
                      try {
                        Helper.progressDialog(context, "Loading...");
                        // Sign in with Supabase
                        final response = await Supabase.instance.client
                            .from('job_create_list') // Your table name
                            .insert({
                          'owner_id': ownerId,
                          'owner_name': _ownerController.nameController.text.trim(),
                          'flat_no':   flatNo,
                          'date': _ownerController.dateController.text.trim(),
                          'job_type': jsonEncode(resultId),
                          'job_status': "Active",
                          'owner_profile_image': imageUrl.trim(),
                          'phone_number': ownerPhoneNumber,
                          'title' : _ownerController.titleController.text.trim(),
                          'description' : _ownerController.desController.text.trim()
                        }).select();

                        showDownloadSnackbar("Job Create successful");
                        _ownerController.nameController.clear();
                        _ownerController.typeController.clear();
                        _ownerController.dateController.clear();
                        _ownerController.titleController.clear();
                        _ownerController.desController.clear();
                        setState(() {
                          jobResult = "";
                          resultId = [];
                          imageUrl = "";
                        });
                        Helper.close();
                        Get.off(() => const OwnerDashboard());
                      } on AuthException catch (e) {
                        Helper.close();
                        // Handle Supabase-specific authentication errors
                        showDownloadSnackbar("Login failed: ${e.message}");
                      } catch (e) {
                        Helper.close();
                        // Handle unexpected errors
                        showDownloadSnackbar("Unexpected error: $e");
                        print("$e");
                      } finally {
                        setState(() {
                          //_loading = false; // Reset loading state
                        });
                      }
                    }

                    // String pattern =
                    //     r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                    // RegExp regex = RegExp(pattern);
                    // if (!regex.hasMatch(emailController.text.trim())) {
                    //   Get.to(() => const Home());
                    // }
                  },
                  label: Strings.submit),
            ),
          ],
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
            JobSelectionModal(jobList: jobList, resultId: resultId));
    if (result != null) {
      //int index = int.parse(result);
      setState(() {
        jobResult = result.toString(); //jobList[index].jobName ?? "";
        resultId = result; //jobList[index].id.toString() ?? "";
      });
    }
  }

  Future<void> selectDate(
      TextEditingController controller, Function(String) onDateChanged) async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      onDateChanged(formatter.format(picked));
      controller.text = formatter.format(picked);
    }
  }
}
