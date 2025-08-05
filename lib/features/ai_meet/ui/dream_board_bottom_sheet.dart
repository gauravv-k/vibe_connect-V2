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
  late final TextEditingController _promptController;
  Timer? _imageGenerationTimer;
  Timer? _transcriptionSyncTimer;
  String _lastGeneratedPrompt = "";

  @override
  void initState() {
    super.initState();
    _promptController = TextEditingController(text: widget.getTranscription());
    _startTimers();
  }

  @override
  void dispose() {
    _imageGenerationTimer?.cancel();
    _transcriptionSyncTimer?.cancel();
    _promptController.dispose();
    super.dispose();
  }

  void _startTimers() {
    // Timer to sync transcription with the text field.
    // This provides the "live text" feel.
    _transcriptionSyncTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      final currentTranscription = widget.getTranscription();
      if (currentTranscription != _promptController.text) {
        setState(() {
          _promptController.text = currentTranscription;
        });
      }
    });

    // Timer to generate images every 5 seconds.
    _imageGenerationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final currentPrompt = _promptController.text.trim();
      
      // Generate image only if the prompt is new and not empty.
      // This prevents redundant API calls for the same text.
      if (currentPrompt.isNotEmpty && currentPrompt != _lastGeneratedPrompt) {
        context.read<ImageCubit>().generateImage(currentPrompt);
        // Store the last prompt that was sent for generation.
        _lastGeneratedPrompt = currentPrompt;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Using Padding with viewInsets to ensure the keyboard doesn't cover the sheet.
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, MediaQuery.of(context).viewInsets.bottom + 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Dream Board",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Generating images from the conversation every 5 seconds.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _promptController,
            decoration: const InputDecoration(
              labelText: "Live Prompt",
              border: OutlineInputBorder(),
              hintText: "Your conversation will appear here...",
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 250,
            width: double.infinity,
            child: BlocBuilder<ImageCubit, ImageState>(
              builder: (context, state) {
                if (state is ImageLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ImageLoaded) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(state.image, fit: BoxFit.cover),
                  );
                } else if (state is ImageError) {
                  return const Center(child: Text('Error generating image.'));
                } else {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Images will appear here...',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
