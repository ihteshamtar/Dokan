import 'package:untitled3/data/datasources/api_datasource.dart';
import 'package:untitled3/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiDataSource apiDataSource;

  AuthRepositoryImpl({required this.apiDataSource});

  @override
  Future<String> login(String email, String password) async {
    return await apiDataSource.login(email, password);
  }

  @override
  Future<void> register(String name, String email, String password, String phoneNumber, String shopName, String shopAddress) async {
    await apiDataSource.register(name, email, password, phoneNumber, shopName, shopAddress);
  }
}
