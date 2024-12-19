import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justconnect/Ui/login.dart';
import 'package:justconnect/controller/login_controller.dart';
import 'package:justconnect/model/job_list.dart';
import 'package:justconnect/model/location_list.dart';
import 'package:justconnect/widget/helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:time_range_picker/time_range_picker.dart';
import '../constants/color_constants.dart';
import '../constants/size_constants.dart';
import '../widget/commontextInputfield.dart';
import '../widget/common_button.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final LoginController _loginController = Get.put(LoginController());
  String _userType = 'Owner';
  File? _selfieImage; // To store the captured image
  final ImagePicker _picker = ImagePicker();
  String imageUrl = "";
  List<String> resultId = [];
  String jobResult = "";
  String timeResult = "";
  String cityResult = "";
  List<JobList> jobList = [];
  String resultlocationId = "";
  String resultTimeId = "";
  String locationResult = "";
  List<LocationList> locationList = [];
  TimeRange? timeRange;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  @override
  void initState() {
    fetchAllUsers();
    fetchAllLocation();
    super.initState();
  }

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
        imageUrl = base64Encode(imageBytes);
        // _uploadImage(_selfieImage); // Store the image file
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
        });
      } else {
        print('No users found.');
      }
    } catch (e) {
      print('Error fetching user list: $e');
    }
  }

  Future<void> _uploadImage(File? selfieImage) async {
    // Pick an image from gallery
    if (selfieImage == null) return;

    try {
      // Generate a file name with a timestamp
      final fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.png';

      // Upload the image to Supabase Storage
      final response = await Supabase.instance.client.storage
          .from('profileImage') // Replace with your bucket name
          .upload(fileName, selfieImage);
      // Get the public URL of the image
      // imageUrl = Supabase.instance.client.storage
      //     .from('profileImage')
      //     .getPublicUrl(fileName);
      showDownloadSnackbar('Image uploaded successfully: $imageUrl');
    } catch (e) {
      print('Error: $e');
      showDownloadSnackbar('Error uploading image: $e');
    }
  }

  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.status;

    if (status.isPermanentlyDenied) {
      openAppSettings(); // This function navigates the user to app settings
      return;
    }
    if (!status.isGranted) {
      // Request the permission if not already granted
      status = await Permission.camera.request();
    }

    if (status.isGranted) {
      _takeSelfie(); // Call the function to capture an image if permission is granted
    } else if (status.isDenied || status.isPermanentlyDenied) {
      // Show a dialog or handle permission denial
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Camera permission is required to take selfies.")),
      );
    }
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

  /// Define disabled time ranges manually
  TimeRange _getDisabledTimeRanges() {
    return TimeRange(
      startTime: const TimeOfDay(hour: 0, minute: 0), // Midnight to 8:00 AM
      endTime: const TimeOfDay(hour: 8, minute: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const SizedBox(height: 60.0),
                  const Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Create your account",
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  )
                ],
              ),
              SizedBox(height: SizeConstant.getHeightWithScreen(20)),
              GestureDetector(
                onTap: () {
                  _requestCameraPermission();
                },
                child: CircleAvatar(
                  radius: 50, // Size of the avatar
                  backgroundImage: _selfieImage != null
                      ? FileImage(_selfieImage!) // Display captured selfie
                      : null,
                  child: _selfieImage == null
                      ? const Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Colors.grey,
                        )
                      : null, // Show a camera icon if no selfie is taken
                ),
              ),
              SizedBox(height: SizeConstant.getHeightWithScreen(5)),
              Center(
                child: Text(
                  'Take Selfie',
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: SizeConstant.largeFont,
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.black,
                  ),
                ),
              ),
              SizedBox(height: SizeConstant.getHeightWithScreen(20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _userType = 'Owner';
                          _loginController.nameController.clear();
                          _loginController.emailController.clear();
                          _loginController.mobileNoController.clear();
                          _loginController.faltNoController.clear();
                          _loginController.passwordController.clear();
                          _loginController.confirmPasswordController.clear();
                          _loginController.typeController.clear();
                          _loginController.priceController.clear();
                          _loginController.cityController.clear();
                          _loginController.timeController.clear();
                          jobResult = "";
                          timeResult = "";
                          resultTimeId = "";
                          resultId = [];
                          locationResult = "";
                          resultlocationId = "";
                          imageUrl = "";
                          startTime = null;
                          endTime = null;
                          _selfieImage = null;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _userType == 'Owner'
                            ? Colors.blue
                            : Colors.white, // Change color
                        foregroundColor: _userType == 'Owner'
                            ? Colors.white
                            : Colors.black, // Text color
                      ),
                      child: const Text('Owner'),
                    ),
                  ),
                  const SizedBox(width: 8), // Add space between buttons
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _userType = 'Maid';
                          _loginController.nameController.clear();
                          _loginController.emailController.clear();
                          _loginController.mobileNoController.clear();
                          _loginController.faltNoController.clear();
                          _loginController.passwordController.clear();
                          _loginController.confirmPasswordController.clear();
                          _loginController.typeController.clear();
                          _loginController.priceController.clear();
                          _loginController.cityController.clear();
                          _loginController.timeController.clear();
                          jobResult = "";
                          timeResult = "";
                          resultTimeId = "";
                          resultId = [];
                          imageUrl = "";
                          locationResult = "";
                          resultlocationId = "";
                          startTime = null;
                          endTime = null;
                          _selfieImage = null;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _userType == 'Maid'
                            ? Colors.blue
                            : Colors.white, // Change color
                        foregroundColor: _userType == 'Maid'
                            ? Colors.white
                            : Colors.black, // Text color
                      ),
                      child: const Text('Maid'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConstant.getHeightWithScreen(20)),
              Column(
                children: <Widget>[
                  TextField(
                    controller: _loginController.nameController,
                    decoration: InputDecoration(
                        hintText: "Enter Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none),
                        fillColor: Colors.purple.withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.person)),
                  ),
                  SizedBox(height: SizeConstant.getHeightWithScreen(10)),
                  TextField(
                    controller: _loginController.emailController,
                    decoration: InputDecoration(
                        hintText: _userType == "Owner"
                            ? "Enter Email"
                            : "Enter Username",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none),
                        fillColor: Colors.purple.withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.email)),
                  ),
                  SizedBox(height: SizeConstant.getHeightWithScreen(10)),
                  TextField(
                    controller: _loginController.mobileNoController,
                    decoration: InputDecoration(
                        hintText: "Enter Mobile No.",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none),
                        fillColor: Colors.purple.withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.phone)),
                  ),
                  SizedBox(
                      height: SizeConstant.getHeightWithScreen(
                          _userType == "Owner" ? 10 : 0)),
                  _userType == "Owner"
                      ? TextField(
                          controller: _loginController.faltNoController,
                          decoration: InputDecoration(
                              hintText: "Enter Flat No.",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor: Colors.purple.withOpacity(0.1),
                              filled: true,
                              prefixIcon: const Icon(Icons.home)),
                        )
                      : const SizedBox(),
                  SizedBox(
                      height: SizeConstant.getHeightWithScreen(
                          _userType == "Owner" ? 0 : 10)),
                  _userType == "Owner"
                      ? const SizedBox()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showModal(jobList);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        SizeConstant.getHeightWithScreen(17)),
                                height: SizeConstant.getHeightWithScreen(55),
                                decoration: BoxDecoration(
                                    color: Colors.purple.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(
                                        SizeConstant.getHeightWithScreen(18)),
                                    border: Border.all(
                                        color: Colors.purple.withOpacity(0.1),
                                        width: SizeConstant.getHeightWithScreen(
                                            0.1))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Icon(
                                    //   Icons
                                    //       .work, // Replace with your desired icon
                                    //   size: SizeConstant.getHeightWithScreen(
                                    //       20), // Adjust icon size
                                    // ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                      Icons
                                          .arrow_drop_down, // Use a down arrow icon
                                      size: SizeConstant.getHeightWithScreen(
                                          16), // Set size dynamically
                                      color:
                                          Colors.black, // Optional: Set color
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                  _userType == "Maid"
                      ? Column(
                          children: [
                            SizedBox(
                                height: SizeConstant.getHeightWithScreen(10)),
                            TextField(
                              keyboardType: TextInputType.number,
                              controller: _loginController.priceController,
                              decoration: InputDecoration(
                                  hintText: "Enter Price per hour.",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: BorderSide.none),
                                  fillColor: Colors.purple.withOpacity(0.1),
                                  filled: true,
                                  prefixIcon: const Icon(Icons.price_change)),
                            ),
                            SizedBox(
                                height: SizeConstant.getHeightWithScreen(10)),
                            // TextField(
                            //   keyboardType: TextInputType.text,
                            //   controller: _loginController.cityController,
                            //   decoration: InputDecoration(
                            //       hintText: "Enter city",
                            //       border: OutlineInputBorder(
                            //           borderRadius: BorderRadius.circular(18),
                            //           borderSide: BorderSide.none),
                            //       fillColor: Colors.purple.withOpacity(0.1),
                            //       filled: true,
                            //       prefixIcon: const Icon(Icons.location_city)),
                            // ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _showLocationModal(locationList);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            SizeConstant.getHeightWithScreen(
                                                17)),
                                    height:
                                        SizeConstant.getHeightWithScreen(55),
                                    decoration: BoxDecoration(
                                        color: Colors.purple.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(
                                            SizeConstant.getHeightWithScreen(
                                                18)),
                                        border: Border.all(
                                            color:
                                                Colors.purple.withOpacity(0.1),
                                            width: SizeConstant
                                                .getHeightWithScreen(0.1))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Icon(
                                        //   Icons
                                        //       .work, // Replace with your desired icon
                                        //   size: SizeConstant.getHeightWithScreen(
                                        //       20), // Adjust icon size
                                        // ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "City",
                                              style: TextStyle(
                                                  fontSize:
                                                      SizeConstant.mediumFont,
                                                  color: ColorConstant.black6,
                                                  fontFamily: "Poppins-Regular",
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            Text(
                                              cityResult,
                                              style: TextStyle(
                                                  fontSize:
                                                      SizeConstant.smallFont,
                                                  color: ColorConstant.black3,
                                                  fontFamily: "Poppins-Medium",
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons
                                              .arrow_drop_down, // Use a down arrow icon
                                          size:
                                              SizeConstant.getHeightWithScreen(
                                                  16), // Set size dynamically
                                          color: Colors
                                              .black, // Optional: Set color
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height: SizeConstant.getHeightWithScreen(10)),
                            InkWell(
                                onTap: () async {
                                  timeRange = await showTimeRangePicker(
                                    context: context,
                                    start: const TimeOfDay(hour: 8, minute: 0), // Default start selection
                                    end: const TimeOfDay(hour: 17, minute: 0), // Default end selection
                                    disabledTime: _getDisabledTimeRanges(),
                                    disabledColor: Colors.grey.withOpacity(0.5), // Optional: visually indicate disabled times
                                    interval: const Duration(minutes: 15), // Optional: 15-minute intervals
                                    use24HourFormat: false, // Optional: 12-hour format
                                  );
                                  print(
                                      "result ${timeRange?.startTime} to${timeRange?.endTime}");
                                  if (timeRange != null) {
                                    setState(() {
                                      startTime = timeRange?.startTime;
                                      endTime = timeRange?.endTime;
                                      _loginController.timeController.text =
                                          "${formatTime(startTime)} - ${formatTime(endTime)}";
                                    });
                                  }
                                },
                                child: Container(
                                  width: SizeConstant.getHeightWithScreen(500),
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          SizeConstant.getHeightWithScreen(17),
                                      vertical:
                                          SizeConstant.getHeightWithScreen(5)),
                                  height: SizeConstant.getHeightWithScreen(55),
                                  decoration: BoxDecoration(
                                      color: Colors.purple.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(
                                          SizeConstant.getHeightWithScreen(18)),
                                      border: Border.all(
                                          color: Colors.purple.withOpacity(0.1),
                                          width:
                                              SizeConstant.getHeightWithScreen(
                                                  0.1))),
                                  child: Text(
                                    'Time Range \n${formatTime(startTime)} ${formatTime(endTime)}',
                                  ),
                                )),
                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.stretch,
                            //   children: [
                            //     GestureDetector(
                            //       onTap: () {
                            //         _showTimeModal(jobList);
                            //       },
                            //       child: Container(
                            //         padding: EdgeInsets.symmetric(
                            //             horizontal:
                            //             SizeConstant.getHeightWithScreen(
                            //                 17)),
                            //         height:
                            //         SizeConstant.getHeightWithScreen(55),
                            //         decoration: BoxDecoration(
                            //             color: Colors.purple.withOpacity(0.1),
                            //             borderRadius: BorderRadius.circular(
                            //                 SizeConstant.getHeightWithScreen(
                            //                     18)),
                            //             border: Border.all(
                            //                 color:
                            //                 Colors.purple.withOpacity(0.1),
                            //                 width: SizeConstant
                            //                     .getHeightWithScreen(0.1))),
                            //         child: Row(
                            //           mainAxisAlignment:
                            //           MainAxisAlignment.spaceBetween,
                            //           children: [
                            //             // Icon(
                            //             //   Icons
                            //             //       .work, // Replace with your desired icon
                            //             //   size: SizeConstant.getHeightWithScreen(
                            //             //       20), // Adjust icon size
                            //             // ),
                            //             Column(
                            //               crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //               mainAxisAlignment:
                            //               MainAxisAlignment.center,
                            //               children: [
                            //                 Text(
                            //                   "Time",
                            //                   style: TextStyle(
                            //                       fontSize:
                            //                       SizeConstant.mediumFont,
                            //                       color: ColorConstant.black6,
                            //                       fontFamily: "Poppins-Regular",
                            //                       fontWeight: FontWeight.w300),
                            //                 ),
                            //                 Text(
                            //                   timeResult,
                            //                   style: TextStyle(
                            //                       fontSize:
                            //                       SizeConstant.smallFont,
                            //                       color: ColorConstant.black3,
                            //                       fontFamily: "Poppins-Medium",
                            //                       fontWeight: FontWeight.w500),
                            //                 ),
                            //               ],
                            //             ),
                            //             Icon(
                            //               Icons
                            //                   .arrow_drop_down, // Use a down arrow icon
                            //               size:
                            //               SizeConstant.getHeightWithScreen(
                            //                   16), // Set size dynamically
                            //               color: Colors
                            //                   .black, // Optional: Set color
                            //             )
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        )
                      : const SizedBox(),
                  SizedBox(height: SizeConstant.getHeightWithScreen(10)),
                  TextField(
                    controller: _loginController.passwordController,
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
                  SizedBox(height: SizeConstant.getHeightWithScreen(10)),
                  TextField(
                    controller: _loginController.confirmPasswordController,
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none),
                      fillColor: Colors.purple.withOpacity(0.1),
                      filled: true,
                      prefixIcon: const Icon(Icons.password),
                    ),
                    obscureText: true,
                  ),
                ],
              ),
              SizedBox(height: SizeConstant.getHeightWithScreen(40)),
              CommonButton(
                  bgColor: ColorConstant.outletButtonColor,
                  btnHeight: SizeConstant.getHeightWithScreen(55),
                  borderRadius: SizeConstant.getHeightWithScreen(20),
                  onTap: () async {
                    final email = _loginController.emailController.text.trim();
                    final password =
                        _loginController.passwordController.text.trim();
                    String pattern =
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                    RegExp regex = RegExp(pattern);
                    if (_loginController.nameController.text.isEmpty ||
                        _loginController.nameController.text.length < 3) {
                      // Show error if fields are empty
                      showDownloadSnackbar("Please enter the name");
                    } else if (_userType == "Owner" &&
                        !regex.hasMatch(
                            _loginController.emailController.text.trim())) {
                      showDownloadSnackbar("Please enter the valid email");
                    } else if (_userType == "Maid" &&
                        (_loginController.emailController.text.trim().isEmpty ||
                            _loginController.emailController.text.length < 3)) {
                      showDownloadSnackbar("Please enter the valid username");
                    } else if (_loginController.mobileNoController.text
                            .trim()
                            .length <
                        10) {
                      showDownloadSnackbar("Please enter the valid number");
                    } else if (_userType == "Owner" &&
                        _loginController.faltNoController.text.trim().isEmpty) {
                      showDownloadSnackbar("Please enter the flat no");
                    } else if (_userType == "Maid" &&
                        jobResult.trim().isEmpty) {
                      showDownloadSnackbar("Please enter the job type");
                    } else if (_userType == "Maid" &&
                        _loginController.priceController.text.trim().isEmpty) {
                      showDownloadSnackbar("Please enter your per hour price");
                    } else if (_userType == "Maid" &&
                        _loginController.cityController.text.trim().isEmpty) {
                      showDownloadSnackbar("Please enter your city");
                    } else if (_userType == "Maid" &&
                        _loginController.timeController.text.trim().isEmpty) {
                      showDownloadSnackbar("Please enter your time");
                    } else if (_loginController.passwordController.text
                        .trim()
                        .isEmpty) {
                      showDownloadSnackbar("Please enter the password");
                    } else if (_loginController.passwordController.text
                            .trim() !=
                        _loginController.confirmPasswordController.text
                            .trim()) {
                      showDownloadSnackbar("Password did not match");
                    } else if (imageUrl.isEmpty) {
                      showDownloadSnackbar("Please take selfie");
                    } else {
                      try {
                        // Sign in with Supabase
                        Helper.progressDialog(context, "Loading...");
                        final response = await Supabase.instance.client
                            .from('user') // Your table name
                            .insert({
                          'email': email,
                          'password': password,
                          'name': _loginController.nameController.text.trim(),
                          'phone_number':
                              _loginController.mobileNoController.text.trim(),
                          'flat_no':
                              _loginController.faltNoController.text.trim(),
                          'job_type': jsonEncode(resultId),
                          'sign_up_type': _userType.trim(),
                          'image_url': imageUrl,
                          'uploaded_at': DateTime.now().toIso8601String(),
                          'price': _loginController.priceController.text.isEmpty
                              ? "0"
                              : _loginController.priceController.text.trim(),
                          'city': _loginController.cityController.text.trim(),
                          'available_time':
                              _loginController.timeController.text.trim()
                        }).select();
                        // final response = await Supabase.instance.client.auth
                        //     .signUp(
                        //   email: email,
                        //   password: password,
                        // );

                        // Check for successful sign-in
                        // if (response.user != null) {
                        showDownloadSnackbar("SignUP successful");
                        setState(() {
                          _loginController.nameController.clear();
                          _loginController.emailController.clear();
                          _loginController.mobileNoController.clear();
                          _loginController.faltNoController.clear();
                          _loginController.passwordController.clear();
                          _loginController.confirmPasswordController.clear();
                          _loginController.typeController.clear();
                          _loginController.priceController.clear();
                          _loginController.cityController.clear();
                          _loginController.timeController.clear();
                          jobResult = "";
                          timeResult = "";
                          resultTimeId = "";
                          resultId = [];
                          imageUrl = "";
                          locationResult = "";
                          resultlocationId = "";
                          startTime = null;
                          endTime = null;
                          _selfieImage = null;
                        });

                        Helper.close();
                        Get.off(() => const Login());
                        //   Get.to(() => const Home());
                        // } else {
                        //   showDownloadSnackbar("Login failed: No user found");
                        // }
                      } on AuthException catch (e) {
                        Helper.close();
                        // Handle Supabase-specific authentication errors
                        showDownloadSnackbar("Login failed: ${e.message}");
                        print("${e.message}");
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

                      //  Get.to(() => const Home());
                    }
                  },
                  label: 'SignUp'),
              SizedBox(height: SizeConstant.getHeightWithScreen(10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Already have an account?"),
                  TextButton(
                      onPressed: () {
                        Get.to(() => const Login());
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.purple),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return '';
    final now = DateTime.now();
    final formattedTime =
        TimeOfDay(hour: time.hour, minute: time.minute).format(context);
    return formattedTime;
  }

  _showModal(List<JobList> jobList) async {
    final result = await showModalBottomSheet<List<String>>(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        builder: (context) =>
            JobSelectionModal(jobList: jobList, resultId: resultId));
    if (result != null) {
      setState(() {
        jobResult = result.toString();
        resultId = result;
      });
    }
  }

  _showTimeModal(List<JobList> jobList) async {
    final result = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        builder: (context) =>
            TimeSelectionModal(jobList: jobList, resultId: resultTimeId));
    if (result != null) {
      int index = int.parse(result);
      setState(() {
        timeResult = jobList[index].time;
        resultTimeId = jobList[index].id.toString();
        _loginController.timeController.text = jobList[index].time;
      });
    }
  }

  _showLocationModal(List<LocationList> jobList) async {
    final result = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        builder: (context) => LocationSelectionModal(
            jobList: jobList, resultId: resultlocationId));
    if (result != null) {
      int index = int.parse(result);
      setState(() {
        cityResult = locationList[index].locationName;
        resultlocationId = locationList[index].id.toString();
        _loginController.cityController.text = locationList[index].locationName;
      });
    }
  }
}

class JobSelectionModal extends StatefulWidget {
  final List<JobList> jobList;
  final List<String> resultId;

  const JobSelectionModal(
      {super.key, required this.jobList, required this.resultId});

  @override
  State<JobSelectionModal> createState() => _JobSelectionModalState();
}

class _JobSelectionModalState extends State<JobSelectionModal> {
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
                        "Maid List",
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
          child: CommonButton(
            btnHeight: SizeConstant.getHeightWithScreen(48),
            onTap: () {
              Navigator.pop(context, selectedItems); // Return selected items
            },
            label: 'add'.tr,
            bgColor: ColorConstant.paymentBtnColor,
            textColor: ColorConstant.white,
            borderColor: ColorConstant.white,
          ),
        ),
      ),
    ]);
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Stack(children: [
  //     SingleChildScrollView(
  //         child: Container(
  //       padding: EdgeInsets.only(top: SizeConstant.getHeightWithScreen(50)),
  //       color: const Color(0xff757575),
  //       child: Container(
  //           padding: EdgeInsets.only(top: SizeConstant.getHeightWithScreen(5)),
  //           decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.only(
  //                   topLeft:
  //                       Radius.circular(SizeConstant.getHeightWithScreen(30)),
  //                   topRight:
  //                       Radius.circular(SizeConstant.getHeightWithScreen(30)))),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.stretch,
  //             children: <Widget>[
  //               const SizedBox(height: 5.0),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Container(
  //                     margin:
  //                         const EdgeInsets.only(top: 0, left: 16, right: 10),
  //                     child: Text(
  //                       "Job List",
  //                       style: TextStyle(
  //                           color: Colors.black,
  //                           fontFamily: "Outfit",
  //                           fontWeight: FontWeight.w600,
  //                           fontSize: SizeConstant.mediumFont),
  //                     ),
  //                   ),
  //                   IconButton(
  //                       onPressed: () {
  //                         Navigator.pop(context);
  //                       },
  //                       icon: Icon(
  //                         Icons.close,
  //                         color: ColorConstant.grey2,
  //                         size: SizeConstant.getHeightWithScreen(25),
  //                       ))
  //                 ],
  //               ),
  //               Container(
  //                 margin: const EdgeInsets.only(top: 0, bottom: 27),
  //                 child: ListView.builder(
  //                   padding: EdgeInsets.zero,
  //                   shrinkWrap: true,
  //                   physics: const NeverScrollableScrollPhysics(),
  //                   itemCount: widget.jobList.length,
  //                   itemBuilder: (context, index) => GestureDetector(
  //                     onTap: () {
  //                       Navigator.pop(context, index.toString());
  //                     },
  //                     child: Container(
  //                       margin: EdgeInsets.only(
  //                           top: SizeConstant.getHeightWithScreen(10),
  //                           left: SizeConstant.getHeightWithScreen(15),
  //                           right: SizeConstant.getHeightWithScreen(15)),
  //                       padding: EdgeInsets.only(
  //                           left: SizeConstant.getHeightWithScreen(16),
  //                           right: SizeConstant.getHeightWithScreen(16),
  //                           top: SizeConstant.getHeightWithScreen(16),
  //                           bottom: SizeConstant.getHeightWithScreen(14)),
  //                       decoration: BoxDecoration(
  //                           color:
  //                               selectedRadioValue == widget.jobList[index].id
  //                                   ? ColorConstant.orange4
  //                                   : ColorConstant.white,
  //                           borderRadius: BorderRadius.circular(10),
  //                           border: Border.all(
  //                               width: SizeConstant.getHeightWithScreen(1),
  //                               color: selectedRadioValue ==
  //                                       widget.jobList[index].id
  //                                   ? ColorConstant.white
  //                                   : ColorConstant.vibBgColor)),
  //                       child: Row(
  //                         children: [
  //                           Radio(
  //                             value: widget.jobList[index].id,
  //                             groupValue: selectedRadioValue,
  //                             materialTapTargetSize:
  //                                 MaterialTapTargetSize.shrinkWrap,
  //                             onChanged: (value) {
  //                               setState(() {
  //                                 Navigator.pop(context, index.toString());
  //                               });
  //                             },
  //                             fillColor:
  //                                 MaterialStateProperty.resolveWith<Color>(
  //                                     (Set<MaterialState> states) {
  //                               if (states.contains(MaterialState.selected)) {
  //                                 return ColorConstant.primaryColor;
  //                               }
  //                               return ColorConstant.bDisabledColor;
  //                             }),
  //                             visualDensity:
  //                                 const VisualDensity(horizontal: -4),
  //                           ),
  //                           SizedBox(
  //                             width: SizeConstant.getHeightWithScreen(10),
  //                           ),
  //                           Text(
  //                             widget.jobList[index].jobName,
  //                             style:
  //                                 TextStyle(fontSize: SizeConstant.mediumFont),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(
  //                       height: 60,
  //                     )
  //             ],
  //           )),
  //     )),
  //     Positioned(
  //       bottom: 0,
  //       left: 0,
  //       right: 0,
  //       child: Container(
  //         padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
  //         decoration: BoxDecoration(
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black.withOpacity(0.2),
  //               spreadRadius: 6,
  //               blurRadius: 6,
  //               offset: const Offset(0, -3),
  //             ),
  //           ],
  //           color: Colors.white,
  //           borderRadius: const BorderRadius.only(
  //             topLeft: Radius.circular(15),
  //             topRight: Radius.circular(15),
  //           ),
  //         ),
  //         child: CommonButton(
  //           btnHeight: SizeConstant.getHeightWithScreen(48),
  //           onTap: () {
  //             if (selectedNumber.isNotEmpty) {
  //               int index = int.parse(selectedNumber);
  //             }
  //             //   Navigator.pop(context, selectedNumber);
  //           },
  //           label: 'add'.tr,
  //           bgColor: ColorConstant.paymentBtnColor,
  //           textColor: ColorConstant.white,
  //           borderColor: ColorConstant.white,
  //         ),
  //       ),
  //     ),
  //   ]);
  // }
}

class LocationSelectionModal extends StatefulWidget {
  final List<LocationList> jobList;
  final String resultId;

  const LocationSelectionModal(
      {super.key, required this.jobList, required this.resultId});

  @override
  State<LocationSelectionModal> createState() => _LocationSelectionModalState();
}

class _LocationSelectionModalState extends State<LocationSelectionModal> {
  String selectedRadioValue = 'any'.tr;
  String selectedNumber = "";
  List<String> selectedItems = [];
  @override
  void initState() {
    selectedRadioValue = widget.resultId;
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
                    topLeft:
                        Radius.circular(SizeConstant.getHeightWithScreen(30)),
                    topRight:
                        Radius.circular(SizeConstant.getHeightWithScreen(30)))),
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
                        "Location List",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Outfit",
                            fontWeight: FontWeight.w600,
                            fontSize: SizeConstant.mediumFont),
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
                        ))
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 0, bottom: 27),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.jobList.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        Navigator.pop(context, index.toString());
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            top: SizeConstant.getHeightWithScreen(10),
                            left: SizeConstant.getHeightWithScreen(15),
                            right: SizeConstant.getHeightWithScreen(15)),
                        padding: EdgeInsets.only(
                            left: SizeConstant.getHeightWithScreen(16),
                            right: SizeConstant.getHeightWithScreen(16),
                            top: SizeConstant.getHeightWithScreen(16),
                            bottom: SizeConstant.getHeightWithScreen(14)),
                        decoration: BoxDecoration(
                            color:
                                selectedRadioValue == widget.jobList[index].id
                                    ? ColorConstant.orange4
                                    : ColorConstant.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: SizeConstant.getHeightWithScreen(1),
                                color: selectedRadioValue ==
                                        widget.jobList[index].id
                                    ? ColorConstant.white
                                    : ColorConstant.vibBgColor)),
                        child: Row(
                          children: [
                            Radio(
                              value: widget.jobList[index].id,
                              groupValue: selectedRadioValue,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              onChanged: (value) {
                                setState(() {
                                  Navigator.pop(context, index.toString());
                                });
                              },
                              fillColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                if (states.contains(MaterialState.selected)) {
                                  return ColorConstant.primaryColor;
                                }
                                return ColorConstant.bDisabledColor;
                              }),
                              visualDensity:
                                  const VisualDensity(horizontal: -4),
                            ),
                            SizedBox(
                              width: SizeConstant.getHeightWithScreen(10),
                            ),
                            Text(
                              widget.jobList[index].locationName,
                              style:
                                  TextStyle(fontSize: SizeConstant.mediumFont),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      )),
    ]);
  }
}

class TimeSelectionModal extends StatefulWidget {
  final List<JobList> jobList;
  final String resultId;

  const TimeSelectionModal(
      {super.key, required this.jobList, required this.resultId});

  @override
  State<TimeSelectionModal> createState() => _TimeSelectionModalState();
}

class _TimeSelectionModalState extends State<TimeSelectionModal> {
  String selectedRadioValue = 'any'.tr;
  String selectedNumber = "";
  List<String> selectedItems = [];
  @override
  void initState() {
    selectedRadioValue = widget.resultId;
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
                        topLeft:
                        Radius.circular(SizeConstant.getHeightWithScreen(30)),
                        topRight:
                        Radius.circular(SizeConstant.getHeightWithScreen(30)))),
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
                            "Time List",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Outfit",
                                fontWeight: FontWeight.w600,
                                fontSize: SizeConstant.mediumFont),
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
                            ))
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 0, bottom: 27),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.jobList.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            Navigator.pop(context, index.toString());
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                top: SizeConstant.getHeightWithScreen(10),
                                left: SizeConstant.getHeightWithScreen(15),
                                right: SizeConstant.getHeightWithScreen(15)),
                            padding: EdgeInsets.only(
                                left: SizeConstant.getHeightWithScreen(16),
                                right: SizeConstant.getHeightWithScreen(16),
                                top: SizeConstant.getHeightWithScreen(16),
                                bottom: SizeConstant.getHeightWithScreen(14)),
                            decoration: BoxDecoration(
                                color:
                                selectedRadioValue == widget.jobList[index].id
                                    ? ColorConstant.orange4
                                    : ColorConstant.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: SizeConstant.getHeightWithScreen(1),
                                    color: selectedRadioValue ==
                                        widget.jobList[index].id
                                        ? ColorConstant.white
                                        : ColorConstant.vibBgColor)),
                            child: Row(
                              children: [
                                Radio(
                                  value: widget.jobList[index].id,
                                  groupValue: selectedRadioValue,
                                  materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                                  onChanged: (value) {
                                    setState(() {
                                      Navigator.pop(context, index.toString());
                                    });
                                  },
                                  fillColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                        if (states.contains(MaterialState.selected)) {
                                          return ColorConstant.primaryColor;
                                        }
                                        return ColorConstant.bDisabledColor;
                                      }),
                                  visualDensity:
                                  const VisualDensity(horizontal: -4),
                                ),
                                SizedBox(
                                  width: SizeConstant.getHeightWithScreen(10),
                                ),
                                Text(
                                  widget.jobList[index].time,
                                  style:
                                  TextStyle(fontSize: SizeConstant.mediumFont),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          )),
    ]);
  }
}
