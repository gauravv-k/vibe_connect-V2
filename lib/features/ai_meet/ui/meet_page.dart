import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vibe_connect/features/ai_image/logic/cubit/image_cubit.dart';
import 'package:vibe_connect/features/ai_meet/ui/dream_board_bottom_sheet.dart';
import 'package:vibe_connect/features/ai_meet/ui/participant_tile.dart';
import 'package:videosdk/videosdk.dart';
import 'package:android_pip/android_pip.dart';

class MeetPage extends StatefulWidget {
  final String meetingId;
  final String token;
  const MeetPage({super.key, required this.meetingId, required this.token});

  @override
  State<MeetPage> createState() => _MeetPageState();
}

class _MeetPageState extends State<MeetPage> with WidgetsBindingObserver {
  bool isMicMuted = false;
  bool isCameraOff = false;
  bool isDreamBoardOn = false;
  String transcriptionText = "";
  bool isRearCamera = false;
  bool _isInPipMode = false;
  final _androidPip = AndroidPIP();
  late Room _room;
  Map<String, Participant> participants = {};

  // Event listener callbacks
  void onRoomJoined() {
    _room.startTranscription();
    setState(() {
      participants.putIfAbsent(
        _room.localParticipant.id,
        () => _room.localParticipant,
      );
    });
  }

  void onParticipantJoined(Participant participant) {
    setState(() {
      participants.putIfAbsent(participant.id, () => participant);
    });
  }

  void onParticipantLeft(String participantId) {
    if (participants.containsKey(participantId)) {
      setState(() {
        participants.remove(participantId);
      });
    }
  }

  void onRoomLeft() {
    participants.clear();
    Navigator.pop(context);
  }

  void _onTranscription(dynamic transcription) {
    setState(() {
      transcriptionText = transcription.text;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _room = VideoSDK.createRoom(
      roomId: widget.meetingId,
      token: widget.token,
      displayName: "John Doe",
      micEnabled: !isMicMuted,
      camEnabled: !isCameraOff,
      defaultCameraIndex: kIsWeb ? 0 : 1,
    );

    setMeetingEventListener();
    _room.join();
  }

  @override
  void dispose() {
    _room.stopTranscription();
    participants.clear();
    _room.leave();
    _room.off(Events.roomJoined, onRoomJoined);
    _room.off(Events.participantJoined, onParticipantJoined);
    _room.off(Events.participantLeft, onParticipantLeft);
    _room.off(Events.roomLeft, onRoomLeft);
    _room.off(Events.transcriptionText, _onTranscription);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            setState(() {
              _isInPipMode = false;
            });
          }
        });
        if (!isCameraOff) {
          _room.enableCam();
        }
        break;
      case AppLifecycleState.paused:
        if (!_isInPipMode) {
          _room.disableCam();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  void setMeetingEventListener() {
    _room.on(Events.roomJoined, onRoomJoined);
    _room.on(Events.participantJoined, onParticipantJoined);
    _room.on(Events.participantLeft, onParticipantLeft);
    _room.on(Events.roomLeft, onRoomLeft);
    _room.on(Events.transcriptionText, _onTranscription);
  }

  void _leaveMeeting() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_isInPipMode) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: participants.length > 1
            ? ParticipantTile(
                participant: participants.values.firstWhere((p) => !p.isLocal),
                mirror: false,
              )
            : const SizedBox.shrink(),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: participants.length > 1
                ? ParticipantTile(
                    participant:
                        participants.values.firstWhere((p) => !p.isLocal),
                    mirror: true,
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                            style:
                                TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                          const SizedBox(height: 30),
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
                                Text(
                                  widget.meetingId,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(
                                        ClipboardData(text: widget.meetingId));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Link copied to clipboard')),
                                    );
                                  },
                                  child: const Icon(Icons.copy_outlined,
                                      color: Colors.white, size: 20),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () {
                              Share.share(widget.meetingId);
                            },
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
                  ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: SizedBox(
              width: 120,
              height: 180,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: participants.isNotEmpty
                    ? ParticipantTile(
                        participant: _room.localParticipant,
                        mirror: !isRearCamera,
                      )
                    : Image.network(
                        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&q=80',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Row(
              children: [
                _buildTopIcon(Icons.arrow_back, () async {
                  if (defaultTargetPlatform != TargetPlatform.android) return;
                  setState(() {
                    _isInPipMode = true;
                  });
                  try {
                    final success = await _androidPip
                        .enterPipMode(aspectRatio: const [16, 9]);
                    if (!success) {
                      setState(() {
                        _isInPipMode = false;
                      });
                      if (context.mounted) Navigator.pop(context);
                    }
                  } catch (e) {
                    setState(() {
                      _isInPipMode = false;
                    });
                    debugPrint('Error entering PIP mode: $e');
                    if (context.mounted) Navigator.pop(context);
                  }
                }),
                const SizedBox(width: 15),
                _buildTopIcon(Icons.volume_up, () {
                  // TODO: Speaker toggle logic (optional)
                }),
                const SizedBox(width: 15),
                _buildTopIcon(Icons.flip_camera_ios, () async {
                  final devices = await VideoSDK.getVideoDevices();
                  if (devices!.length > 1) {
                    final current = _room.selectedCamId;
                    final other = devices.firstWhere(
                        (d) => d.deviceId != current,
                        orElse: () => devices.first);
                    _room.changeCam(other);
                    setState(() {
                      isRearCamera = !isRearCamera;
                    });
                  }
                }),
              ],
            ),
          ),
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
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildControlButton(
                        icon: isMicMuted ? Icons.mic_off : Icons.mic,
                        label: isMicMuted ? 'Unmute' : 'Mute',
                        backgroundColor: Colors.white.withOpacity(0.3),
                        onTap: () {
                          setState(() {
                            isMicMuted = !isMicMuted;
                          });
                          isMicMuted ? _room.muteMic() : _room.unmuteMic();
                        },
                      ),
                      _buildControlButton(
                        icon: isCameraOff ? Icons.videocam_off : Icons.videocam,
                        label: isCameraOff ? 'Cam On' : 'Cam Off',
                        backgroundColor: Colors.white.withOpacity(0.3),
                        onTap: () {
                          setState(() {
                            isCameraOff = !isCameraOff;
                          });
                          isCameraOff ? _room.disableCam() : _room.enableCam();
                        },
                      ),
                      _buildControlButton(
                        icon: isDreamBoardOn
                            ? Icons.image_not_supported_rounded
                            : Icons.image,
                        label:
                            isDreamBoardOn ? 'DreamBoard On' : 'DreamBoard Off',
                        backgroundColor: Colors.white.withOpacity(0.3),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => BlocProvider(
                              create: (context) => ImageCubit(),
                              child: DreamBoardBottomSheet(
                                getTranscription: () => transcriptionText,
                              ),
                            ),
                          );
                        },
                      ),
                      _buildControlButton(
                        icon: Icons.call_end,
                        label: 'Leave',
                        backgroundColor: Colors.red,
                        onTap: _leaveMeeting,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (transcriptionText.isNotEmpty)
            Positioned(
              bottom: 120,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                color: Colors.white.withOpacity(0.8),
                child: Text(
                  transcriptionText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTopIcon(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onTap,
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
