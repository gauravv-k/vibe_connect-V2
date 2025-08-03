import '../../domain/entities/user_profile.dart';

abstract class ProfileStates {}

class ProfileInitial extends ProfileStates {}

class ProfileLoading extends ProfileStates {}

class ProfileLoaded extends ProfileStates {
  final UserProfile profile;
  ProfileLoaded(this.profile);
}

class ProfileError extends ProfileStates {
  final String message;
  ProfileError(this.message);
}

class ProfileNotFound extends ProfileStates {} 