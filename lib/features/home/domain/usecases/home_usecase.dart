import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/entities/entity_either.dart';
import '../../../../core/network/error/failures.dart';
import '../repositories/home_repository.dart';
import '../entities/hero.dart';
import '../../data/repositories/home_repository_impl.dart';

final AutoDisposeProvider<HomeUsecase> homeUsecaseProvider =
    Provider.autoDispose<HomeUsecase>((Ref<HomeUsecase> ref) {
  return HomeUsecase(homeRepository: ref.read(homeRepositoryProvider));
});

class HomeUsecase {
  HomeUsecase({required this.homeRepository});
  final HomeRepository homeRepository;

  Future<Either<Failure, List<Hero>>> getHeroes({required int batch}) async {
    final Either<Failure, List<Hero>> response =
        await homeRepository.getHeroes(batch: batch);

    return response.when((Failure left) async {
      return Left<Failure, List<Hero>>(left);
    }, (List<Hero> right) async {
      return Right<Failure, List<Hero>>(right);
    });
  }

  Future<Either<Failure, List<Hero>>> searchHeroesByName({required String name}) async {
    final Either<Failure, List<Hero>> response =
        await homeRepository.searchHeroesByName(name: name);

    return response.when((Failure left) async {
      return Left<Failure, List<Hero>>(left);
    }, (List<Hero> right) async {
      return Right<Failure, List<Hero>>(right);
    });
  }
}
