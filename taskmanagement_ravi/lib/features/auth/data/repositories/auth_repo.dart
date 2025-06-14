import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repo.dart';
import '../datasources/auth_remote_ds.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<UserEntity?> getCurrentUser() => dataSource.getCurrentUser();

  @override
  Future<UserEntity?> signInWithEmail(String email, String password) =>
      dataSource.signInWithEmail(email, password);

  @override
  Future<UserEntity?> signUpWithEmail(
          String email, String password, String name) =>
      dataSource.signUpWithEmail(email, password, name);

  @override
  Future<void> signOut() => dataSource.signOut();
}
