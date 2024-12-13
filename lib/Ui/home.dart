import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:justconnect/Ui/job_detail_page.dart';

import '../constants/color_constants.dart';
import '../constants/size_constants.dart';
import '../model/Job.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      body: SafeArea(
        top: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 800,
              color: ColorConstant.primaryColor,
              padding: EdgeInsets.only(top: SizeConstant.getHeightWithScreen(10),
                  bottom: SizeConstant.getHeightWithScreen(10)),
              child: Text(
                "Home",
                style: TextStyle(
                  color: ColorConstant.black,
                  fontSize: SizeConstant.largeFont,
                  fontWeight: FontWeight.w600
                ), textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            // Wrap ListView.builder with Flexible or Expanded
            Expanded(
              child: ListView.builder(
                itemCount: jobList.length,
                itemBuilder: (context, index) {
                  final job = jobList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobDetailPage(job: job),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.all(10.0),
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30.0,
                              backgroundImage: NetworkImage(job.ownerImage),
                            ),
                            const SizedBox(width: 15.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Flat No: ${job.flatNo}',
                                    style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Date: ${job.date}',
                                    style: const TextStyle(fontSize: 14.0),
                                  ),
                                  Text(
                                    'Type of Job: ${job.jobType}',
                                    style: const TextStyle(fontSize: 14.0),
                                  ),
                                  Text(
                                    'Full Name: ${job.fullName}',
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
