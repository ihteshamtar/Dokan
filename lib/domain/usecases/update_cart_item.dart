import 'package:untitled3/domain/repositories/cart_repository.dart';

class UpdateCartItem {
  final CartRepository repository;

  UpdateCartItem(this.repository);

  Future<void> call(String productId, int quantity) {
    return repository.updateCartItem(productId, quantity);
  }
}
