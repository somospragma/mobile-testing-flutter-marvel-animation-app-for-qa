import 'package:marvel_animation_app/core/entities/entity_either.dart';

import '../../../../core/network/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> logIn(User params);
  Future<Either<Failure, User>> signUp(User params);
  Future<Either<Failure, void>> logOut();
  Future<Either<Failure, User?>> getCurrentUser();
}
