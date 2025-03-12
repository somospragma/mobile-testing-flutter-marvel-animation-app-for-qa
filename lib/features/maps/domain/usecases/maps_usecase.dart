import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/entities/entity_either.dart';
import '../../../../core/network/error/failures.dart';
import '../../data/repositories/maps_repository_impl.dart';
import '../models/marker_model.dart';

final AutoDisposeProvider<MapsUsecase> mapsUsecaseProvider =
    Provider.autoDispose<MapsUsecase>((Ref<MapsUsecase> ref) {
  return MapsUsecase(mapsRepository: ref.read(mapsRepositoryProvider));
});

class MapsUsecase {
  MapsUsecase({required this.mapsRepository});
  final MapsRepositoryImpl mapsRepository;

  Future<Either<Failure, MarkerModel?>> getLocation() async {
    final Either<Failure, MarkerModel?> response =
        await mapsRepository.getLocation();

    return response.when((Failure left) async {
      return Left<Failure, MarkerModel?>(left);
    }, (MarkerModel? right) async {
      return Right<Failure, MarkerModel?>(right);
    });
  }
}
