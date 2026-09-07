import '../../data/models/user_model.dart';

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthSuccess extends AuthState {
  final UserModel user;

  const AuthSuccess(this.user);
}

final class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthFailure && message == other.message;

  @override
  int get hashCode => message.hashCode;
}
