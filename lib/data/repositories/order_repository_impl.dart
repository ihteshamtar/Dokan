import 'package:untitled3/data/datasources/api_datasource.dart';
import 'package:untitled3/domain/entities/order.dart';
import 'package:untitled3/domain/entities/order_item.dart';
import 'package:untitled3/domain/entities/product.dart';
import 'package:untitled3/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final ApiDataSource apiDataSource;

  OrderRepositoryImpl({required this.apiDataSource});

  @override
  Future<List<Order>> getOrders() async {
    final orderModels = await apiDataSource.getOrders();
    return orderModels.map((model) {
      final List<OrderItem> items = model.items.map((itemModel) {
        final product = Product(
          id: itemModel.product.id,
          name: itemModel.product.name,
          description: itemModel.product.description,
          price: itemModel.product.price,
          discountedPrice: itemModel.product.discountedPrice,
          images: itemModel.product.images,
          category: itemModel.product.category,
          stock: itemModel.product.stock,
          isFeatured: itemModel.product.isFeatured,
        );
        return OrderItem(product: product, quantity: itemModel.quantity);
      }).toList();

      return Order(
        id: model.id,
        items: items,
        totalAmount: model.totalAmount,
        status: model.status,
        shippingAddress: model.shippingAddress,
        paymentMethod: model.paymentMethod,
        createdAt: model.createdAt,
      );
    }).toList();
  }

  @override
  Future<Order> createOrder(Map<String, dynamic> orderData) async {
    final orderModel = await apiDataSource.createOrder(orderData);

    final List<OrderItem> items = orderModel.items.map((itemModel) {
      final product = Product(
        id: itemModel.product.id,
        name: itemModel.product.name,
        description: itemModel.product.description,
        price: itemModel.product.price,
        discountedPrice: itemModel.product.discountedPrice,
        images: itemModel.product.images,
        category: itemModel.product.category,
        stock: itemModel.product.stock,
        isFeatured: itemModel.product.isFeatured,
      );
      return OrderItem(product: product, quantity: itemModel.quantity);
    }).toList();

    return Order(
      id: orderModel.id,
      items: items,
      totalAmount: orderModel.totalAmount,
      status: orderModel.status,
      shippingAddress: orderModel.shippingAddress,
      paymentMethod: orderModel.paymentMethod,
      createdAt: orderModel.createdAt,
    );
  }
}
