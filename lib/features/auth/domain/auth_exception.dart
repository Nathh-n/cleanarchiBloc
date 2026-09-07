import '../../../core/error/app_exception.dart';

class AuthException extends AppException {
  const AuthException(super.message, {super.statusCode});
}
