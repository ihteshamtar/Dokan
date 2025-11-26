import 'package:untitled3/domain/entities/profile.dart';
import 'package:untitled3/domain/repositories/profile_repository.dart';

class GetProfile {
  final ProfileRepository repository;

  GetProfile(this.repository);

  Future<Profile> call() {
    return repository.getProfile();
  }
}
