import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:justconnect/Ui/worker_dashboard/user_list.dart';
import 'package:justconnect/model/Job.dart';
import 'package:justconnect/model/job_list.dart';
import 'package:justconnect/model/location_list.dart';
import 'package:justconnect/model/user_details.dart';
import 'package:time_range_picker/time_range_picker.dart';

class WorkerController extends GetxController {
  List<JobList> maidTypeCheckChecked = [];
  List<JobList> priceTypeCheckChecked = [];
  List<LocationList> locationTypeCheckChecked = [];
  List<JobList> timeTypeCheckChecked = [];

  var selectedReportFilter = "Maid Type";
  String selectedStatus = "";
  var jobList = <JobList>[].obs;
  var userList = <UserDetails>[].obs;
  var locationList = <LocationList>[].obs;
  var maidtypeName = "".obs;
  var priceName = "".obs;
  var locationName = "".obs;
  var timeName = "".obs;
  int selectedIndex = -1;

  TimeRange? timeRange;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  clearReportFilter() {
    selectedReportFilter = "Maid Type";
    selectedIndex = -1;
    maidTypeCheckChecked = [];
    priceTypeCheckChecked = [];
    locationTypeCheckChecked = [];
    timeTypeCheckChecked = [];
    maidtypeName.value = "";
    priceName.value = "";
    locationName.value = "";
    timeName.value = "";
    startTime = null;
    endTime = null;
  }

  String formatTime(TimeOfDay? time, BuildContext context) {
    if (time == null) return '';
    final now = DateTime.now();
    final formattedTime =
        TimeOfDay(hour: time.hour, minute: time.minute).format(context);
    return formattedTime;
  }

  TimeRange getDisabledTimeRanges() {
    return TimeRange(
      startTime: const TimeOfDay(hour: 17, minute: 0), // Midnight to 8:00 AM
      endTime: const TimeOfDay(hour: 8, minute: 0),
    );
  }
  //var selectedDealer = JobList().obs;
  // final List<Job> jobList = [
  //   Job(
  //     flatNo: 'A-101',
  //     date: '2024-12-13',
  //     jobType: 'Electrician',
  //     ownerImage:
  //         'https://cdn.pixabay.com/photo/2024/06/22/22/56/man-8847069_1280.jpg',
  //     fullName: 'John Doe',
  //     contactNumber: '+1234567890',
  //   ),
  //   Job(
  //     flatNo: 'B-202',
  //     date: '2024-12-10',
  //     jobType: 'Plumber',
  //     ownerImage:
  //         'https://images.pexels.com/photos/2128807/pexels-photo-2128807.jpeg?auto=compress&cs=tinysrgb&w=800',
  //     fullName: 'Jane Smith',
  //     contactNumber: '+9876543210',
  //   ),
  // ];
}
