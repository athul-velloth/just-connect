import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:justconnect/model/Job.dart';

class OwnerController extends GetxController{
  final TextEditingController faltNoController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final List<Job> jobList = [
    Job(
      flatNo: 'A-101',
      date: '2024-12-13',
      jobType: 'Electrician',
      ownerImage: 'https://via.placeholder.com/150',
      fullName: 'John Doe',
      contactNumber: '+1234567890',
    ),
    Job(
      flatNo: 'B-202',
      date: '2024-12-10',
      jobType: 'Plumber',
      ownerImage: 'https://via.placeholder.com/150',
      fullName: 'Jane Smith',
      contactNumber: '+9876543210',
    ),
  ];
}