import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/entities/entity_either.dart';
import '../../../../core/network/error/failures.dart';
import '../../../../core/router/router.dart';
import '../../../../core/utils/constants/network_paths.dart';
import '../../../../core/utils/web_view_service.dart';
import '../../../../shared/domain/models/error_model.dart';
import '../../../../shared/domain/models/item_model.dart';
import '../../../../shared/presentation/tokens/tokens.dart';
import '../../domain/entities/hero.dart' as hero_entity;
import '../../domain/usecases/home_usecase.dart';
import '../mappers/hero_item_mapper.dart';
import 'home_state.dart';

final homeProvider =
    NotifierProvider<HomeNotifier, HomeState>(() => HomeNotifier());

class HomeNotifier extends Notifier<HomeState> {
  late final HomeUsecase authUsecase;
  late final GoRouter router;

  @override
  HomeState build() {
    authUsecase = ref.read(homeUsecaseProvider);
    router = ref.read(appRouterProvider);
    return HomeState();
  }

  void cleanAlert() {
    state = state.copyWith();
  }

  Future<void> getHeroes() async {
    state = state.copyWith(isLoading: true);

    final Either<Failure, List<hero_entity.Hero>> response =
        await authUsecase.getHeroes(batch: state.currentBatch);
    state = state.copyWith(isLoading: false);
    response.when((Failure left) {
      state = state.copyWith(
          alert: AlertModel(
              message: left.errorMessage,
              backgroundColor: CustomColor.ERROR_COLOR));
    }, (List<hero_entity.Hero> right) async {
      List<ItemModel> heroItems = right.map(HeroToItemMapper.map).toList();
      state = state.copyWith(
          heroes: [...state.heroes, ...heroItems],
          currentBatch: state.currentBatch + 1);
    });
  }

  Future<void> navigateToHeroDetail(
      ItemModel heroItem, BuildContext context) async {
    // Create a basic Hero entity from the ItemModel data for navigation
    // The detail page will load the complete data when it opens
    final hero = hero_entity.Hero(
      id: heroItem.id,
      name: heroItem.title,
      description: heroItem.subtitle,
      picture: heroItem.imageUrl,
    );

    // Navigate to hero detail page
    context.pushNamed(
      'heroDetail',
      pathParameters: {'heroId': heroItem.id.toString()},
      extra: hero,
    );
  }

  Future<void> getHeroComics(ItemModel hero, BuildContext context) async {
    state = state.copyWith(isLoading: true);
    try {
      WebViewService()
          .openWebView(context, getCharacterComicsPath(character: hero.id));
    } catch (e) {
      state = state.copyWith(
          alert: AlertModel(
              message: 'No se pudo abrir el url',
              backgroundColor: CustomColor.ERROR_COLOR));
    }
    state = state.copyWith(isLoading: false);
  }
}
