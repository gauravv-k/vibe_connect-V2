import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibe_connect/features/ai_image/logic/cubit/image_cubit.dart';

class DreamBoardBottomSheet extends StatefulWidget {
  final String Function() getTranscription;

  const DreamBoardBottomSheet({
    super.key,
    required this.getTranscription,
  });

  @override
  State<DreamBoardBottomSheet> createState() => _DreamBoardBottomSheetState();
}

class _DreamBoardBottomSheetState extends State<DreamBoardBottomSheet> {
  bool isListening = false;
  String prompt = "";
  Timer? _promptCaptureTimer;
  Timer? _autoStopTimer;
  String _lastTranscription = "";

  @override
  void dispose() {
    _promptCaptureTimer?.cancel();
    _autoStopTimer?.cancel();
    super.dispose();
  }

  void _startListening() {
    setState(() {
      isListening = true;
      prompt = "Listening...";
      _lastTranscription = widget.getTranscription();
    });

    // Check for new transcription text frequently for a real-time feel
    _promptCaptureTimer =
        Timer.periodic(const Duration(milliseconds: 200), (timer) {
      final currentTranscription = widget.getTranscription();
      if (currentTranscription.length > _lastTranscription.length) {
        final newText =
            currentTranscription.substring(_lastTranscription.length).trim();
        if (newText.isNotEmpty) {
          setState(() {
            prompt = (prompt == "Listening...") ? newText : "$prompt $newText";
          });
        }
      }
      _lastTranscription = currentTranscription;
    });

    // Automatically stop listening after 10 seconds
    _autoStopTimer = Timer(const Duration(seconds: 10), () {
      if (isListening) {
        _stopListening();
      }
    });
  }

  void _stopListening() {
    _promptCaptureTimer?.cancel();
    _autoStopTimer?.cancel();
    setState(() {
      isListening = false;
    });
    if (prompt.isNotEmpty && prompt != "Listening...") {
      context.read<ImageCubit>().generateImage(prompt);
    } else {
      setState(() {
        prompt = "No speech detected.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isListening ? "Listening..." : "Tap mic to speak",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          IconButton(
            icon: Icon(isListening ? Icons.mic : Icons.mic_none, size: 40),
            onPressed: isListening ? _stopListening : _startListening,
          ),
          const SizedBox(height: 10),
          if (prompt.isNotEmpty)
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(prompt, textAlign: TextAlign.center),
            ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BlocBuilder<ImageCubit, ImageState>(
              builder: (context, state) {
                if (state is ImageLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ImageLoaded) {
                  return Image.memory(state.image);
                } else if (state is ImageError) {
                  print('Message: ${state.message}');
                  return Center(
                  child: const Text('Something went wrong.'),
                  );
                } else {
                  return const Center(
                      child: Text('Generated image will appear here.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
