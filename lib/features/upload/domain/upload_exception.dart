import '../../../../core/error/app_exception.dart';

class UploadException extends AppException {
  const UploadException(super.message, {super.statusCode});
}