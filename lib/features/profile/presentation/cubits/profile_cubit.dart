import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repo/profile_repo.dart';
import 'profile_states.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final ProfileRepo profileRepo;
  UserProfile? _currentProfile;

  ProfileCubit({required this.profileRepo}) : super(ProfileInitial());

  // Get current profile
  UserProfile? get currentProfile => _currentProfile;

  // Fetch user profile by user ID
  Future<void> fetchUserProfile(String userId) async {
    emit(ProfileLoading());
    try {
      final profile = await profileRepo.getUserProfile(userId);
      if (profile != null) {
        _currentProfile = profile;
        emit(ProfileLoaded(profile));
      } else {
        _currentProfile = null;
        emit(ProfileNotFound());
      }
    } catch (e) {
      _currentProfile = null;
      emit(ProfileError(e.toString()));
    }
  }

  // Update user profile
  Future<void> updateUserProfile(UserProfile profile) async {
    emit(ProfileLoading());
    try {
      await profileRepo.updateUserProfile(profile);
      _currentProfile = profile;
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  // Create user profile
  Future<void> createUserProfile(UserProfile profile) async {
    emit(ProfileLoading());
    try {
      await profileRepo.createUserProfile(profile);
      _currentProfile = profile;
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  // Clear profile data
  void clearProfile() {
    _currentProfile = null;
    emit(ProfileInitial());
  }
} 