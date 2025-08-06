import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vibe_connect/features/app_bar/app_bar.dart';
import 'package:vibe_connect/features/storage/bloc/storage_bloc.dart';
import 'package:vibe_connect/features/storage/storage_tile.dart';
import 'package:vibe_connect/features/studioo/studio_page.dart';
import 'package:vibe_connect/features/app_bar/app_drawer.dart';

class StoragePage extends StatefulWidget {
  const StoragePage({super.key});

  @override
  State<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  late final ScrollController _scrollController;
  double _scrollOffset = 0.0;

  final List<Color> _cardColors = [
    const Color(0xFF6C63FF),
    const Color(0xFFFA8B7A),
    const Color(0xFF4ACFAC),
    const Color(0xFF2C3E50),
    const Color(0xFFF39C12),
    const Color(0xFFE74C3C),
    const Color(0xFF8E44AD),
    const Color(0xFF3498DB),
  ];

  @override
  void initState() {
    super.initState();
    context.read<StorageBloc>().add(LoadMeetings());
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
      backgroundColor: const Color.fromARGB(255, 227, 213, 213),
      appBar: const CustomAppBar(title: "Storage"),
      drawer: const AppDrawer(),
      body: BlocBuilder<StorageBloc, StorageState>(
        builder: (context, state) {
          if (state is StorageLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StorageLoaded) {
            return StreamBuilder<QuerySnapshot>(
              stream: state.meetingsStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                               final meetings = snapshot.data!.docs;
                meetings.sort((a, b) {
                  final dateA = DateTime.parse(a['date'] as String);
                  final dateB = DateTime.parse(b['date'] as String);
                  return dateB.compareTo(dateA);
                });

                return CustomScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: (meetings.length * cardOverlap) +
                            (cardHeight - cardOverlap),
                        child: Stack(
                          children: List.generate(meetings.length, (index) {
                            final meeting = meetings[index];
                            final double topPosition = index * cardOverlap;
                            final double parallaxEffect = _scrollOffset * 0.8;
                            final double finalTop = topPosition - parallaxEffect;
                            final color =
                                _cardColors[index % _cardColors.length];
                            final dateTime = DateTime.parse(meeting['date'] as String);
                            final formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
                            final formattedTime = DateFormat('hh:mm a').format(dateTime);
                            final createdBy = meeting['createdBy'] as String? ?? 'Unknown';

                            return Positioned(
                              top: finalTop,
                              left: 20,
                              right: 20,
                              height: cardHeight,
                              child: Dismissible(
                                key: Key(meeting.id),
                                onDismissed: (direction) {
                                  context
                                      .read<StorageBloc>()
                                      .add(DeleteMeeting(meeting.id));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${meeting['title']} deleted'),
                                    ),
                                  );
                                },
                                background: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 20.0),
                                      child: Icon(Icons.delete,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                child: StorageTile(
                                  sessionTitle: meeting['title'],
                                  subtitle: '$formattedDate at $formattedTime',
                                  createdBy: createdBy,
                                  color: color,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AiStudioPage(
                                          meetingData: meeting.data()
                                              as Map<String, dynamic>,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          } else if (state is StorageError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('No meetings found.'));
        },
      ),
    );
  }
}
