import 'package:untitled3/domain/repositories/auth_repository.dart';

class Register {
  final AuthRepository repository;

  Register(this.repository);

  Future<void> call(String name, String email, String password, String phoneNumber, String shopName, String shopAddress) async {
    await repository.register(name, email, password, phoneNumber, shopName, shopAddress);
  }
}
