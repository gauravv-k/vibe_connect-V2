import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:vibe_connect/features/auth/domain/entities/app_user.dart';
import 'package:vibe_connect/features/auth/domain/repo/auth_repo.dart';

// write a code for firebaseAuthRepo implemnts Authrepo and give methods with comments to write logic
// handles the methods parameters working from  auth_repo

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // Helper method to get user-friendly error messages
  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password sign in is not enabled.';
      case 'weak-password':
        return 'The password is too weak. Please choose a stronger password.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email address but different sign-in credentials.';
      case 'requires-recent-login':
        return 'This operation requires recent authentication. Please log in again.';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }

  @override
  Future<AppUser?> loginWithEmailPass(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      //fetch user doc from db
      DocumentSnapshot userData = await firebaseFirestore
          .collection('user')
          .doc(userCredential.user!.uid)
          .get();
      //create user
      AppUser user = AppUser(
        Uid: userCredential.user!.uid,
        email: email,
        name: userData['name'] ?? '',
      );
      return user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<AppUser?> registerWithEmailPass(
    String email,
    String password,
    String name,
  ) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      //create user
      AppUser user = AppUser(
        Uid: userCredential.user!.uid,
        email: email,
        name: name,
      );
      // save the data in firestore with additional profile fields
      await firebaseFirestore.collection('user').doc(user.Uid).set({
        ...user.toJson(),
        'bio': '', // Default empty bio
        'profileImageUrl': '', // Default empty profile image URL
      });

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e));
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    try {
      final firebaseUser = firebaseAuth.currentUser;

      //no user logged in
      if (firebaseUser == null) {
        return null;
      }

      // Fetch user data from Firestore
      final userDoc = await firebaseFirestore
          .collection('user')
          .doc(firebaseUser.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        final userData = userDoc.data()!;
        return AppUser(
          Uid: firebaseUser.uid,
          email: userData['email'] ?? firebaseUser.email!,
          name: userData['name'] ?? '',
        );
      } else {
        // Fallback if Firestore data not found
        return AppUser(
          Uid: firebaseUser.uid,
          email: firebaseUser.email!,
          name: firebaseUser.displayName ?? '',
        );
      }
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }
}
