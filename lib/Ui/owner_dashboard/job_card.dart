import 'package:flutter/material.dart';
import 'package:justconnect/constants/color_constants.dart';
import 'package:justconnect/constants/size_constants.dart';
import 'package:justconnect/model/Job.dart';
import 'package:url_launcher/url_launcher.dart';

class JobCard extends StatelessWidget {
  final Job model;
  const JobCard({
    super.key,
    required this.model,
  });

  String getFirstLetterFromName(String? first, String? middle, String? last) {
    String nameLetters = "";
    if (first != null) {
      nameLetters = first[0].toUpperCase();
    }
    if (first != null && last != null) {
      nameLetters = nameLetters + last[0].toUpperCase();
    }
    if (last == null && middle != null) {
      nameLetters = middle[0].toUpperCase();
    }
    return nameLetters;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: EdgeInsets.only(
          left: SizeConstant.getHeightWithScreen(10),
          right: SizeConstant.getHeightWithScreen(12),
          top: SizeConstant.getHeightWithScreen(10),
          bottom: SizeConstant.getHeightWithScreen(12),
        ),
        decoration: BoxDecoration(
          color: ColorConstant.white,
          border: Border.all(color: ColorConstant.grey8, width: 2),
          borderRadius: BorderRadius.all(
              Radius.circular(SizeConstant.getHeightWithScreen(15))),
          boxShadow: [
            BoxShadow(
              color: ColorConstant.shadowColor,
              blurRadius: 6,
              blurStyle: BlurStyle.outer, //extend the shadow
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(model.ownerImage),
            ),
            SizedBox(
              width: SizeConstant.getHeightWithScreen(16),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        model.date,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: SizeConstant.xSmallFont,
                          fontWeight: FontWeight.w500,
                          color: ColorConstant.grey26,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: SizeConstant.getHeightWithScreen(5),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: ColorConstant.primaryColor,
                      size: SizeConstant.getHeightWithScreen(12),
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConstant.getHeightWithScreen(5),
                ),
                Text(
                  model.fullName,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: SizeConstant.mediumFont,
                    fontWeight: FontWeight.w600,
                    color: ColorConstant.black3,
                  ),
                ),
                SizedBox(
                  height: SizeConstant.getHeightWithScreen(4),
                ),
                Text(
                  model.jobType,
                  style: TextStyle(
                    overflow: TextOverflow.visible,
                    fontSize: SizeConstant.xSmallFont,
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.grey26,
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    ]);
  }

  // Function to initiate a phone call
  void _launchPhoneCall(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching phone call: $e');
    }
  }

// Function to open WhatsApp with a specified phone number
  void _launchWhatsApp(String phoneNumber) async {
    String url = 'https://wa.me/$phoneNumber';
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching WhatsApp: $e');
    }
  }
}
