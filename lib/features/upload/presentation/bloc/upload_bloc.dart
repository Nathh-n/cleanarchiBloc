import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/repositories/upload_repository.dart';
import '../../domain/upload_exception.dart';
import 'upload_event.dart';
import 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  UploadBloc(this._repository) : super(const UploadInitial()) {
    on<ImagePicked>(_onImagePicked);
    on<UploadSubmitted>(_onUploadSubmitted);
  }

  final UploadRepository _repository;
  final ImagePicker _picker = ImagePicker();

  Future<void> _onImagePicked(
    ImagePicked event,
    Emitter<UploadState> emit,
  ) async {
    final picked = await _picker.pickImage(
      source: event.source,
      imageQuality: 80,
    );
    if (picked == null) return;

    emit(UploadPicked(File(picked.path)));
  }

  Future<void> _onUploadSubmitted(
    UploadSubmitted event,
    Emitter<UploadState> emit,
  ) async {
    final file = switch (state) {
      UploadPicked(:final file) => file,
      UploadSuccess(:final file) => file,
      UploadFailure(:final file) => file,
      _ => null,
    };
    if (file == null) return;

    emit(UploadInProgress(file));
    try {
      final result = event.useBase64
          ? await _repository.uploadBase64(file)
          : await _repository.uploadMultipart(file);
      emit(UploadSuccess(file: file, url: result.url));
    } on UploadException catch (e) {
      emit(UploadFailure(file: file, message: e.message));
    }
  }
}