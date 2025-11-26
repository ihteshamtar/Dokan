import 'package:untitled3/domain/entities/product.dart';

class OrderItem {
  final Product product;
  final int quantity;

  OrderItem({required this.product, required this.quantity});
}
