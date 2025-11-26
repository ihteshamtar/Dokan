import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/domain/entities/order.dart';
import 'package:untitled3/presentation/provider/cart_provider.dart';
import 'package:untitled3/presentation/provider/order_provider.dart';
import 'package:untitled3/presentation/utils/image_url_formatter.dart';
import 'package:untitled3/presentation/views/orderconformed/order_conforimedscreen.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    void placeOrder(CartProvider cartProvider) async {
      if (cartProvider.cartItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your cart is empty.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final orderData = {
        'shippingAddress': 'sd ilmabad pakistan', // Hardcoded for now
        'contactNumber': '03001234567', // Hardcoded for now
        'city': 'Islamabad', // Hardcoded for now
        'postalCode': '44000', // Hardcoded for now
        'country': 'Pakistan', // Hardcoded for now
        'paymentType': 'cod', // Hardcoded for now
        'userName': 'John Doe', // Hardcoded for now
        'cart': cartProvider.cartItems
            .map((item) => {
                  'productId': item.product.id,
                  'quantity': item.quantity,
                })
            .toList(),
      };

      final Order? newOrder = await orderProvider.placeOrder(orderData);

      if (newOrder != null) {
        cartProvider.clearCart();

        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => OrderConforimedscreen(order: newOrder)),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(orderProvider.error ?? 'Failed to place order.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Shipping Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: Colors.grey),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'sd ilmabad pakistan',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProvider.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartProvider.cartItems[index];
                      return ListTile(
                        leading: item.product.images.isNotEmpty
                            ? Image.network(
                                formatImageUrl(item.product.images.first),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Container(width: 50, height: 50, color: Colors.grey[200]),
                        title: Text(item.product.name),
                        subtitle: Text('Quantity: ${item.quantity}'),
                        trailing: Text('\$${(item.product.price * item.quantity).toStringAsFixed(2)}'),
                      );
                    },
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('\$${cartProvider.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFF5934))),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Consumer<OrderProvider>(
                    builder: (context, orderProvider, child) {
                      return ElevatedButton(
                        onPressed: orderProvider.isLoading ? null : () => placeOrder(cartProvider),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: orderProvider.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Place Order', style: TextStyle(fontSize: 18)),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
