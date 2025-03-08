import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/entities/entity_either.dart';
import '../../../../core/network/error/failures.dart';
import '../../../../shared/domain/models/api_response_model.dart';
import '../../domain/models/heroe_model.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_datasource.dart';

final Provider<HomeRepositoryImpl> homeRepositoryProvider =
    Provider<HomeRepositoryImpl>((Ref<HomeRepositoryImpl> ref) {
  return HomeRepositoryImpl(dataSource: ref.read(homeDatasourceProvider));
});

class HomeRepositoryImpl implements HomeRepository {
  final HomeDatasource dataSource;

  HomeRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<HeroeModel>>> getHeroes({required int offset}) async {
    final Either<Failure, ApiResponseModel<List<HeroeModel>>> response =
        await dataSource.getHeroes(offset: offset);
    return response.when((Failure left) async {
      return Left<Failure, List<HeroeModel>>(left);
    }, (ApiResponseModel<List<HeroeModel>> right) async {
      return Right<Failure, List<HeroeModel>>(right.results ?? []);
    });
  }
}
