import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/entities/entity_either.dart';
import '../../../../core/network/error/failures.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/models/user_model.dart';

final AutoDisposeProvider<AuthUsecase> authUsecaseProvider =
    Provider.autoDispose<AuthUsecase>((Ref<AuthUsecase> ref) {
  return AuthUsecase(authRepository: ref.read(authRepositoryProvider));
});

class AuthUsecase {
  AuthUsecase({required this.authRepository});
  final AuthRepositoryImpl authRepository;

  Future<Either<Failure, UserModel>> logIn(
      {required String email, required String password}) async {
    final Either<Failure, UserModel> response =
        await authRepository.logIn(UserModel(email: email, password: password));

    return response.when((Failure left) async {
      return Left<Failure, UserModel>(left);
    }, (UserModel right) async {
      return Right<Failure, UserModel>(right);
    });
  }

  Future<Either<Failure, UserModel>> signUp(
      {required String email,
      required String password,
      required String name}) async {
    final Either<Failure, UserModel> response = await authRepository
        .signUp(UserModel(email: email, password: password, displayName: name));

    return response.when((Failure left) async {
      return Left<Failure, UserModel>(left);
    }, (UserModel right) async {
      return Right<Failure, UserModel>(right);
    });
  }
}
