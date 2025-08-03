// auth repo - handles the possible methods in auth features!
// promt - write a methodshere like loginWithEmailPass, registerWithEmailPass , logout , getcurrentUser


import 'package:flutter/material.dart';
import 'package:vibe_connect/features/auth/domain/entities/app_user.dart';

abstract class AuthRepo {
  Future<AppUser?> loginWithEmailPass(
       String email,  String password, BuildContext context);
  Future<AppUser?> registerWithEmailPass(
       String email,  String password, String name);
  Future<void> logout();
  Future<AppUser?> getCurrentUser();
}
