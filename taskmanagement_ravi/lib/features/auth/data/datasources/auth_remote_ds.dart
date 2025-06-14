import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

abstract class AuthDataSource {
  Future<UserEntity?> getCurrentUser();
  Future<UserEntity?> signInWithEmail(String email, String password);
  Future<UserEntity?> signUpWithEmail(
      String email, String password, String name);
  Future<void> signOut();
}

class FirebaseAuthDataSource implements AuthDataSource {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthDataSource(this._firebaseAuth);

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      return user != null ? UserModel.fromFirebaseUser(user) : null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  @override
  Future<UserEntity?> signInWithEmail(String email, String password) async {
    try {
      final cred = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel.fromFirebaseUser(cred.user!);
    } catch (e) {
      print('Login failed: $e');
      rethrow;
    }
  }

  @override
  Future<UserEntity?> signUpWithEmail(
      String email, String password, String name) async {
    try {
      final cred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await cred.user!.updateDisplayName(name);
      return UserModel.fromFirebaseUser(cred.user!);
    } catch (e) {
      print('Signup failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Sign out failed: $e');
    }
  }
}
