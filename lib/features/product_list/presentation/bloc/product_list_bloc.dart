import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/product_exception.dart';
import '../../domain/repositories/product_repository.dart';
import 'product_list_event.dart';
import 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  ProductListBloc(this._repository) : super(const ProductListState()) {
    on<NextPageRequested>(_onNextPageRequested);
    on<RefreshRequested>(_onRefreshRequested);
  }

  final ProductRepository _repository;

  static const int _pageSize = 10;

  Future<void> _onNextPageRequested(
    NextPageRequested event,
    Emitter<ProductListState> emit,
  ) async {
    if (state.isLoading || !state.hasMore) return;

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final newItems = await _repository.fetchPage(
        offset: state.offset,
        limit: _pageSize,
      );

      emit(
        state.copyWith(
          items: [...state.items, ...newItems],
          offset: state.offset + _pageSize,
          hasMore: newItems.length == _pageSize,
          isLoading: false,
          errorMessage: null,
        ),
      );
    } on ProductException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    }
  }

  Future<void> _onRefreshRequested(
    RefreshRequested event,
    Emitter<ProductListState> emit,
  ) async {
    emit(
      state.copyWith(
        items: const [],
        offset: 0,
        hasMore: true,
        isLoading: false,
        errorMessage: null,
      ),
    );
    await _onNextPageRequested(NextPageRequested(), emit);
  }
}