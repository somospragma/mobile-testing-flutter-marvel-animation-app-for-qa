import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/entities/entity_either.dart';
import '../../../../core/network/error/failures.dart';
import '../../../../shared/domain/models/api_response_model.dart';
import '../../domain/models/marker_model.dart';
import '../../domain/repositories/maps_repository.dart';
import '../datasources/maps_datasource.dart';

final Provider<MapsRepositoryImpl> mapsRepositoryProvider =
    Provider<MapsRepositoryImpl>((Ref<MapsRepositoryImpl> ref) {
  return MapsRepositoryImpl(dataSource: ref.read(homeDatasourceProvider));
});

class MapsRepositoryImpl implements MapsRepository {
  final MapsDatasource dataSource;

  MapsRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, MarkerModel?>> getLocation() async {
    final Either<Failure, ApiResponseModel<MarkerModel?>> response =
        await dataSource.getMapLocation();
    return response.when((Failure left) async {
      return Left<Failure, MarkerModel>(left);
    }, (ApiResponseModel<MarkerModel?> right) async {
      return Right<Failure, MarkerModel?>(right.results);
    });
  }
}
