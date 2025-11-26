import 'package:untitled3/domain/entities/cart_item.dart';
import 'package:untitled3/domain/repositories/cart_repository.dart';

class GetCartItems {
  final CartRepository repository;

  GetCartItems(this.repository);

  Future<List<CartItem>> call() {
    return repository.getCartItems();
  }
}
