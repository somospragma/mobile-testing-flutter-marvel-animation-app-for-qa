import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/entities/entity_either.dart';
import '../../../../core/env/config_env.dart';
import '../../../../core/env/env_model.dart';
import '../../../../core/network/dio_network.dart';
import '../../../../core/network/error/exceptions.dart';
import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/constants/network_paths.dart';
import '../../../../shared/domain/models/api_response_model.dart';
import '../mappers/hero_mapper.dart';
import '../models/hero_model.dart';

final Provider<HomeDatasource> homeDatasourceProvider =
    Provider<HomeDatasource>((Ref<HomeDatasource> ref) {
  return HomeDatasource();
});

class HomeDatasource {
  Dio dio = DioNetwork.getDio();
  EnvModel env = ConfigENV.intance.getAppEnv;

  // SuperHero API has around 731 characters, we'll load in batches of 40
  static const int batchSize = 40;
  static const int maxHeroId = 731;

  Future<Either<Failure, ApiResponseModel<List<HeroModel>>>> getHeroes(
      {required int batch}) async {
    try {
      final List<HeroModel> heroes = [];
      final int startId = (batch * batchSize) + 1;
      final int endId = ((batch + 1) * batchSize).clamp(1, maxHeroId);

      // Load heroes in parallel for better performance
      final List<Future<HeroModel?>> futures = [];
      
      for (int id = startId; id <= endId; id++) {
        futures.add(_getHeroById(id));
      }

      final List<HeroModel?> results = await Future.wait(futures);
      
      // Filter out null results (failed requests)
      for (final hero in results) {
        if (hero != null) {
          heroes.add(hero);
        }
      }

      return Right(ApiResponseModel<List<HeroModel>>(
        status: '200',
        results: heroes,
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } catch (e) {
      return Left(ServerFailure('Error loading heroes batch', -1));
    }
  }

  Future<HeroModel?> _getHeroById(int id) async {
    try {
      final Response<Map<String, dynamic>> result =
          await dio.get(getHeroPath(id));

      if (result.data == null || result.data!["response"] != "success") {
        return null; // Skip failed requests
      }

      return HeroMapper.fromJson(result.data!);
    } catch (e) {
      return null; // Skip failed requests
    }
  }
}
