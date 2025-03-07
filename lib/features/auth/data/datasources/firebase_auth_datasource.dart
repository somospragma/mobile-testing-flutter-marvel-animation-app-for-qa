import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/entities/entity_either.dart';
import '../../../../core/network/error/failures.dart';
import '../../domain/models/user_model.dart';

final AutoDisposeProvider<FirebaseAuthDataSource>
    firebaseAuthDataSourceProvider =
    Provider.autoDispose<FirebaseAuthDataSource>(
        (Ref<FirebaseAuthDataSource> ref) {
  return FirebaseAuthDataSource(FirebaseAuth.instance);
});

class FirebaseAuthDataSource {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthDataSource(this._firebaseAuth);

  Future<Either<Failure, UserModel>> logIn(
      String email, String password) async {
    try {
      final UserCredential credential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(_mapFirebaseUserToEntity(credential.user));
    } on FirebaseAuthException catch (e) {
      String message = 'An error has occurred';

      return Left(ServerFailure(e.message ?? message, 500));
    } catch (e) {
      return Left(ServerFailure(e.toString(), 500));
    }
  }

  Future<Either<Failure, UserModel>> signUp(
      String email, String password) async {
    try {
      final UserCredential credential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(_mapFirebaseUserToEntity(credential.user));
    } on FirebaseAuthException catch (e) {
      String message = 'An error has occurred';

      return Left(ServerFailure(e.message ?? message, 500));
    } catch (e) {
      return Left(ServerFailure(e.toString(), 500));
    }
  }

  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    return user != null ? _mapFirebaseUserToEntity(user) : null;
  }

  UserModel _mapFirebaseUserToEntity(User? user) {
    return UserModel(
      uid: user!.uid,
      email: user.email!,
      displayName: user.displayName,
    );
  }
}
