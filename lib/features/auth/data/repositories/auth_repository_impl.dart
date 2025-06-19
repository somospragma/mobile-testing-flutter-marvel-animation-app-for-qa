import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marvel_animation_app/features/auth/data/datasources/firebase_auth_datasource.dart';

import '../../../../core/entities/entity_either.dart';
import '../../../../core/network/error/failures.dart';
import '../models/user_model.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

final Provider<AuthRepositoryImpl> authRepositoryProvider =
    Provider<AuthRepositoryImpl>((Ref<AuthRepositoryImpl> ref) {
  return AuthRepositoryImpl(
      dataSource: ref.read(firebaseAuthDataSourceProvider));
});

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.dataSource});

  final FirebaseAuthDataSource dataSource;

  @override
  Future<Either<Failure, User>> logIn(User params) async {
    final user = await dataSource.logIn(params.email, params.password ?? '');

    return user.when((Failure left) async {
      return Left<Failure, User>(left);
    }, (UserModel right) async {
      return Right<Failure, User>(right);
    });
  }

  @override
  Future<Either<Failure, User>> signUp(User params) async {
    final Either<Failure, UserModel> response = await dataSource.signUp(
      UserModel(
        email: params.email,
        password: params.password,
        displayName: params.displayName,
        uid: params.uid,
        gender: params.gender,
        token: params.token,
      ),
    );
    return response.when((Failure left) async {
      return Left<Failure, User>(left);
    }, (UserModel right) async {
      return Right<Failure, User>(right);
    });
  }

  @override
  Future<Either<Failure, void>> logOut() async {
    try {
      await dataSource.logOut();
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString(), 500));
    }
  }

  @override
  Future<Either<Failure, UserModel?>> getCurrentUser() async {
    try {
      final user = await dataSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString(), 500));
    }
  }
}
