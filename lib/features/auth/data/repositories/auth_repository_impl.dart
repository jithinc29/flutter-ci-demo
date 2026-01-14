import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote);

  final AuthRemoteDataSource _remote;

  @override
  Stream<UserEntity?> authStateChanges() => _remote.authStateChanges();

  @override
  Future<UserEntity?> signIn({
    required String email,
    required String password,
  }) {
    return _remote.signIn(email: email, password: password);
  }

  @override
  Future<UserEntity?> signUp({
    required String email,
    required String password,
  }) {
    return _remote.signUp(email: email, password: password);
  }

  @override
  Future<void> signOut() => _remote.signOut();
}
