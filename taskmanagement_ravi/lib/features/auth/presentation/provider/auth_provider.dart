import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repo.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repo.dart';

// Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(FirebaseAuth.instance);
});

// Auth State (current user)
final authStateProvider = FutureProvider<UserEntity?>((ref) {
  final authRepo = ref.read(authRepositoryProvider);
  return authRepo.getCurrentUser();
});
