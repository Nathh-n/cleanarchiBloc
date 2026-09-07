sealed class AuthEvent {}

final class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  LoginSubmitted({required this.email, required this.password});
}

final class LogoutRequested extends AuthEvent {}
