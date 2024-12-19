import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:justconnect/constants/color_constants.dart';
import 'package:justconnect/constants/size_constants.dart';
import 'package:justconnect/controller/worker_controller.dart';
import 'package:justconnect/model/job_list.dart';
import 'package:justconnect/model/location_list.dart';
import 'package:justconnect/widget/helper.dart';
import 'package:justconnect/widget/tooltip.dart';
import 'package:justconnect/widget/ventas_primary_button.dart';
import 'package:time_range_picker/time_range_picker.dart';

class MaidFilterBottomsheet {
  maidFilterBottomsheet(
    BuildContext context,
    final Function(String, String) onFilter, {
    String? dateFormt,
  }) async {}

  filterMultipleStatusBottomsheet(
      {required BuildContext context,
      required List<JobList> jobList,
      required List<LocationList> locationList,
      String? dateFormt,
      required final Function(String?, String?, String?, String?, String?)
          onFilter,
      required final Function() onClear,
      required String title}) async {
    final WorkerController workerController = Get.put(WorkerController());

    Widget getSelectedFilterList(String filter, StateSetter setState) {
      var widget;

      switch (filter) {
        case "Maid Type":
          widget = Obx(() {
            return workerController.jobList.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 3.5,
                      ),
                      Center(
                        child: Text(
                          'noDataFound'.tr,
                          style: TextStyle(
                            color: ColorConstant.black.withOpacity(0.88),
                            fontSize: SizeConstant.mediumFont,
                          ),
                        ),
                      ),
                    ],
                  )
                : ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: jobList.length,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: SizeConstant.getHeightWithScreen(2),
                        child: Divider(
                          color: ColorConstant.dividerColor,
                          height: 0.5,
                        ),
                      );
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: SizeConstant.getHeightWithScreen(20),
                          right: SizeConstant.getHeightWithScreen(20),
                          top: SizeConstant.getHeightWithScreen(15),
                          bottom: SizeConstant.getHeightWithScreen(15),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              visualDensity: const VisualDensity(
                                  horizontal: -4, vertical: -4),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              activeColor: ColorConstant.primaryColor,
                              checkColor: ColorConstant.white,
                              value: workerController.maidTypeCheckChecked
                                  .contains(jobList[index]),
                              onChanged: (bool? selected) {
                                if (selected == true) {
                                  setState(() {
                                    workerController.maidTypeCheckChecked
                                        .clear();
                                    workerController.maidTypeCheckChecked
                                        .add(jobList[index]);
                                    workerController.maidtypeName.value =
                                        jobList[index].jobName;
                                  });
                                } else {
                                  setState(() {
                                    workerController.maidTypeCheckChecked
                                        .clear();
                                    workerController.maidtypeName.value = "";
                                  });
                                }
                              },
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: SizeConstant.getHeightWithScreen(16),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AnimatedTooltip(
                                      content: Text(
                                        jobList[index].jobName ?? "-",
                                      ),
                                      child: Text(
                                        jobList[index].jobName ?? "-",
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: ColorConstant.black
                                              .withOpacity(0.88),
                                          fontSize: SizeConstant.mediumFont,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    // Text(
                                    //   jobList[index].id.toString() ?? "-",
                                    //   style: TextStyle(
                                    //     overflow: TextOverflow.ellipsis,
                                    //     color: ColorConstant.black
                                    //         .withOpacity(0.88),
                                    //     fontSize: SizeConstant.smallFont,
                                    //     fontWeight: FontWeight.w300,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    });
          });
          break;
        case "Price":
          widget = Obx(() {
            return workerController.jobList.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 3.5,
                      ),
                      Center(
                        child: Text(
                          'noDataFound'.tr,
                          style: TextStyle(
                            color: ColorConstant.black.withOpacity(0.88),
                            fontSize: SizeConstant.mediumFont,
                          ),
                        ),
                      ),
                    ],
                  )
                : ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: jobList.length,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: SizeConstant.getHeightWithScreen(2),
                        child: Divider(
                          color: ColorConstant.dividerColor,
                          height: 0.5,
                        ),
                      );
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: SizeConstant.getHeightWithScreen(20),
                          right: SizeConstant.getHeightWithScreen(20),
                          top: SizeConstant.getHeightWithScreen(15),
                          bottom: SizeConstant.getHeightWithScreen(15),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              visualDensity: const VisualDensity(
                                  horizontal: -4, vertical: -4),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              activeColor: ColorConstant.primaryColor,
                              checkColor: ColorConstant.white,
                              value: workerController.priceTypeCheckChecked
                                  .contains(jobList[index]),
                              onChanged: (bool? selected) {
                                if (selected == true) {
                                  setState(() {
                                    workerController.priceTypeCheckChecked
                                        .clear();
                                    workerController.priceTypeCheckChecked
                                        .add(jobList[index]);
                                    workerController.priceName.value =
                                        jobList[index].priceHr.toString();
                                  });
                                } else {
                                  setState(() {
                                    workerController.priceTypeCheckChecked
                                        .clear();
                                    workerController.priceName.value = "";
                                  });
                                }
                              },
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: SizeConstant.getHeightWithScreen(16),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AnimatedTooltip(
                                      content: Text(
                                        jobList[index].priceHr.toString() ??
                                            "-",
                                      ),
                                      child: Text(
                                        jobList[index].priceHr.toString() ??
                                            "-",
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: ColorConstant.black
                                              .withOpacity(0.88),
                                          fontSize: SizeConstant.mediumFont,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    // Text(
                                    //   jobList[index].id.toString() ?? "-",
                                    //   style: TextStyle(
                                    //     overflow: TextOverflow.ellipsis,
                                    //     color: ColorConstant.black
                                    //         .withOpacity(0.88),
                                    //     fontSize: SizeConstant.smallFont,
                                    //     fontWeight: FontWeight.w300,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    });
          });
          break;
        case "Location":
          widget = Obx(() {
            return workerController.locationList.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 3.5,
                      ),
                      Center(
                        child: Text(
                          'noDataFound'.tr,
                          style: TextStyle(
                            color: ColorConstant.black.withOpacity(0.88),
                            fontSize: SizeConstant.mediumFont,
                          ),
                        ),
                      ),
                    ],
                  )
                : ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: locationList.length,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: SizeConstant.getHeightWithScreen(2),
                        child: Divider(
                          color: ColorConstant.dividerColor,
                          height: 0.5,
                        ),
                      );
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: SizeConstant.getHeightWithScreen(20),
                          right: SizeConstant.getHeightWithScreen(20),
                          top: SizeConstant.getHeightWithScreen(15),
                          bottom: SizeConstant.getHeightWithScreen(15),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              visualDensity: const VisualDensity(
                                  horizontal: -4, vertical: -4),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              activeColor: ColorConstant.primaryColor,
                              checkColor: ColorConstant.white,
                              value: workerController.locationTypeCheckChecked
                                  .contains(locationList[index]),
                              onChanged: (bool? selected) {
                                if (selected == true) {
                                  setState(() {
                                    workerController.locationTypeCheckChecked
                                        .clear();
                                    workerController.locationTypeCheckChecked
                                        .add(locationList[index]);
                                    workerController.locationName.value =
                                        locationList[index].locationName;
                                  });
                                  // if (workerController.selectedLocation.value
                                  //         .locationId !=
                                  //     null) {
                                  // workerController.callProvinceApi(controller
                                  //         .selectedLocation
                                  //         .value
                                  //         .locationId ??
                                  //     "");
                                  // workerController.selectedprovince.value =
                                  //     ChildLocation();
                                  // workerController.reportProvinceChecked = [];
                                  // }
                                } else {
                                  setState(() {
                                    workerController.locationTypeCheckChecked
                                        .clear();
                                    workerController.locationName.value = "";
                                    //     location.Content();
                                    // workerController.selectedprovince.value =
                                    //     ChildLocation();
                                    // workerController.reportProvinceChecked = [];
                                  });
                                }
                              },
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: SizeConstant.getHeightWithScreen(16),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AnimatedTooltip(
                                      content: Text(
                                        locationList[index].locationName ?? "-",
                                      ),
                                      child: Text(
                                        locationList[index].locationName ?? "-",
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: ColorConstant.black
                                              .withOpacity(0.88),
                                          fontSize: SizeConstant.mediumFont,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    // Text(
                                    //   locationList[index].id.toString() ??
                                    //       "-",
                                    //   style: TextStyle(
                                    //     overflow: TextOverflow.ellipsis,
                                    //     color: ColorConstant.black
                                    //         .withOpacity(0.88),
                                    //     fontSize: SizeConstant.smallFont,
                                    //     fontWeight: FontWeight.w300,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    });
          });
          break;
        case "Time":
          widget = Container(
            child: InkWell(
                onTap: () async {
                  workerController.timeRange = await showTimeRangePicker(
                    context: context,
                    start: const TimeOfDay(
                        hour: 8, minute: 0), // Default start selection
                    end: const TimeOfDay(
                        hour: 17, minute: 0), // Default end selection
                    disabledTime: workerController.getDisabledTimeRanges(),
                    disabledColor: Colors.grey.withOpacity(
                        0.5), // Optional: visually indicate disabled times
                    interval: const Duration(
                        minutes: 15), // Optional: 15-minute intervals
                    use24HourFormat: false, // Optional: 12-hour format
                    labelStyle: const TextStyle(fontSize: 16, color: Colors.white),
                    timeTextStyle: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  );
                  print(
                      "result ${workerController.timeRange?.startTime} to${workerController.timeRange?.endTime}");
                  if (workerController.timeRange != null) {
                    setState(() {
                      workerController.startTime =
                          workerController.timeRange?.startTime;
                      workerController.endTime =
                          workerController.timeRange?.endTime;
                      workerController.timeName.value =
                          "${workerController.formatTime(workerController.startTime, context)} - ${workerController.formatTime(workerController.endTime, context)}";
                    });
                  }
                },
                child: Column(
                  children: [
                    Container(
                      width: SizeConstant.getHeightWithScreen(500),
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConstant.getHeightWithScreen(17),
                          vertical: SizeConstant.getHeightWithScreen(5)),
                      height: SizeConstant.getHeightWithScreen(55),
                      child: Text(
                        'Time Range \n${workerController.formatTime(workerController.startTime, context)} ${workerController.formatTime(workerController.endTime, context)}',
                      ),
                    ),
                    VentasPrimaryButton(
                      onTap: () async {
                        workerController.timeRange = await showTimeRangePicker(
                          context: context,
                          start: const TimeOfDay(
                              hour: 8, minute: 0), // Default start selection
                          end: const TimeOfDay(
                              hour: 17, minute: 0), // Default end selection
                          disabledTime:
                              workerController.getDisabledTimeRanges(),
                          disabledColor: Colors.grey.withOpacity(
                              0.5), // Optional: visually indicate disabled times
                          interval: const Duration(
                              minutes: 15), // Optional: 15-minute intervals
                          use24HourFormat: false, // Optional: 12-hour format
                          labelStyle: const TextStyle(fontSize: 16, color: Colors.white),
                          timeTextStyle: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                        );
                        print(
                            "result ${workerController.timeRange?.startTime} to${workerController.timeRange?.endTime}");
                        if (workerController.timeRange != null) {
                          setState(() {
                            workerController.startTime =
                                workerController.timeRange?.startTime;
                            workerController.endTime =
                                workerController.timeRange?.endTime;
                            workerController.timeName.value =
                                "${workerController.formatTime(workerController.startTime, context)} - ${workerController.formatTime(workerController.endTime, context)}";
                          });
                        }
                      },
                      label: "Select Time",
                      textColor: ColorConstant.white,
                      borderRadius: 10,
                      textSize: SizeConstant.mediumFont,
                      weight: FontWeight.w500,
                      btnHeight: SizeConstant.getHeightWithScreen(40),
                      btnWidth: (MediaQuery.of(context).size.width / 2) -
                          SizeConstant.getHeightWithScreen(45),
                    ),
                  ],
                )),
          );
          // widget = Obx(() {
          //   return workerController.jobList.isEmpty
          //       ? Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             SizedBox(
          //               height: MediaQuery.of(context).size.height / 3.5,
          //             ),
          //             Center(
          //               child: Text(
          //                 'noDataFound'.tr,
          //                 style: TextStyle(
          //                   color: ColorConstant.black.withOpacity(0.88),
          //                   fontSize: SizeConstant.mediumFont,
          //                 ),
          //               ),
          //             ),
          //           ],
          //         )
          //       : ListView.separated(
          //           physics: const NeverScrollableScrollPhysics(),
          //           itemCount: jobList.length,
          //           shrinkWrap: true,
          //           separatorBuilder: (context, index) {
          //             return SizedBox(
          //               height: SizeConstant.getHeightWithScreen(2),
          //               child: Divider(
          //                 color: ColorConstant.dividerColor,
          //                 height: 0.5,
          //               ),
          //             );
          //           },
          //           itemBuilder: (BuildContext context, int index) {
          //             return Padding(
          //               padding: EdgeInsets.only(
          //                 left: SizeConstant.getHeightWithScreen(20),
          //                 right: SizeConstant.getHeightWithScreen(20),
          //                 top: SizeConstant.getHeightWithScreen(15),
          //                 bottom: SizeConstant.getHeightWithScreen(15),
          //               ),
          //               child: Row(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Checkbox(
          //                     visualDensity: const VisualDensity(
          //                         horizontal: -4, vertical: -4),
          //                     materialTapTargetSize:
          //                         MaterialTapTargetSize.shrinkWrap,
          //                     activeColor: ColorConstant.primaryColor,
          //                     checkColor: ColorConstant.white,
          //                     value: workerController.timeTypeCheckChecked
          //                         .contains(jobList[index]),
          //                     onChanged: (bool? selected) {
          //                       if (selected == true) {
          //                         setState(() {
          //                           workerController.timeTypeCheckChecked
          //                               .clear();
          //                           workerController.timeTypeCheckChecked
          //                               .add(jobList[index]);
          //                           workerController.timeName.value =
          //                               jobList[index].time;
          //                         });
          //                       } else {
          //                         setState(() {
          //                           workerController.timeTypeCheckChecked
          //                               .clear();
          //                           workerController.timeName.value = "";
          //                         });
          //                       }
          //                     },
          //                   ),
          //                   Expanded(
          //                     child: Padding(
          //                       padding: EdgeInsets.only(
          //                         left: SizeConstant.getHeightWithScreen(16),
          //                       ),
          //                       child: Column(
          //                         mainAxisAlignment: MainAxisAlignment.start,
          //                         crossAxisAlignment:
          //                             CrossAxisAlignment.start,
          //                         children: [
          //                           AnimatedTooltip(
          //                             content: Text(
          //                               jobList[index].time ?? "-",
          //                             ),
          //                             child: Text(
          //                               jobList[index].time ?? "-",
          //                               textAlign: TextAlign.start,
          //                               maxLines: 1,
          //                               style: TextStyle(
          //                                 overflow: TextOverflow.ellipsis,
          //                                 color: ColorConstant.black
          //                                     .withOpacity(0.88),
          //                                 fontSize: SizeConstant.mediumFont,
          //                                 fontWeight: FontWeight.w400,
          //                               ),
          //                             ),
          //                           ),
          //                           // Text(
          //                           //   jobList[index].id.toString() ?? "-",
          //                           //   style: TextStyle(
          //                           //     overflow: TextOverflow.ellipsis,
          //                           //     color: ColorConstant.black
          //                           //         .withOpacity(0.88),
          //                           //     fontSize: SizeConstant.smallFont,
          //                           //     fontWeight: FontWeight.w300,
          //                           //   ),
          //                           // ),
          //                         ],
          //                       ),
          //                     ),
          //                   )
          //                 ],
          //               ),
          //             );
          //           });
          // });
          break;
      }
      return widget;
    }

    showModalBottomSheet(
        elevation: 2,
        isScrollControlled: true,
        context: context,
        backgroundColor: ColorConstant.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(SizeConstant.getHeightWithScreen(30)),
              topRight: Radius.circular(SizeConstant.getHeightWithScreen(30))),
        ),
        builder: (BuildContext ctx) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: SizeConstant.getHeightWithScreen(676),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: ColorConstant.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    SizeConstant.getHeightWithScreen(20),
                  ),
                  topRight: Radius.circular(
                    SizeConstant.getHeightWithScreen(20),
                  ),
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: SizeConstant.getHeightWithScreen(15),
                              right: SizeConstant.getHeightWithScreen(15),
                              top: SizeConstant.getHeightWithScreen(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  title.tr,
                                  style: TextStyle(
                                      color:
                                          ColorConstant.black.withOpacity(0.88),
                                      fontSize: SizeConstant.largeFont,
                                      fontWeight: FontWeight.w600),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Helper.close();
                                    workerController.selectedIndex = -1;
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: ColorConstant.grey11,
                                    size: SizeConstant.getHeightWithScreen(27),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: SizeConstant.getHeightWithScreen(15),
                          ),
                          Divider(
                            color: ColorConstant.dividerColor,
                            height: 0.5,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: SizeConstant.getHeightWithScreen(120),
                                color: ColorConstant.dividerColor,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //   if (communeList.isNotEmpty)
                                    //  if (workerController.isSellThru.value)
                                    GestureDetector(
                                      onTap: () {
                                        setState(
                                          () {
                                            workerController
                                                    .selectedReportFilter =
                                                "Maid Type";
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.only(
                                            left: SizeConstant
                                                .getHeightWithScreen(15),
                                            top: SizeConstant
                                                .getHeightWithScreen(10),
                                            bottom: SizeConstant
                                                .getHeightWithScreen(10)),
                                        decoration: workerController
                                                    .selectedReportFilter ==
                                                "Maid Type"
                                            ? BoxDecoration(
                                                color: ColorConstant.white,
                                                border: Border(
                                                    left: BorderSide(
                                                        width: SizeConstant
                                                            .getHeightWithScreen(
                                                                2),
                                                        color: ColorConstant
                                                            .dashboardSecColor)),
                                              )
                                            : null,
                                        child: Text(
                                          "Maid Type",
                                          style: TextStyle(
                                              color: ColorConstant.black
                                                  .withOpacity(0.88),
                                              fontSize: SizeConstant.smallFont,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                    // if (controller.isSellThru.value)
                                    Divider(
                                      color: ColorConstant.grey21,
                                      height: 0.5,
                                    ),

                                    GestureDetector(
                                      onTap: () {
                                        setState(
                                          () {
                                            workerController
                                                .selectedReportFilter = "Price";
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.only(
                                            left: SizeConstant
                                                .getHeightWithScreen(15),
                                            top: SizeConstant
                                                .getHeightWithScreen(10),
                                            bottom: SizeConstant
                                                .getHeightWithScreen(10)),
                                        decoration: workerController
                                                    .selectedReportFilter ==
                                                "Price"
                                            ? BoxDecoration(
                                                color: ColorConstant.white,
                                                border: Border(
                                                    left: BorderSide(
                                                        width: SizeConstant
                                                            .getHeightWithScreen(
                                                                2),
                                                        color: ColorConstant
                                                            .dashboardSecColor)),
                                              )
                                            : null,
                                        child: Text(
                                          "Price",
                                          style: TextStyle(
                                              color: ColorConstant.black
                                                  .withOpacity(0.88),
                                              fontSize: SizeConstant.smallFont,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),

                                    Divider(
                                      color: ColorConstant.grey21,
                                      height: 0.5,
                                    ),

                                    GestureDetector(
                                      onTap: () {
                                        setState(
                                          () {
                                            workerController
                                                    .selectedReportFilter =
                                                "Location";
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.only(
                                            left: SizeConstant
                                                .getHeightWithScreen(15),
                                            top: SizeConstant
                                                .getHeightWithScreen(10),
                                            bottom: SizeConstant
                                                .getHeightWithScreen(10)),
                                        decoration: workerController
                                                    .selectedReportFilter ==
                                                "Location"
                                            ? BoxDecoration(
                                                color: ColorConstant.white,
                                                border: Border(
                                                    left: BorderSide(
                                                        width: SizeConstant
                                                            .getHeightWithScreen(
                                                                2),
                                                        color: ColorConstant
                                                            .dashboardSecColor)),
                                              )
                                            : null,
                                        child: Text(
                                          "Location",
                                          style: TextStyle(
                                              color: ColorConstant.black
                                                  .withOpacity(0.88),
                                              fontSize: SizeConstant.smallFont,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),

                                    Divider(
                                      color: ColorConstant.grey21,
                                      height: 0.5,
                                    ),

                                    GestureDetector(
                                      onTap: () {
                                        setState(
                                          () {
                                            workerController
                                                .selectedReportFilter = "Time";
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.only(
                                            left: SizeConstant
                                                .getHeightWithScreen(15),
                                            top: SizeConstant
                                                .getHeightWithScreen(10),
                                            bottom: SizeConstant
                                                .getHeightWithScreen(10)),
                                        decoration: workerController
                                                    .selectedReportFilter ==
                                                "Time"
                                            ? BoxDecoration(
                                                color: ColorConstant.white,
                                                border: Border(
                                                    left: BorderSide(
                                                        width: SizeConstant
                                                            .getHeightWithScreen(
                                                                2),
                                                        color: ColorConstant
                                                            .dashboardSecColor)),
                                              )
                                            : null,
                                        child: Text(
                                          "Time",
                                          style: TextStyle(
                                              color: ColorConstant.black
                                                  .withOpacity(0.88),
                                              fontSize: SizeConstant.smallFont,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),

                                    Divider(
                                      color: ColorConstant.grey21,
                                      height: 0.5,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: getSelectedFilterList(
                                    workerController.selectedReportFilter,
                                    setState),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: SizeConstant.getHeightWithScreen(32),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: ColorConstant.dividerColor,
                    height: 0.5,
                  ),
                  SizedBox(
                    height: SizeConstant.getHeightWithScreen(20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Helper.close();
                          // if ((workerController.selectedStatus.isNotEmpty) ||
                          //     (workerController
                          //         .maidTypeCheckChecked.isNotEmpty) ||
                          //     (workerController
                          //         .priceTypeCheckChecked.isNotEmpty) ||
                          //     (workerController
                          //         .locationTypeCheckChecked.isNotEmpty) ||
                          //     (workerController
                          //         .timeTypeCheckChecked.isNotEmpty) ||
                          //     (workerController.selectedReportFilter ==
                          //             "Maid Type" &&
                          //         workerController.selectedIndex != -1)) {
                          //   workerController.clearReportFilter();
                          //   onClear();
                          // }
                          workerController.clearReportFilter();
                          onClear();
                        },
                        child: Container(
                            width: (MediaQuery.of(context).size.width / 2) - 30,
                            height: SizeConstant.getHeightWithScreen(40),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: ColorConstant.primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(
                                  SizeConstant.getHeightWithScreen(10)),
                            ),
                            child: Center(
                              child: Text(
                                "Clear".tr,
                                style: TextStyle(
                                  fontSize: SizeConstant.mediumFont,
                                  fontWeight: FontWeight.w500,
                                  color: ColorConstant.primaryColor,
                                ),
                              ),
                            )),
                      ),
                      SizedBox(
                        width: SizeConstant.getHeightWithScreen(20),
                      ),
                      InkWell(
                        onTap: () async {
                          if (workerController.selectedIndex != -1 ||
                              (workerController
                                  .maidTypeCheckChecked.isNotEmpty) ||
                              (workerController
                                  .priceTypeCheckChecked.isNotEmpty) ||
                              (workerController
                                  .locationTypeCheckChecked.isNotEmpty) ||
                              (workerController.timeName.isNotEmpty) ||
                              ((workerController.selectedIndex != -1))) {
                            Helper.close();
                            // controller.dealersId = int.parse(
                            //     outletOnboardingController
                            //             .selectedDealer.value.partnerId ??
                            //         "0");
                            onFilter(
                              workerController.maidtypeName.value,
                              workerController.priceName.value,
                              workerController.locationName.value,
                              workerController.startTime == null
                                  ? null
                                  : workerController.formatTime(
                                      workerController.startTime, context),
                              workerController.endTime == null
                                  ? null
                                  : workerController.formatTime(
                                      workerController.endTime, context),
                            );
                          } else {
                            return;
                          }
                          // onFilter();
                        },
                        child: Container(
                            width: (MediaQuery.of(context).size.width / 2) - 30,
                            height: SizeConstant.getHeightWithScreen(40),
                            decoration: BoxDecoration(
                              color: workerController.selectedIndex != -1 ||
                                      (workerController
                                          .maidTypeCheckChecked.isNotEmpty) ||
                                      (workerController
                                          .priceTypeCheckChecked.isNotEmpty) ||
                                      (workerController.locationTypeCheckChecked
                                          .isNotEmpty) ||
                                      (workerController.timeName.isNotEmpty)
                                  ? ColorConstant.primaryColor
                                  : ColorConstant.pgvActiveDotColor,
                              border: Border.all(
                                width: 1,
                                color: Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(
                                  SizeConstant.getHeightWithScreen(10)),
                            ),
                            child: Center(
                              child: Text(
                                "Filter".tr,
                                style: TextStyle(
                                  fontSize: SizeConstant.mediumFont,
                                  fontWeight: FontWeight.w500,
                                  color: workerController.selectedIndex != -1 ||
                                          (workerController.maidTypeCheckChecked
                                              .isNotEmpty) ||
                                          (workerController
                                              .priceTypeCheckChecked
                                              .isNotEmpty) ||
                                          (workerController
                                              .locationTypeCheckChecked
                                              .isNotEmpty) ||
                                          (workerController.timeName.isNotEmpty)
                                      ? ColorConstant.white
                                      : ColorConstant.tfHintTextColor,
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConstant.getHeightWithScreen(20),
                  ),
                ],
              ),
            );
          });
        });
  }
}
