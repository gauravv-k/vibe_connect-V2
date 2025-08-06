
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:vibe_connect/features/app_bar/app_bar.dart';

class ImageGalleryPage extends StatefulWidget {
  final List<String> imageUrls;
  const ImageGalleryPage({super.key, required this.imageUrls});

  @override
  State<ImageGalleryPage> createState() => _ImageGalleryPageState();
}

class _ImageGalleryPageState extends State<ImageGalleryPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate image fetching
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 164, 207, 230),
      appBar: const CustomAppBar(title: "Gallery"),
      body: _isLoading
          ? Center(
              child: Lottie.asset(
                'assets/images/cat_loading.json',
                height: 150,
                width: 150,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: widget.imageUrls.length,
                itemBuilder: (context, index) {
                  return Image.network(widget.imageUrls[index],
                          fit: BoxFit.cover)
                      .animate()
                      .fadeIn(duration: const Duration(milliseconds: 500));
                },
              ),
            ),
    );
  }
}
