import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/data/datasources/api_datasource.dart';
import 'package:untitled3/data/repositories/auth_repository_impl.dart';
import 'package:untitled3/data/repositories/banner_repository_impl.dart';
import 'package:untitled3/data/repositories/cart_repository_impl.dart';
import 'package:untitled3/data/repositories/category_repository_impl.dart';
import 'package:untitled3/data/repositories/order_repository_impl.dart';
import 'package:untitled3/data/repositories/product_repository_impl.dart';
import 'package:untitled3/data/repositories/profile_repository_impl.dart';
import 'package:untitled3/domain/repositories/auth_repository.dart';
import 'package:untitled3/domain/repositories/banner_repository.dart';
import 'package:untitled3/domain/repositories/cart_repository.dart';
import 'package:untitled3/domain/repositories/category_repository.dart';
import 'package:untitled3/domain/repositories/order_repository.dart';
import 'package:untitled3/domain/repositories/product_repository.dart';
import 'package:untitled3/domain/repositories/profile_repository.dart';
import 'package:untitled3/domain/usecases/add_to_cart.dart';
import 'package:untitled3/domain/usecases/create_order.dart';
import 'package:untitled3/domain/usecases/get_banners.dart';
import 'package:untitled3/domain/usecases/get_cart_items.dart';
import 'package:untitled3/domain/usecases/get_categories.dart';
import 'package:untitled3/domain/usecases/get_orders.dart';
import 'package:untitled3/domain/usecases/get_product_by_id.dart';
import 'package:untitled3/domain/usecases/get_products.dart';
import 'package:untitled3/domain/usecases/get_products_by_category.dart';
import 'package:untitled3/domain/usecases/get_profile.dart';
import 'package:untitled3/domain/usecases/login.dart';
import 'package:untitled3/domain/usecases/register.dart';
import 'package:untitled3/domain/usecases/remove_from_cart.dart';
import 'package:untitled3/domain/usecases/update_cart_item.dart';
import 'package:untitled3/presentation/provider/auth_provider.dart';
import 'package:untitled3/presentation/provider/banner_provider.dart';
import 'package:untitled3/presentation/provider/cart_provider.dart';
import 'package:untitled3/presentation/provider/category_provider.dart';
import 'package:untitled3/presentation/provider/order_provider.dart';
import 'package:untitled3/presentation/provider/product_provider.dart';
import 'package:untitled3/presentation/provider/profile_provider.dart';
import 'package:untitled3/presentation/views/login/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Data Layer
        Provider<ApiDataSource>(
          create: (_) => ApiDataSource(),
        ),
        // Domain Layer - Repositories
        ProxyProvider<ApiDataSource, ProductRepository>(
          update: (_, api, __) => ProductRepositoryImpl(apiDataSource: api),
        ),
        ProxyProvider<ApiDataSource, ProfileRepository>(
          update: (_, api, __) => ProfileRepositoryImpl(apiDataSource: api),
        ),
        ProxyProvider<ApiDataSource, AuthRepository>(
          update: (_, api, __) => AuthRepositoryImpl(apiDataSource: api),
        ),
        ProxyProvider<ApiDataSource, CategoryRepository>(
          update: (_, api, __) => CategoryRepositoryImpl(apiDataSource: api),
        ),
        ProxyProvider<ApiDataSource, CartRepository>(
          update: (_, api, __) => CartRepositoryImpl(apiDataSource: api),
        ),
        ProxyProvider<ApiDataSource, OrderRepository>(
          update: (_, api, __) => OrderRepositoryImpl(apiDataSource: api),
        ),
        ProxyProvider<ApiDataSource, BannerRepository>(
          update: (_, api, __) => BannerRepositoryImpl(apiDataSource: api),
        ),

        // Domain Layer - Use Cases
        ProxyProvider<ProductRepository, GetProducts>(
          update: (_, repo, __) => GetProducts(repo),
        ),
        ProxyProvider<ProductRepository, GetProductById>(
          update: (_, repo, __) => GetProductById(repo),
        ),
        ProxyProvider<ProductRepository, GetProductsByCategory>(
          update: (_, repo, __) => GetProductsByCategory(repo),
        ),
        ProxyProvider<ProfileRepository, GetProfile>(
          update: (_, repo, __) => GetProfile(repo),
        ),
        ProxyProvider<AuthRepository, Login>(
          update: (_, repo, __) => Login(repo),
        ),
        ProxyProvider<AuthRepository, Register>(
          update: (_, repo, __) => Register(repo),
        ),
        ProxyProvider<CategoryRepository, GetCategories>(
          update: (_, repo, __) => GetCategories(repo),
        ),
        ProxyProvider<CartRepository, GetCartItems>(
          update: (_, repo, __) => GetCartItems(repo),
        ),
        ProxyProvider<CartRepository, AddToCart>(
          update: (_, repo, __) => AddToCart(repo),
        ),
        ProxyProvider<CartRepository, UpdateCartItem>(
          update: (_, repo, __) => UpdateCartItem(repo),
        ),
        ProxyProvider<CartRepository, RemoveFromCart>(
          update: (_, repo, __) => RemoveFromCart(repo),
        ),
        ProxyProvider<OrderRepository, GetOrders>(
          update: (_, repo, __) => GetOrders(repo),
        ),
        ProxyProvider<OrderRepository, CreateOrder>(
          update: (_, repo, __) => CreateOrder(repo),
        ),
        ProxyProvider<BannerRepository, GetBanners>(
          update: (_, repo, __) => GetBanners(repo),
        ),

        // Presentation Layer - Providers
        ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider(
            getProducts: context.read<GetProducts>(),
            getProductsByCategory: context.read<GetProductsByCategory>(),
            getProductById: context.read<GetProductById>(),
          ),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (context) =>
              ProfileProvider(getProfile: context.read<GetProfile>()),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            loginUseCase: context.read<Login>(),
            registerUseCase: context.read<Register>(),
          ),
        ),
        ChangeNotifierProvider<CategoryProvider>(
          create: (context) => CategoryProvider(
            getCategories: context.read<GetCategories>(),
          ),
        ),
        ChangeNotifierProvider<CartProvider>(
          create: (context) => CartProvider(
            getCartItems: context.read<GetCartItems>(),
            addToCart: context.read<AddToCart>(),
            updateCartItem: context.read<UpdateCartItem>(),
            removeFromCart: context.read<RemoveFromCart>(),
          ),
        ),
        ChangeNotifierProvider<OrderProvider>(
          create: (context) => OrderProvider(
            getOrders: context.read<GetOrders>(),
            createOrder: context.read<CreateOrder>(),
          ),
        ),
        ChangeNotifierProvider<BannerProvider>(
          create: (context) => BannerProvider(
            getBanners: context.read<GetBanners>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Dokan',
        theme: ThemeData(
          primaryColor: const Color(0xFFFF5934),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFF5934),
            primary: const Color(0xFFFF5934),
          ),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
