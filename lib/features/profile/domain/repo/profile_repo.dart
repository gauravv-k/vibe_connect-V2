import '../entities/user_profile.dart';

abstract class ProfileRepo {
  Future<UserProfile?> getUserProfile(String userId);
  Future<void> updateUserProfile(UserProfile profile);
  Future<void> createUserProfile(UserProfile profile);
} 