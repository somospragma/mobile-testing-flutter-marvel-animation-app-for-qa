import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/entities/entity_either.dart';
import '../../../../core/network/error/failures.dart';
import '../../../../shared/domain/models/api_response_model.dart';
import '../models/hero_model.dart';
import '../../domain/entities/hero.dart';
import '../mappers/hero_mapper.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_datasource.dart';

final Provider<HomeRepository> homeRepositoryProvider =
    Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(dataSource: ref.read(homeDatasourceProvider));
});

class HomeRepositoryImpl implements HomeRepository {
  final HomeDatasource dataSource;

  HomeRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<Hero>>> getHeroes({required int offset}) async {
    final Either<Failure, ApiResponseModel<List<HeroModel>>> response =
        await dataSource.getHeroes(offset: offset);
    return response.when((Failure left) async {
      return Left<Failure, List<Hero>>(left);
    }, (ApiResponseModel<List<HeroModel>> right) async {
      final heroes = right.results?.map((e) => HeroMapper.toEntity(e)).toList() ?? [];
      return Right<Failure, List<Hero>>(heroes);
    });
  }
}
