
import 'dart:ui';
import 'package:flutter/material.dart';

class MeetPage extends StatefulWidget {
  const MeetPage({super.key});

  @override
  State<MeetPage> createState() => _MeetPageState();
}

class _MeetPageState extends State<MeetPage> {
  bool isMicMuted = false;
  bool isCameraOff = false;
  bool isDreamBoardOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Remote user's video stream (placeholder)
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=800&q=80',
              fit: BoxFit.cover,
            ),
          ),

          // Local user's video stream (placeholder)
          Positioned(
            top: 40,
            right: 20,
            child: SizedBox(
              width: 120,
              height: 180,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&q=80',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Top buttons
          Positioned(
            top: 50,
            left: 20,
            child: Row(
              children: [
                // Back button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    }, // Back functionality
                  ),
                ),
                const SizedBox(width: 15),
                // Speaker button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.volume_up, color: Colors.white),
                    onPressed: () {}, // Speaker selection functionality
                  ),
                ),
                const SizedBox(width: 15),
                // Switch camera button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
                    onPressed: () {}, // Switch camera functionality
                  ),
                ),
              ],
            ),
          ),

          // Bottom control buttons
          Positioned(
            bottom: 30,
            left: 15,
            right: 15,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Mute/Unmute Mic Button
                      _buildControlButton(
                        icon: isMicMuted ? Icons.mic_off : Icons.mic,
                        label: isMicMuted ? 'Unmute' : 'Mute',
                        backgroundColor: Colors.white.withOpacity(0.3),
                        onTap: () {
                          setState(() {
                            isMicMuted = !isMicMuted;
                          });
                        },
                      ),                      
                      // Turn Camera Off/On Button
                      _buildControlButton(
                        icon: isCameraOff ? Icons.videocam_off : Icons.videocam,
                        label: isCameraOff ? 'Cam On' : 'Cam Off',
                        backgroundColor: Colors.white.withOpacity(0.3),
                        onTap: () {
                          setState(() {
                            isCameraOff = !isCameraOff;
                          });
                        },
                      ),
                      
                      // Dream board button
                      _buildControlButton(
                        icon: isDreamBoardOn ? Icons.image_not_supported_rounded : Icons.image,
                        label: isDreamBoardOn ? 'DreamBoard On' : 'DreamBoard Off',
                        backgroundColor: Colors.white.withOpacity(0.3),
                        onTap: () {
                          setState(() {
                            isDreamBoardOn = !isDreamBoardOn;
                          });
                        },
                      ),

                      // End Call Button
                      _buildControlButton(
                        icon: Icons.call_end,
                        label: 'Leave',
                        backgroundColor: Colors.red,
                        onTap: () {}, // End call functionality
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
