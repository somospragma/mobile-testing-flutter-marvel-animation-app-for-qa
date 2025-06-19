import '../../../../core/entities/entity_either.dart';
import '../../../../core/network/error/failures.dart';
import '../entities/hero.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Hero>>> getHeroes({required int offset});
}
