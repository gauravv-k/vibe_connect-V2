import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AloneMeetPage extends StatelessWidget {
  const AloneMeetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202124), // Exact dark background color
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'sie-smvs-zff',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w500),
            ),
            Icon(Icons.keyboard_arrow_right, color: Colors.white),
          ],
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.flip_camera_ios_outlined, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.volume_up_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    "You're the only one here",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Share this meeting link with others that you want in the meeting',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  // Meeting link box
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3c4043),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'meet.google.com/sie-smvs-zff',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(const ClipboardData(
                                text: 'meet.google.com/sie-smvs-zff'));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Link copied to clipboard')),
                            );
                          },
                          child: const Icon(Icons.copy_outlined,
                              color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Share invite button
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.share, size: 20),
                    label: const Text('Share invite'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color(0xFFa8c7fa),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),

            // Floating self-view video
            Positioned(
              right: 20,
              bottom: 120,
              child: Container(
                height: 160,
                width: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/man.jpeg',
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Row(
                          children: [
                            Icon(Icons.flip_camera_ios_outlined,
                                color: Colors.white.withOpacity(0.8), size: 20),
                            const SizedBox(width: 4),
                            Icon(Icons.more_vert,
                                color: Colors.white.withOpacity(0.8), size: 20),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            // Bottom control buttons
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildControlButton(
                          icon: Icons.videocam_off,
                          onPressed: () {},
                          backgroundColor: const Color(0xFF3c4043)),
                      _buildControlButton(
                          icon: Icons.mic_off,
                          onPressed: () {},
                          backgroundColor: const Color(0xFF3c4043)),
                      _buildControlButton(
                          icon: Icons.sentiment_satisfied_alt_outlined,
                          onPressed: () {},
                          backgroundColor: const Color(0xFF3c4043)),
                      _buildControlButton(
                          icon: Icons.more_horiz,
                          onPressed: () {},
                          backgroundColor: const Color(0xFF3c4043)),
                      _buildControlButton(
                          icon: Icons.call_end,
                          onPressed: () => Navigator.of(context).pop(),
                          backgroundColor: const Color(0xFFea4335)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for control buttons
  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color backgroundColor,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}
