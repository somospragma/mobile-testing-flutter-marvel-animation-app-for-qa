import '../../../../core/entities/entity_either.dart';
import '../../../../core/network/error/failures.dart';
import '../models/marker_model.dart';

abstract class MapsRepository {
  Future<Either<Failure, MarkerModel?>> getLocation();
}
