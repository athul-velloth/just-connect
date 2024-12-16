import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:justconnect/Ui/owner_dashboard/create_job.dart';
import 'package:justconnect/Ui/owner_dashboard/job_card.dart';
import 'package:justconnect/Ui/worker_dashboard/home.dart';
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
                      Get.to(() => const Home());
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
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConstant.horizontalPadding),
              child: Expanded(
                child: ListView.separated(
                    padding: EdgeInsets.zero,
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: SizeConstant.getHeightWithScreen(10),
                      );
                    },
                    shrinkWrap: true,
                    itemCount: _ownerController.jobList.length,
                    itemBuilder: (context, index) {
                      return JobCard(model: _ownerController.jobList[index]);
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
