import 'package:dartz/dartz.dart';

import '../entities/user_entity.dart';
import '../repositories/auth_repo.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<Either<String, UserEntity>> call(String email, String password) async {
    try {
      final user = await repository.signInWithEmail(email, password);
      return user != null ? Right(user) : Left('Login failed: User not found');
    } catch (e) {
      return Left('Login failed: ${e.toString()}');
    }
  }
}
