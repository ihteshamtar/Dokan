import 'package:untitled3/data/models/product_model.dart';

// A new model to represent an item inside an Order
class OrderItemModel {
  final ProductModel product;
  final int quantity;

  OrderItemModel({required this.product, required this.quantity});

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
    );
  }
}

class OrderModel {
  final String id;
  final List<OrderItemModel> items;
  final double totalAmount;
  final String status;
  final String shippingAddress;
  final String paymentMethod;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    String address = 'N/A';
    if (json['shippingAddress'] is String) {
      address = json['shippingAddress'];
    } else if (json['shippingAddress'] is Map) {
      final addressMap = json['shippingAddress'] as Map<String, dynamic>;
      // This is the fix: Safely join address parts, ignoring any null or empty values.
      final addressParts = [
        addressMap['street'],
        addressMap['city'],
        addressMap['postalCode'],
        addressMap['country']
      ].where((part) => part != null && part.toString().trim().isNotEmpty);
      address = addressParts.join(', ');
      if (address.isEmpty) {
        address = 'Address details not provided';
      }
    }

    // This is the fix: Defensively check for multiple possible keys for total amount.
    final total = json['totalAmount'] ?? json['total'];
    final status = json['status'] ?? json['orderStatus'];
    final itemsList = json['cart'] ?? json['items'];

    return OrderModel(
      id: json['_id'] ?? '',
      items: (itemsList as List? ?? [])
          .map((item) => OrderItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalAmount: (total as num?)?.toDouble() ?? 0.0,
      status: status as String? ?? 'Pending',
      shippingAddress: address,
      paymentMethod: json['paymentType'] as String? ?? 'N/A',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
