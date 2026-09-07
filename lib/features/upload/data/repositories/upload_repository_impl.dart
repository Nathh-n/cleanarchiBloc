import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/dio_error_mapper.dart';
import '../../domain/repositories/upload_repository.dart';
import '../../domain/upload_exception.dart';
import '../models/upload_result.dart';

class UploadRepositoryImpl implements UploadRepository {
  final Dio _dio;

  UploadRepositoryImpl({Dio? dio}) : _dio = dio ?? Dio();

  @override
  Future<UploadResult> uploadMultipart(File imageFile) async {
    try {
      final response = await _dio.post(
        ApiConstants.imgbbBaseUrl,
        queryParameters: {'key': ApiConstants.imgbbApiKey},
        data: FormData.fromMap({
          'image': await MultipartFile.fromFile(imageFile.path),
        }),
      );
      return UploadResult.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw UploadException(
        _mapError(e),
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<UploadResult> uploadBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await _dio.post(
        ApiConstants.imgbbBaseUrl,
        queryParameters: {'key': ApiConstants.imgbbApiKey},
        data: FormData.fromMap({'image': base64Image}),
      );
      return UploadResult.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw UploadException(
        _mapError(e),
        statusCode: e.response?.statusCode,
      );
    }
  }

  String _mapError(DioException e) {
    final status = e.response?.statusCode;
    if (status == 400 || status == 401) {
      return 'Gambar tidak valid, atau API key salah.';
    }
    return mapDioError(e, fallback: 'Gagal upload gambar. Periksa koneksi internet kamu.');
  }
}