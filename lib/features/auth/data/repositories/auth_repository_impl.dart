import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/dio_error_mapper.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/session_manager.dart';
import '../../domain/auth_exception.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;

  AuthRepositoryImpl({Dio? dio}) : _dio = dio ?? ApiClient.instance.dio;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final loginResponse = await _dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      final accessToken = loginResponse.data['access_token'] as String;
      final refreshToken = loginResponse.data['refresh_token'] as String;

      await SessionManager.instance.saveSession(
        accessToken: accessToken,
        refreshToken: refreshToken,
        email: email,
      );

      return await getProfile();
    } on AuthException {
      rethrow;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 ||
          e.response?.statusCode == 401) {
        throw AuthException(
          'Email atau password salah.',
          statusCode: e.response?.statusCode,
        );
      }
      throw AuthException(
        mapDioError(e, fallback: 'Gagal login. Periksa koneksi internet kamu.'),
      );
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await _dio.get(ApiConstants.profile);
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on AuthException {
      rethrow;
    } on DioException catch (e) {
      throw AuthException(
        mapDioError(e, fallback: 'Gagal memuat profil.'),
      );
    }
  }

  @override
  Future<void> logout() async {
    await SessionManager.instance.clearSession();
  }
}
