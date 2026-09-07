import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> getProfile();
  Future<void> logout();
}
