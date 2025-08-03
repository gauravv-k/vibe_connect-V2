import 'dart:convert';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

part 'image_state.dart';

class ImageCubit extends Cubit<ImageState> {
  ImageCubit() : super(ImageInitial());

  // Replace with your actual API key
  final _apiKey = 'AIzaSyD5mQLZhXaxT4ye9Ew99veYG89gegkZBEk';

  Future<void> generateImage(String prompt) async {
    emit(ImageLoading());

    try {
      final uri = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/'
        'models/gemini-2.0-flash-preview-image-generation'
        ':generateContent?key=$_apiKey',
      );

      // Correct placement of responseModalities under generationConfig :contentReference[oaicite:0]{index=0}
      final body = jsonEncode({
        "contents": [
          {
            "role": "user",
            "parts": [
              {"text": prompt}
            ]
          }
        ],
        "generationConfig": {
          "responseModalities": ["TEXT", "IMAGE"],
          "temperature": 0.7
        }
      });

      final resp = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (resp.statusCode != 200) {
        emit(ImageError("HTTP ${resp.statusCode}: ${resp.body}"));
        return;
      }

      final decoded = jsonDecode(resp.body);
      final candidates = decoded['candidates'] as List<dynamic>?;

      if (candidates == null || candidates.isEmpty) {
        emit(ImageError("No candidates in response"));
        return;
      }

      final parts = candidates[0]['content']['parts'] as List<dynamic>;
      for (final p in parts) {
        // Look for inlineData (base64-encoded image) :contentReference[oaicite:1]{index=1}
        if (p['inlineData'] != null) {
          final inline = p['inlineData'] as Map<String, dynamic>;
          final data = inline['data'] as String;
          final bytes = base64Decode(data);
          emit(ImageLoaded(bytes));
          return;
        }
      }

      emit(ImageError("No image data found in response."));
    } catch (e) {
      emit(ImageError("Exception: $e"));
    }
  }
}
