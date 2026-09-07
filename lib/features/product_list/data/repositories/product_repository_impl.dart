import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/dio_error_mapper.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/product_exception.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final Dio _dio;

  ProductRepositoryImpl({Dio? dio}) : _dio = dio ?? ApiClient.instance.dio;

  @override
  Future<List<ProductModel>> fetchPage({
    required int offset,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.products,
        queryParameters: {'offset': offset, 'limit': limit},
      );

      final data = response.data as List<dynamic>;
      return data
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on ProductException {
      rethrow;
    } on DioException catch (e) {
      throw ProductException(
        mapDioError(e, fallback: 'Gagal memuat produk. Periksa koneksi internet kamu.'),
        statusCode: e.response?.statusCode,
      );
    }
  }
}