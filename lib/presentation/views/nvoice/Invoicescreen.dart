import 'package:flutter/material.dart';
import 'package:untitled3/domain/entities/order.dart';

class Invoicescreen extends StatelessWidget {
  final Order order;
  const Invoicescreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final itemsText = order.items
        .map((item) => '${item.product.name} x ${item.quantity}')
        .join('\n');

    return Scaffold(
      backgroundColor: const Color(0xFFFF5934),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            children: [
              // Back Arrow
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Main Content Container
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Text('Dokan', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        const Text('Transaction Completed', style: TextStyle(fontSize: 18, color: Colors.grey)),
                        const SizedBox(height: 5),
                        Text(order.createdAt.toLocal().toString().split('.')[0], style: const TextStyle(fontSize: 14, color: Colors.grey)),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF4EB),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('\$${order.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4CAF50))),
                        ),
                        const Divider(height: 30),
                        _buildDetailRow('Paid by:', order.shippingAddress), // Assuming user name is in shipping for now
                        _buildDetailRow('Items:', itemsText, crossAxisAlignment: CrossAxisAlignment.start),
                        const Divider(height: 30),
                        _buildDetailRow('Items Price:', '\$${order.totalAmount.toStringAsFixed(2)}'),
                        _buildDetailRow('Discount:', '-0.00 Rs'),
                        _buildDetailRow('Total Bill:', '\$${order.totalAmount.toStringAsFixed(2)}', isTotal: true),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Bottom Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.share, color: Colors.white),
                      label: const Text('Share', style: TextStyle(color: Colors.white, fontSize: 14,fontWeight: FontWeight.w500)),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        side: const BorderSide(color: Colors.white, width: 2),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.download, color: Colors.black),
                      label: const Text('Download',  style: TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.w500),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, {bool isTotal = false, CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Text(title, style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
                fontSize: 16,
                color: isTotal ? const Color(0xFFFF5934) : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
