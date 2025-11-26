import 'package:untitled3/data/datasources/api_datasource.dart';
import 'package:untitled3/domain/entities/cart_item.dart';
import 'package:untitled3/domain/entities/product.dart';
import 'package:untitled3/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final ApiDataSource apiDataSource;

  CartRepositoryImpl({required this.apiDataSource});

  @override
  Future<List<CartItem>> getCartItems() async {
    final cartItemModels = await apiDataSource.getCartItems();
    return cartItemModels.map((model) {
      final productEntity = Product(
        id: model.product.id,
        name: model.product.name,
        description: model.product.description,
        price: model.product.price,
        discountedPrice: model.product.discountedPrice,
        images: model.product.images,
        category: model.product.category,
        stock: model.product.stock,
        isFeatured: model.product.isFeatured,
      );
      return CartItem(product: productEntity, quantity: model.quantity);
    }).toList();
  }

  @override
  Future<void> addToCart(String productId, int quantity) {
    return apiDataSource.addToCart(productId, quantity);
  }

  @override
  Future<void> updateCartItem(String productId, int quantity) {
    return apiDataSource.updateCartItem(productId, quantity);
  }

  @override
  Future<void> removeFromCart(String productId) {
    return apiDataSource.removeFromCart(productId);
  }
}
