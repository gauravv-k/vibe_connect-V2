import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibe_connect/features/ai_image/logic/cubit/image_cubit.dart';

class ImageGenerationPage extends StatelessWidget {
  const ImageGenerationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Image Generation'),
      ),
      body: BlocProvider(
        create: (context) => ImageCubit(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Enter a prompt',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<ImageCubit, ImageState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        context
                            .read<ImageCubit>()
                            .generateImage(controller.text);
                      }
                    },
                    child: const Text('Generate Image'),
                  );
                },
              ),
              const SizedBox(height: 16),
              Expanded(
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
                          child: Text('Enter a prompt to generate an image.'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
