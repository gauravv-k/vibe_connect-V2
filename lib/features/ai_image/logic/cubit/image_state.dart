part of 'image_cubit.dart';

sealed class ImageState {}

final class ImageInitial extends ImageState {}

final class ImageLoading extends ImageState {}

final class ImageLoaded extends ImageState {
  final Uint8List image;

  ImageLoaded(this.image);
}

final class ImageError extends ImageState {
  final String message;

  ImageError(this.message);
}