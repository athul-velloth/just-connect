import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:justconnect/Ui/job_detail_page.dart';
import 'package:justconnect/Ui/owner_dashboard/owner_dashboard.dart';
import 'package:justconnect/constants/strings.dart';
import 'package:justconnect/controller/worker_controller.dart';

import '../../constants/color_constants.dart';
import '../../constants/size_constants.dart';
import '../../model/Job.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final WorkerController _ownerController = Get.put(WorkerController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: ColorConstant.white,
        body: Padding(
          padding: EdgeInsets.only(
              left: SizeConstant.getHeightWithScreen(15),
              right: SizeConstant.getHeightWithScreen(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).viewPadding.top,
              ),
              // Wrap ListView.builder with Flexible or Expanded
              Padding(
                padding: EdgeInsets.only(
                    left: SizeConstant.horizontalPadding,
                    top: SizeConstant.topPadding,
                    right: SizeConstant.horizontalPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Strings.workerDashboard,
                      style: TextStyle(
                        color: ColorConstant.black.withOpacity(0.88),
                        fontSize: SizeConstant.largeFont,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const OwnerDashboard());
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
              Expanded(
                child: ListView.builder(
                  itemCount: _ownerController.jobList.length,
                  itemBuilder: (context, index) {
                    final job = _ownerController.jobList[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JobDetailPage(job: job),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          top: SizeConstant.getHeightWithScreen(10),
                          bottom: SizeConstant.getHeightWithScreen(12),
                        ),
                        padding: EdgeInsets.only(
                          left: SizeConstant.getHeightWithScreen(10),
                          right: SizeConstant.getHeightWithScreen(12),
                          top: SizeConstant.getHeightWithScreen(10),
                          bottom: SizeConstant.getHeightWithScreen(12),
                        ),
                        decoration: BoxDecoration(
                          color: ColorConstant.white,
                          border: Border.all(color: ColorConstant.grey8),
                          borderRadius: BorderRadius.all(Radius.circular(
                              SizeConstant.getHeightWithScreen(15))),
                          boxShadow: [
                            BoxShadow(
                              color: ColorConstant.shadowColor,
                              blurRadius: 6,
                              blurStyle: BlurStyle.outer, //extend the shadow
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 30.0,
                                backgroundImage: NetworkImage(job.ownerImage),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      job.fullName,
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: SizeConstant.mediumFont,
                                        fontWeight: FontWeight.w600,
                                        color: ColorConstant.black3,
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          SizeConstant.getHeightWithScreen(4),
                                    ),
                                    Text(
                                      'Flat No: ${job.flatNo}',
                                      style: TextStyle(
                                        overflow: TextOverflow.visible,
                                        fontSize: SizeConstant.xSmallFont,
                                        fontWeight: FontWeight.w500,
                                        color: ColorConstant.grey26,
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          SizeConstant.getHeightWithScreen(4),
                                    ),
                                    Text(
                                      'Type of Job: ${job.jobType}',
                                      style: TextStyle(
                                        overflow: TextOverflow.visible,
                                        fontSize: SizeConstant.xSmallFont,
                                        fontWeight: FontWeight.w500,
                                        color: ColorConstant.grey26,
                                      ),
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
      ),
    );
  }
}
