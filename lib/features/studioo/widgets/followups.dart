import 'package:flutter/material.dart';
import 'package:vibe_connect/features/app_bar/app_bar.dart';

class FollowUpsPage extends StatelessWidget {
  final String title;
  final String date;
  final String transcript;

  const FollowUpsPage({
    super.key,
    required this.title,
    required this.date,
    required this.transcript,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 199, 253, 233),
      appBar: const CustomAppBar(title: "Follow Ups"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              date,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(transcript),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
