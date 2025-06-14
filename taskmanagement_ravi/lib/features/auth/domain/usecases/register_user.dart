import 'package:dartz/dartz.dart';

import '../entities/user_entity.dart';
import '../repositories/auth_repo.dart';

class RegisterUser {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<Either<String, UserEntity>> call(
    String email,
    String password,
    String name,
  ) async {
    try {
      final user = await repository.signUpWithEmail(email, password, name);
      return user != null
          ? Right(user)
          : Left('Signup failed: Unable to create user');
    } catch (e) {
      return Left('Signup failed: ${e.toString()}');
    }
  }
}
