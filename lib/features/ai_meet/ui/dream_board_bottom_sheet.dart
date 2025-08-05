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
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startListening() {
    setState(() {
      isListening = true;
      prompt = "Listening...";
    });

    final startTranscription = widget.getTranscription();

    _timer = Timer(const Duration(seconds: 10), () {
      if (isListening) {
        _stopListening();
        final endTranscription = widget.getTranscription();
        String generatedPrompt = "";
        if (endTranscription.length > startTranscription.length) {
          generatedPrompt =
              endTranscription.substring(startTranscription.length).trim();
        }

        if (generatedPrompt.isNotEmpty) {
          setState(() {
            prompt = generatedPrompt;
          });
          context.read<ImageCubit>().generateImage(generatedPrompt);
        } else {
          setState(() {
            prompt = "No speech detected.";
          });
        }
      }
    });
  }

  void _stopListening() {
    setState(() {
      isListening = false;
    });
    _timer?.cancel();
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
            onPressed: isListening ? null : _startListening,
          ),
          const SizedBox(height: 10),
          if (prompt.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(prompt),
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
                  return Center(child: Text(state.message));
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
