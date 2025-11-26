import 'package:untitled3/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<Profile> getProfile();
}
