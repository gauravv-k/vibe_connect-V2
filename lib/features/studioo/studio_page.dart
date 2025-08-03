
import 'package:flutter/material.dart';
import '../app_bar/app_bar.dart';
import 'widgets/ai_creation_card.dart';

class AiStudioPage extends StatelessWidget {
  const AiStudioPage({super.key});

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
    final topSpacing = screenHeight * 0.012; // 1.2% of screen height

    return Scaffold(
      appBar: const CustomAppBar(title: "Studio"),
      drawer: const Drawer(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AiCreationCard(
                title: "Image Gallery",
                description: "All the Generated Image media is saved right here..!",
                backgroundImage: "assets/images/ai1.png", // update and use gif and make it live
                shadowColor: Colors.blueAccent,
                onTap: () {
                  // navigate to future pages
                },
              ),
              SizedBox(height: cardSpacing),
              AiCreationCard(
                title: "Follow Ups ",
                description: "Have a follow up to your project , set reminders , schedule the meetings..!",
                backgroundImage: "assets/images/ai2.jpg",
                shadowColor: const Color.fromARGB(213, 141, 68, 173),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
