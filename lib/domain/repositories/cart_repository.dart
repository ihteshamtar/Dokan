import 'package:untitled3/domain/entities/cart_item.dart';

abstract class CartRepository {
  Future<List<CartItem>> getCartItems();
  Future<void> addToCart(String productId, int quantity);
  Future<void> updateCartItem(String productId, int quantity);
  Future<void> removeFromCart(String productId);
}
