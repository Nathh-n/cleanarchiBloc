import '../../../../core/error/app_exception.dart';

class ProductException extends AppException {
  const ProductException(super.message, {super.statusCode});
}