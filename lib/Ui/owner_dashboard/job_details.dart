import 'package:flutter/material.dart';
import 'package:justconnect/constants/color_constants.dart';
import 'package:justconnect/constants/size_constants.dart';
import 'package:justconnect/constants/strings.dart';
import 'package:justconnect/model/Job.dart';
import 'package:justconnect/widget/ventas_primary_button.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetails extends StatelessWidget {
  final Job job;

  const JobDetails({Key? key, required this.job}) : super(key: key);

  void _launchWhatsApp(String number) async {
    final url = 'https://wa.me/$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch WhatsApp';
    }
  }

  void _makePhoneCall(String number) async {
    final url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not make the phone call';
    }
  }

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
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).viewPadding.top,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: SizeConstant.topPadding,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  height: SizeConstant.getHeightWithScreen(35),
                                  width: SizeConstant.getHeightWithScreen(35),
                                  padding: EdgeInsets.only(
                                      left:
                                          SizeConstant.getHeightWithScreen(12),
                                      bottom:
                                          SizeConstant.getHeightWithScreen(10),
                                      right:
                                          SizeConstant.getHeightWithScreen(9),
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
                                  Strings.jobDetails,
                                  style: TextStyle(
                                    color:
                                        ColorConstant.black.withOpacity(0.88),
                                    fontSize: SizeConstant.largeFont,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(children: [
                            GestureDetector(
                              onTap: () {
                                _makePhoneCall(job.contactNumber);
                              },
                              child: Image(
                                image:
                                    const AssetImage("assets/images/phone.png"),
                                height: SizeConstant.getHeightWithScreen(24),
                                width: SizeConstant.getHeightWithScreen(24),
                              ),
                            ),
                            SizedBox(
                              width: SizeConstant.getHeightWithScreen(10),
                            ),
                            GestureDetector(
                              onTap: () {
                                _launchWhatsApp(job.contactNumber);
                              },
                              child: Image(
                                image: const AssetImage(
                                  "assets/images/whatsapp.png",
                                ),
                                height: SizeConstant.getHeightWithScreen(24),
                                width: SizeConstant.getHeightWithScreen(24),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                    SizedBox(height: SizeConstant.getHeightWithScreen(40)),
                    Center(
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundImage: NetworkImage(job.ownerImage),
                      ),
                    ),
                    SizedBox(height: SizeConstant.getHeightWithScreen(20)),
                    Text(
                      'Flat No: ${job.flatNo}',
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Date: ${job.date}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      'Type of Job: ${job.jobType}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      'Full Name: ${job.fullName}',
                      style: const TextStyle(
                          fontSize: 16.0, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConstant.getHeightWithScreen(10),
                  vertical: SizeConstant.getHeightWithScreen(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                          width: (MediaQuery.of(context).size.width / 2) -
                              SizeConstant.getHeightWithScreen(45),
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
                              "Deactive",
                              style: TextStyle(
                                fontSize: SizeConstant.mediumFont,
                                fontWeight: FontWeight.w500,
                                color: ColorConstant.primaryColor,
                              ),
                            ),
                          )),
                    ),
                    SizedBox(
                      width: SizeConstant.getHeightWithScreen(10),
                    ),
                    VentasPrimaryButton(
                      onTap: () {},
                      label: "Done",
                      textColor: ColorConstant.white,
                      borderRadius: 10,
                      textSize: SizeConstant.mediumFont,
                      weight: FontWeight.w500,
                      btnHeight: SizeConstant.getHeightWithScreen(40),
                      btnWidth: (MediaQuery.of(context).size.width / 2) -
                          SizeConstant.getHeightWithScreen(45),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
