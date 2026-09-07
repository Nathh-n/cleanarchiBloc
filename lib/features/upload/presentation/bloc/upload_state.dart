import 'dart:io';

sealed class UploadState {
  const UploadState();
}

final class UploadInitial extends UploadState {
  const UploadInitial();
}

final class UploadPicked extends UploadState {
  const UploadPicked(this.file);

  final File file;
}

final class UploadInProgress extends UploadState {
  const UploadInProgress(this.file);

  final File file;
}

final class UploadSuccess extends UploadState {
  const UploadSuccess({required this.file, required this.url});

  final File file;
  final String url;
}

final class UploadFailure extends UploadState {
  const UploadFailure({required this.file, required this.message});

  final File file;
  final String message;
}