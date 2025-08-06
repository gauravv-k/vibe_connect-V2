import 'package:flutter/material.dart';
import 'package:vibe_connect/features/ai_meet/additional%20ui/testui/join_screen.dart';
import 'package:vibe_connect/features/ai_meet/additional%20ui/askjoin.dart';
import 'package:vibe_connect/features/ai_meet/ui/home_page.dart';
import 'package:vibe_connect/features/ai_meet/ui/meet_page.dart';
import 'package:vibe_connect/features/storage/storage.dart';
import 'package:vibe_connect/features/ai_image/presentation/pages/image_generation_page.dart';
import 'package:vibe_connect/features/profile/profile_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 1; // AI meet is selected by default

  // Commented out navigation screens as requested
  final List<Widget> _screens = [
    const ImageGenerationPage(),
           HomePage(),
    const StoragePage(),
    const ProfilePage(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: const Color(0xFF58A0C8),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFdbe7f3),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: SafeArea(
          child: Padding(
            // Increased padding for better touch area
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(0, 'image.png', 'Ai Image'),
                _buildNavItem(1, 'zoom.png', 'Meet'),
                _buildNavItem(2, 'folder.png', 'Storage'),
                _buildNavItem(3, 'user.png', 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String iconPath, String label) {
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        child: Container(
          // Increased padding for larger touch area
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 3),
          // Added margin for better spacing
          //margin: const EdgeInsets.symmetric(horizontal: 1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 38,
                decoration: isSelected
                    ? BoxDecoration(
                        color: const Color.fromARGB(
                            60, 198, 88, 245), // Purple background for selected
                        borderRadius: BorderRadius.circular(10),
                      )
                    : BoxDecoration(
                        // Added subtle background for unselected items
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                child: Center(
                  child: Image.asset('assets/images/$iconPath',
                      width: 25,
                      height: 25,
                      color: isSelected
                          ? const Color.fromARGB(255, 198, 88, 245)
                          : Colors
                              .grey // White for selected, gray for unselected
                      ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? Color.fromARGB(255, 198, 88, 245)
                      : Colors.grey,
                  fontSize: 9,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w700, // Always bold
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
