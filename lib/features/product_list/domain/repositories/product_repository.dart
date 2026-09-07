import '../../data/models/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> fetchPage({
    required int offset,
    int limit = 10,
  });
}