import 'package:marvel_animation_app/core/entities/entity_either.dart';

import '../../../../core/network/error/failures.dart';
import '../models/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> logIn(UserModel params);
  Future<Either<Failure, UserModel>> signUp(UserModel params);
  Future<Either<Failure, void>> logOut();
  Future<Either<Failure, UserModel?>> getCurrentUser();
}
