import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/entities/entity_either.dart';
import '../../../../core/network/error/failures.dart';
import '../models/user_model.dart';

final AutoDisposeProvider<FirebaseAuthDataSource>
    firebaseAuthDataSourceProvider =
    Provider.autoDispose<FirebaseAuthDataSource>(
        (Ref<FirebaseAuthDataSource> ref) {
  return FirebaseAuthDataSource(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
  );
});

class FirebaseAuthDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthDataSource(this._firebaseAuth, this._firestore);

  Future<Either<Failure, UserModel>> signUp(UserModel params) async {
    try {
      // Crear usuario en Firebase Auth
      final UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: params.email,
        password: params.password ?? '',
      );

      final user = credential.user;
      if (user == null) {
        return Left(const ServerFailure("User creation failed", 500));
      }

      // Guardar en Firestore
      final userModel = UserModel(
        uid: user.uid,
        email: user.email!,
        displayName: params.displayName,
        gender: params.gender,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(userModel.toJson());

      return Right(userModel);
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(e.message ?? "An error has occurred", 500));
    } catch (e) {
      return Left(ServerFailure(e.toString(), 500));
    }
  }

  Future<Either<Failure, UserModel>> logIn(
      String email, String password) async {
    try {
      final UserCredential credential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final UserModel user =
          await _fetchUserFromFirestore(credential.user!.uid);
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(e.message ?? 'An error has occurred', 500));
    } catch (e) {
      return Left(ServerFailure(e.toString(), 500));
    }
  }

  Future<UserModel> _fetchUserFromFirestore(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    } else {
      throw Exception("User not found in Firestore");
    }
  }

  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return _fetchUserFromFirestore(user.uid);
    }
    return null;
  }
}
