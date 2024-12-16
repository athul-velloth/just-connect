import 'package:flutter/material.dart';
import 'package:justconnect/constants/color_constants.dart';
import 'package:justconnect/constants/size_constants.dart';
import 'package:justconnect/constants/strings.dart';
import 'package:justconnect/model/Job.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetailPage extends StatelessWidget {
  final Job job;

  const JobDetailPage({Key? key, required this.job}) : super(key: key);

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).viewPadding.top,
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: SizeConstant.topPadding,
                    right: SizeConstant.getHeightWithScreen(15)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: SizeConstant.getHeightWithScreen(35),
                        width: SizeConstant.getHeightWithScreen(35),
                        padding: EdgeInsets.only(
                            left: SizeConstant.getHeightWithScreen(12),
                            bottom: SizeConstant.getHeightWithScreen(10),
                            right: SizeConstant.getHeightWithScreen(9),
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
                        Strings.createJob,
                        style: TextStyle(
                          color: ColorConstant.black.withOpacity(0.88),
                          fontSize: SizeConstant.largeFont,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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
                style:
                const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
                style:
                const TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: SizeConstant.getHeightWithScreen(20)),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Job Accepted!')),
                  );
                },
                child: const Text('Accept Job'),
              ),
              SizedBox(height: SizeConstant.getHeightWithScreen(20)),
              ElevatedButton.icon(
                onPressed: () => _makePhoneCall(job.contactNumber),
                icon: const Icon(Icons.phone),
                label: const Text('Call Owner'),
              ),
              SizedBox(height: SizeConstant.getHeightWithScreen(20)),
              ElevatedButton.icon(
                onPressed: () => _launchWhatsApp(job.contactNumber),
                icon: const Icon(Icons.message),
                label: const Text('Chat on WhatsApp'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
