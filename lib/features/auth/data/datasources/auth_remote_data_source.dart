import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/user_entity.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  Stream<UserEntity?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map(_mapUser);
  }

  Future<UserEntity?> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _mapUser(credential.user);
  }

  Future<UserEntity?> signUp({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _mapUser(credential.user);
  }

  Future<void> signOut() => _firebaseAuth.signOut();

  UserEntity? _mapUser(User? user) {
    if (user == null) return null;
    return UserEntity(uid: user.uid, email: user.email);
  }
}
