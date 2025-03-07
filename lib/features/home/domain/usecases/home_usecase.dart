import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/entities/entity_either.dart';
import '../../../../core/network/error/failures.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../models/heroe_model.dart';

final AutoDisposeProvider<HomeUsecase> homeUsecaseProvider =
    Provider.autoDispose<HomeUsecase>((Ref<HomeUsecase> ref) {
  return HomeUsecase(homeRepository: ref.read(homeRepositoryProvider));
});

class HomeUsecase {
  HomeUsecase({required this.homeRepository});
  final HomeRepositoryImpl homeRepository;

  Future<Either<Failure, List<HeroeModel>>> getHeros({required int offset}) async {
    final Either<Failure, List<HeroeModel>> response =
        await homeRepository.getHeros(offset: offset);

    return response.when((Failure left) async {
      return Left<Failure, List<HeroeModel>>(left);
    }, (List<HeroeModel> right) async {
      return Right<Failure, List<HeroeModel>>(right);
    });
  }
}
