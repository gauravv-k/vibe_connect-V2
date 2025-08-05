import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
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
    _transcriptionSyncTimer =
        Timer.periodic(const Duration(milliseconds: 500), (timer) {
      final currentTranscription = widget.getTranscription();
      if (currentTranscription != _promptController.text) {
        setState(() {
          _promptController.text = currentTranscription;
        });
      }
    });

    _imageGenerationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final currentPrompt = _promptController.text.trim();
      if (currentPrompt.isNotEmpty && currentPrompt != _lastGeneratedPrompt) {
        context.read<ImageCubit>().generateImage(currentPrompt);
        _lastGeneratedPrompt = currentPrompt;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color.fromARGB(255, 0, 0, 0), const Color.fromARGB(255, 195, 218, 253)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            4.0, 4.0, 4.0, MediaQuery.of(context).viewInsets.bottom + 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('assets/images/Wave Loop.json',
                height: 200, width: double.infinity),
            const SizedBox(height: 4),
            TextField(
              controller: _promptController,
              decoration: InputDecoration(
                labelText: "Live Prompt",
                labelStyle: const TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 2),
                ),
                hintText: "Your conversation will appear here...",
                hintStyle: const TextStyle(color: Colors.white38),
              ),
              style: const TextStyle(color: Colors.white),
              maxLines: null, // Dynamic height
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              width: double.infinity,
              child: BlocBuilder<ImageCubit, ImageState>(
                builder: (context, state) {
                  if (state is ImageLoading) {
                    return Center(
                        child: Lottie.asset('assets/images/Loading.json',
                            height: 150));
                  } else if (state is ImageLoaded) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(state.image, fit: BoxFit.cover),
                    );
                  } else if (state is ImageError) {
                    return const Center(
                        child: Text('Try speaking louder and clear.!',
                            style: TextStyle(color: Colors.redAccent)));
                  }
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: const Center(
                      child: Text(
                        'Images will appear here...',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
