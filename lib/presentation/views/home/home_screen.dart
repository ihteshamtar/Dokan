import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/presentation/elements/home/product_card.dart';
import 'package:untitled3/presentation/provider/banner_provider.dart';
import 'package:untitled3/presentation/provider/category_provider.dart';
import 'package:untitled3/presentation/provider/product_provider.dart';
import 'package:untitled3/presentation/utils/image_url_formatter.dart';
import 'package:untitled3/presentation/views/cart/carts_screen.dart';
import 'package:untitled3/presentation/views/favorite_screen/favorite_screen.dart';
import 'package:untitled3/presentation/views/home/ProductCategory/product_category.dart';
import 'package:untitled3/presentation/views/notification/notification_screen.dart';
import 'package:untitled3/presentation/views/order/order_screen.dart';
import 'package:untitled3/presentation/views/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
      Provider.of<BannerProvider>(context, listen: false).fetchBanners();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const CartsScreen()));
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderScreen()));
    } else if (index == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoriteScreen()));
    } else if (index == 4) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        leading: IconButton(icon: const Icon(Icons.apps), onPressed: () {}),
        title: const Text("Dokan", style: TextStyle(color: Color(0xFFFF5934))),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notification_add_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<BannerProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const SizedBox(height: 180, child: Center(child: CircularProgressIndicator()));
                }
                if (provider.error != null) {
                  return SizedBox(height: 180, child: Center(child: Text('Error: ${provider.error}')));
                }
                if (provider.banners.isEmpty) {
                  return const SizedBox(height: 180, child: Center(child: Text('No banners available.')));
                }
                final banner = provider.banners.first;
                return Image.network(
                  formatImageUrl(banner.imageUrl),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: TextField(
                controller: _searchController,
                onChanged: (query) {
                  context.read<ProductProvider>().searchProducts(query);
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search for products...',
                  filled: true,
                  fillColor: const Color(0xFFEEF0F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            context.read<ProductProvider>().searchProducts('');
                          },
                        )
                      : null,
                ),
              ),
            ),
            Consumer<CategoryProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.error != null) {
                  return Center(child: Text('Error: ${provider.error}'));
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      provider.categories.length,
                      (index) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductCategory(
                                category: provider.categories[index],
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color(0xFFEEF0F6),
                                child: SizedBox(
                                  width: 56,
                                  height: 42,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(14.0),
                                    child: Image.network(
                                      formatImageUrl(provider.categories[index].image),
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: 60,
                                child: Text(
                                  provider.categories[index].name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Consumer<ProductProvider>(
              builder: (context, provider, child) {
                final bool isSearching = provider.isSearching;
                final productsToShow = isSearching ? provider.searchResults : provider.products;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: Text(
                        isSearching ? 'Search Results' : 'Recommended for you',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 14.0),
                    if (provider.isLoading && !isSearching)
                      const Center(child: CircularProgressIndicator()),
                    if (provider.error != null)
                      Center(child: Text('Error: ${provider.error}')),
                    if (isSearching && productsToShow.isEmpty)
                      const Center(
                          child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text('No products found matching your search.'),
                      )),
                    if (!isSearching || productsToShow.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: productsToShow.length,
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 2 / 4.1,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            final product = productsToShow[index];
                            return ProductCard(
                              productId: product.id,
                              imagePath: product.images.isNotEmpty
                                  ? product.images.first
                                  : '',
                              productName: product.name,
                              price: '\$${product.price.toStringAsFixed(2)}',
                              discountedPrice:
                                  '\$${product.discountedPrice.toStringAsFixed(2)}',
                            );
                          },
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined), activeIcon: Icon(Icons.shopping_cart), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined), activeIcon: Icon(Icons.receipt_long), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), activeIcon: Icon(Icons.favorite), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: ''),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
