import 'package:image_picker/image_picker.dart';

sealed class UploadEvent {}

final class ImagePicked extends UploadEvent {
  ImagePicked(this.source);

  final ImageSource source;
}

final class UploadSubmitted extends UploadEvent {
  UploadSubmitted({required this.useBase64});

  final bool useBase64;
}