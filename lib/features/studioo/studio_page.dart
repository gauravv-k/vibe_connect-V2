
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vibe_connect/features/studioo/widgets/followups.dart';
import 'package:vibe_connect/features/studioo/widgets/image_gallery.dart';
import '../app_bar/app_bar.dart';
import 'widgets/ai_creation_card.dart';
import 'package:vibe_connect/features/app_bar/app_drawer.dart';

class AiStudioPage extends StatelessWidget {
  final Map<String, dynamic> meetingData;
  const AiStudioPage({super.key, required this.meetingData});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    // Calculate dynamic padding and spacing based on screen size
    final horizontalPadding = screenWidth * 0.04; // 4% of screen width
    final verticalPadding = screenHeight * 0.020; // 1.5% of screen height
    final cardSpacing = screenHeight * 0.050; // 2.5% of screen height

    return Scaffold(
      appBar: const CustomAppBar(title: "Studio"),
      drawer: const AppDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 164, 85, 123),
              Color(0xFFfffcdc),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding, vertical: verticalPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AiCreationCard(
                  title: "Image Gallery",
                  description:
                      "All the Generated Image media is saved right here..!",
                  background: Image.asset(
                    "assets/images/image_gallery.jpg",
                    fit: BoxFit.cover,
                  ),
                  shadowColor: Colors.blueAccent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageGalleryPage(
                          imageUrls:
                              List<String>.from(meetingData['imageUrls'] ?? []),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: cardSpacing),
                AiCreationCard(
                  title: "Follow Ups ",
                  description:
                      "Have a follow up to your project , set reminders , schedule the meetings..!",
                  background: Lottie.asset('assets/images/Follow.json'),
                  shadowColor: const Color.fromARGB(213, 141, 68, 173),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FollowUpsPage(
                                  title: meetingData['title'] ?? '',
                                  date: meetingData['date'] ?? '',
                                  transcript: meetingData['transcript'] ?? '',
                                )));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
