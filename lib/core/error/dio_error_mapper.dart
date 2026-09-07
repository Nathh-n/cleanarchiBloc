import 'package:dio/dio.dart';

String mapDioError(DioException e, {required String fallback}) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return 'Koneksi timeout. Silakan coba lagi.';
    case DioExceptionType.connectionError:
      return 'Tidak ada koneksi internet.';
    case DioExceptionType.badResponse:
      final status = e.response?.statusCode;
      if (status != null && status >= 500) {
        return 'Server sedang bermasalah. Coba lagi nanti.';
      }
      return fallback;
    case DioExceptionType.cancel:
      return 'Permintaan dibatalkan.';
    default:
      return fallback;
  }
}
