import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:justconnect/Ui/owner_dashboard/create_job.dart';
import 'package:justconnect/Ui/owner_dashboard/job_card.dart';
import 'package:justconnect/constants/color_constants.dart';
import 'package:justconnect/constants/size_constants.dart';
import 'package:justconnect/constants/strings.dart';
import 'package:justconnect/controller/owner_controller.dart';

class OwnerDashboard extends StatefulWidget {
  const OwnerDashboard({super.key});

  @override
  State<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  final OwnerController _ownerController = Get.put(OwnerController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          Strings.ownerDashboard,
          style: TextStyle(
              color: ColorConstant.white,
              fontSize: SizeConstant.largeFont,
              fontWeight: FontWeight.w400),
        ),
        actions: [
          IconButton(
              onPressed: () {
                // navigate to worker's list
              },
              icon: Icon(
                Icons.exit_to_app,
                size: SizeConstant.getHeightWithScreen(26),
                color: ColorConstant.white,
              ))
        ],
      ),
      body: SafeArea(
        top: true,
        child: Padding(
          padding: EdgeInsets.only(
              left: SizeConstant.horizontalPadding,
              right: SizeConstant.horizontalPadding),
          child: Column(
            children: [
              SizedBox(height: SizeConstant.getHeightWithScreen(20)),
              Expanded(
                child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 5,
                      );
                    },
                    shrinkWrap: true,
                    itemCount: _ownerController.jobList.length,
                    itemBuilder: (context, index) {
                      return JobCard(model: _ownerController.jobList[index]);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
