import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/domain/entities/category.dart';
import 'package:untitled3/presentation/elements/home/product_card.dart';
import 'package:untitled3/presentation/provider/product_provider.dart';

class ProductCategory extends StatefulWidget {
  final Category category;

  const ProductCategory({super.key, required this.category});

  @override
  State<ProductCategory> createState() => _ProductCategoryState();
}

class _ProductCategoryState extends State<ProductCategory> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false)
          .fetchProductsByCategory(widget.category.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final brandLogos = [
      'assets/brand1.png',
      'assets/brand2.png',
      'assets/brand3.png',
      'assets/brand5.png',
      'assets/brnad6.png',
      'assets/brnad7.png',
    ];
    final brandNames = [
      'brand',
      'neon',
      'brand',
      'neon',
      'brand',
      'neon',
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Image.network(
                      widget.category.image,
                      width: 46,
                      height: 33,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      widget.category.name,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 23),
                const Text(
                  "Choose Brands",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      brandLogos.length,
                      (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: _selectedIndex == index
                                    ? const Color(0xFFFF5934).withOpacity(0.1)
                                    : const Color(0xFFEEF0F6),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(brandLogos[index]),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                brandNames[index],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: _selectedIndex == index
                                      ? const Color(0xFFFF5934)
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "${brandNames[_selectedIndex]}'s ${widget.category.name}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                Consumer<ProductProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (provider.error != null) {
                      return Center(child: Text('Error: ${provider.error}'));
                    }
                    if (provider.products.isEmpty) {
                      return const Center(child: Text('No products in this category.'));
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.products.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 2 / 4.1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        final product = provider.products[index];
                        return ProductCard(
                          productId: product.id,
                          imagePath: product.images.isNotEmpty ? product.images.first : '',
                          productName: product.name,
                          price: '\$${product.price.toStringAsFixed(2)}',
                          discountedPrice: '\$${product.discountedPrice.toStringAsFixed(2)}',
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
