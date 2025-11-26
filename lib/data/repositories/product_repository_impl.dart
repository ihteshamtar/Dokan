import 'package:untitled3/data/datasources/api_datasource.dart';
import 'package:untitled3/domain/entities/product.dart';
import 'package:untitled3/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ApiDataSource apiDataSource;

  ProductRepositoryImpl({required this.apiDataSource});

  @override
  Future<List<Product>> getProducts() async {
    final productModels = await apiDataSource.getProducts();
    return productModels
        .map((model) => Product(
              id: model.id,
              name: model.name,
              description: model.description,
              price: model.price,
              discountedPrice: model.discountedPrice,
              images: model.images,
              category: model.category,
              stock: model.stock,
              isFeatured: model.isFeatured,
            ))
        .toList();
  }

  @override
  Future<Product> getProductById(String productId) async {
    final model = await apiDataSource.getProductById(productId);
    return Product(
      id: model.id,
      name: model.name,
      description: model.description,
      price: model.price,
      discountedPrice: model.discountedPrice,
      images: model.images,
      category: model.category,
      stock: model.stock,
      isFeatured: model.isFeatured,
    );
  }

  @override
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    final productModels = await apiDataSource.getProductsByCategory(categoryId);
    return productModels
        .map((model) => Product(
              id: model.id,
              name: model.name,
              description: model.description,
              price: model.price,
              discountedPrice: model.discountedPrice,
              images: model.images,
              category: model.category,
              stock: model.stock,
              isFeatured: model.isFeatured,
            ))
        .toList();
  }
}
