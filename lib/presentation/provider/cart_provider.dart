import 'package:flutter/material.dart';
import 'package:untitled3/domain/entities/cart_item.dart';
import 'package:untitled3/domain/usecases/add_to_cart.dart';
import 'package:untitled3/domain/usecases/get_cart_items.dart';
import 'package:untitled3/domain/usecases/remove_from_cart.dart';
import 'package:untitled3/domain/usecases/update_cart_item.dart';

class CartProvider extends ChangeNotifier {
  final GetCartItems getCartItems;
  final AddToCart addToCart;
  final UpdateCartItem updateCartItem;
  final RemoveFromCart removeFromCart;

  CartProvider({
    required this.getCartItems,
    required this.addToCart,
    required this.updateCartItem,
    required this.removeFromCart,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<CartItem> _cartItems = [];
  List<CartItem> get cartItems => _cartItems;

  String? _error;
  String? get error => _error;

  double get totalAmount {
    return _cartItems.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  Future<void> fetchCartItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cartItems = await getCartItems();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addItem(String productId, int quantity) async {
    try {
      await addToCart(productId, quantity);
      await fetchCartItems();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateItemQuantity(String productId, int quantity) async {
    try {
      await updateCartItem(productId, quantity);
      await fetchCartItems(); 
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> removeItem(String productId) async {
    try {
      await removeFromCart(productId);
      await fetchCartItems();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems = [];
    notifyListeners();
  }
}
