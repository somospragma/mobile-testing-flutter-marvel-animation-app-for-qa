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

  Future<Either<Failure, ApiResponseModel<List<HeroModel>>>> getHeroes(
      {required int offset}) async {
    try {
      final Response<Map<String, dynamic>> result =
          await dio.get(getCharactersPath(), queryParameters: {
        'apikey': env.apiKey,
        'ts': env.ts,
        'hash': env.hash,
        'limit': '20',
        'offset': offset
      });

      if (result.data == null || result.data!["data"] == null) {
        return Left(ServerFailure("Invalid response", result.statusCode ?? -1));
      }

      final List<dynamic> results = result.data!["data"]["results"] ?? [];
      final List<HeroModel> heroes = HeroMapper.fromJsonList(results);

      return Right(ApiResponseModel<List<HeroModel>>(
        status: result.statusCode.toString(),
        results: heroes,
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } catch (e) {
      return Left(const ServerFailure('Error parsing data', -1));
    }
  }
}
