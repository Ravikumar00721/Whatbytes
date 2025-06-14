import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/auth_remote_ds.dart';
import '../../data/repositories/auth_repo.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repo.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/register_user.dart';

// Data Source Provider
final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  return FirebaseAuthDataSource(FirebaseAuth.instance);
});

// Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.read(authDataSourceProvider);
  return AuthRepositoryImpl(dataSource);
});

// Use Case Providers
final loginUserUseCaseProvider = Provider<LoginUser>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return LoginUser(repo);
});

final registerUserUseCaseProvider = Provider<RegisterUser>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return RegisterUser(repo);
});

// Auth State Provider
final authStateProvider = StreamProvider<UserEntity?>((ref) {
  final auth = FirebaseAuth.instance;
  return auth.authStateChanges().asyncMap((user) async {
    if (user != null) {
      final dataSource = ref.read(authDataSourceProvider);
      return await dataSource.getCurrentUser();
    }
    return null;
  });
});
