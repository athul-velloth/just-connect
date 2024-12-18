import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:justconnect/model/Job.dart';

class OwnerController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController desController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final List<Job> jobList = [
    Job(
      flatNo: 'A-101',
      date: '2024-12-13',
      jobType: 'Electrician',
      ownerImage:
          'https://cdn.pixabay.com/photo/2024/06/22/22/56/man-8847069_1280.jpg',
      fullName: 'John Doe',
      contactNumber: '+1234567890',
    ),
    Job(
      flatNo: 'B-202',
      date: '2024-12-10',
      jobType: 'Plumber',
      ownerImage:
          'https://images.pexels.com/photos/2128807/pexels-photo-2128807.jpeg?auto=compress&cs=tinysrgb&w=800',
      fullName: 'Jane Smith',
      contactNumber: '+9876543210',
    ),
  ];
}
