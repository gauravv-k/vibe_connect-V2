import 'package:flutter/material.dart';
import 'package:vibe_connect/features/app_bar/app_bar.dart';
import 'package:vibe_connect/features/storage/storage_tile.dart';
import 'package:vibe_connect/features/studioo/studio_page.dart';

class StoragePage extends StatefulWidget {
  const StoragePage({super.key});

  @override
  State<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  final List<Map<String, dynamic>> _storageItems = [
    {'color': const Color(0xFF6C63FF), 'subtitle': 'Monday, 12:30 PM'},
    {'color': const Color(0xFFFA8B7A), 'subtitle': 'Tuesday, 1:00 PM'},
    {'color': const Color(0xFF4ACFAC), 'subtitle': 'Wednesday, 2:30 PM'},
    {'color': const Color(0xFF2C3E50), 'subtitle': 'Thursday, 3:00 PM'},
    {'color': const Color(0xFFF39C12), 'subtitle': 'Friday, 4:30 PM'},
    {'color': const Color(0xFFE74C3C), 'subtitle': 'Saturday, 5:00 PM'},
    {'color': const Color(0xFF8E44AD), 'subtitle': 'Sunday, 6:30 PM'},
    {'color': const Color(0xFF3498DB), 'subtitle': 'Monday, 7:00 PM'},
  ];

  late final ScrollController _scrollController;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _scrollOffset = _scrollController.offset;
        });
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double cardHeight = 150.0;
    final double cardOverlap = 120;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const CustomAppBar(title: "Storage"),
      drawer: const Drawer(),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: (_storageItems.length * cardOverlap) + (cardHeight - cardOverlap),
              child: Stack(
                children: List.generate(_storageItems.length, (index) {
                  final item = _storageItems[index];
                  final double topPosition = index * cardOverlap;
                  final double parallaxEffect = _scrollOffset * 0.8;
                  final double finalTop = topPosition - parallaxEffect;

                  return Positioned(
                    top: finalTop,
                    left: 20,
                    right: 20,
                    height: cardHeight,
                    child: StorageTile(
                      sessionTitle: 'Session ${index + 1}',
                      subtitle: item['subtitle'],
                      color: item['color'],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AiStudioPage()),
                        );
                      },
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
