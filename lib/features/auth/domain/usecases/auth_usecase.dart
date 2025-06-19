import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/entities/entity_either.dart';
import '../../../../core/network/error/failures.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../entities/user.dart';

final AutoDisposeProvider<AuthUsecase> authUsecaseProvider =
    Provider.autoDispose<AuthUsecase>((Ref<AuthUsecase> ref) {
  return AuthUsecase(authRepository: ref.read(authRepositoryProvider));
});

class AuthUsecase {
  AuthUsecase({required this.authRepository});
  final AuthRepositoryImpl authRepository;

  Future<Either<Failure, User>> logIn(
      {required String email, required String password}) async {
    final Either<Failure, User> response =
        await authRepository.logIn(User(email: email, password: password));

    return response.when((Failure left) async {
      return Left<Failure, User>(left);
    }, (User right) async {
      return Right<Failure, User>(right);
    });
  }

  Future<Either<Failure, User>> signUp(
      {required String email,
      required String password,
      required String name,
      required String gender}) async {
    final Either<Failure, User> response = await authRepository.signUp(
        User(email: email, password: password, displayName: name, gender: gender));

    return response.when((Failure left) async {
      return Left<Failure, User>(left);
    }, (User right) async {
      return Right<Failure, User>(right);
    });
  }
}
