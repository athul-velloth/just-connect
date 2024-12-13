import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage(job.ownerImage),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Flat No: ${job.flatNo}',
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
              style: const TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Job Accepted!')),
                );
              },
              child: const Text('Accept Job'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => _makePhoneCall(job.contactNumber),
              icon: const Icon(Icons.phone),
              label: const Text('Call Owner'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => _launchWhatsApp(job.contactNumber),
              icon: const Icon(Icons.message),
              label: const Text('Chat on WhatsApp'),
            ),
          ],
        ),
      ),
    );
  }
}
