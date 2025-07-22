import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marvel_animation_app/features/maps/domain/entities/marker.dart';

import '../../../../core/entities/entity_either.dart';
import '../../../../core/network/error/failures.dart';
import '../../data/repositories/maps_repository_impl.dart';

final AutoDisposeProvider<MapsUsecase> mapsUsecaseProvider =
    Provider.autoDispose<MapsUsecase>((Ref<MapsUsecase> ref) {
  return MapsUsecase(mapsRepository: ref.read(mapsRepositoryProvider));
});

class MapsUsecase {
  MapsUsecase({required this.mapsRepository});
  final MapsRepositoryImpl mapsRepository;

  Future<Either<Failure, MarkerEntity?>> getLocation() async {
    final Either<Failure, MarkerEntity?> response =
        await mapsRepository.getLocation();

    return response.when((Failure left) async {
      return Left<Failure, MarkerEntity?>(left);
    }, (MarkerEntity? right) async {
      return Right<Failure, MarkerEntity?>(right);
    });
  }
}
