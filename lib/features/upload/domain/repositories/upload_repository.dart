import 'dart:io';

import '../../data/models/upload_result.dart';

abstract class UploadRepository {
  Future<UploadResult> uploadMultipart(File imageFile);
  Future<UploadResult> uploadBase64(File imageFile);
}