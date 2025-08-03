// Auth Cubit : State Management

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibe_connect/features/auth/domain/entities/app_user.dart';
import 'package:vibe_connect/features/auth/domain/repo/auth_repo.dart';
import 'auth_states.dart';

// manges the states of method created in firebase_auth_reop which parameter is declared in auth_repo and state has operation declared like loading initial etc..

class AuthCubit extends Cubit<AuthStates> {
  final AuthRepo authRepo;
  AppUser? _currentUser;

  AuthCubit({required this.authRepo}) : super(AuthInitial());

  //check if user is already authenticated
  Future<void> checkCurrentUser() async {
    emit(AuthLoading());
    try {
      final user = await authRepo.getCurrentUser();
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        _currentUser = null;
        emit(Unauthenticated());
      }
    } catch (e) {
      _currentUser = null;
      emit(AuthError(e.toString()));
    }
  }

  //get current user
  AppUser? get currentuser => _currentUser;

  //loginwith email and pass
  Future<void> loginWithEmailPass(
      String email, String password, BuildContext context) async {
    emit(AuthLoading());
    try {
      final user = await authRepo.loginWithEmailPass(email, password, context);
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        _currentUser = null;
        // Login failed (wrong password, etc.) - return to auth page
        emit(Unauthenticated());
      }
    } catch (e) {
      _currentUser = null;
      // Any authentication error - return to login page instead of showing error
      emit(Unauthenticated());
    }
  }

  // register with email and pass
  Future<void> registerWithEmailPass(
      String email, String password, String name) async {
    emit(AuthLoading());
    try {
      final user = await authRepo.registerWithEmailPass(email, password, name);
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        _currentUser = null;
        emit(Unauthenticated());
      }
    } catch (e) {
      _currentUser = null;
      emit(AuthError(e.toString()));
    }
  }

  //logout method
  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await authRepo.logout();
      _currentUser = null;
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
