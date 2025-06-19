import 'package:marvel_animation_app/features/maps/domain/entities/marker.dart';

import '../../../../core/entities/entity_either.dart';
import '../../../../core/network/error/failures.dart';

abstract class MapsRepository {
  Future<Either<Failure, MarkerEntity?>> getLocation();
}
