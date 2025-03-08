import '../../../../core/entities/entity_either.dart';
import '../../../../core/network/error/failures.dart';
import '../models/heroe_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<HeroeModel>>> getHeroes({required int offset});
}
