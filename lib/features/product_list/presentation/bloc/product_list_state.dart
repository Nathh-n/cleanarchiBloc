import '../../data/models/product_model.dart';

class ProductListState {
  final List<ProductModel> items;
  final int offset;
  final bool hasMore;
  final bool isLoading;
  final String? errorMessage;

  const ProductListState({
    this.items = const [],
    this.offset = 0,
    this.hasMore = true,
    this.isLoading = false,
    this.errorMessage,
  });

  static const Object _keepError = Object();

  ProductListState copyWith({
    List<ProductModel>? items,
    int? offset,
    bool? hasMore,
    bool? isLoading,
    Object? errorMessage = _keepError,
  }) {
    return ProductListState(
      items: items ?? this.items,
      offset: offset ?? this.offset,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: identical(errorMessage, _keepError)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}