import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marvel_animation_app/features/home/domain/models/heroe_model.dart';
import 'package:marvel_animation_app/shared/domain/models/item_model.dart';

import '../../../../core/entities/entity_either.dart';
import '../../../../core/network/error/failures.dart';
import '../../../../core/router/router.dart';
import '../../../../core/utils/constants/network_paths.dart';
import '../../../../core/utils/web_view_service.dart';
import '../../../../shared/domain/models/error_model.dart';
import '../../../../shared/presentation/tokens/tokens.dart';
import '../../domain/usecases/home_usecase.dart';
import '../mappers/heroe_item_mapper.dart';
import 'home_state.dart';

final StateNotifierProvider<HomeNotifier, HomeState> homeProvider =
    StateNotifierProvider<HomeNotifier, HomeState>(
        (Ref<HomeState> ref) => HomeNotifier(
              authUsecase: ref.read(homeUsecaseProvider),
              router: ref.read(appRouterProvider),
            ));

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier({
    required this.authUsecase,
    required this.router,
  }) : super(HomeState());
  final HomeUsecase authUsecase;
  final GoRouter router;

  void cleanAlert() {
    state = state.copyWith();
  }

  Future<void> getHeroes() async {
    state = state.copyWith(isLoading: true);

    final Either<Failure, List<HeroeModel>> response =
        await authUsecase.getHeroes(offset: state.offset);
    state = state.copyWith(isLoading: false);
    response.when((Failure left) {
      state = state.copyWith(
          alert: AlertModel(
              message: left.errorMessage,
              backgroundColor: CustomColor.ERROR_COLOR));
    }, (List<HeroeModel> right) async {
      List<ItemModel> heroeItems = right.map(HeroeToItemMapper.map).toList();
      state = state.copyWith(
          heroes: [...state.heroes, ...heroeItems], offset: state.offset + 20);
    });
  }

  Future<void> getHeroeComics(ItemModel hero, BuildContext context)  async {
    state = state.copyWith(isLoading: true);
    try {
      WebViewService().openWebView(context, getCharacterComicsPath(character: hero.id));
    } catch (e) {
      state = state.copyWith(
          alert: AlertModel(
              message: 'No se pudo abrir el url',
              backgroundColor: CustomColor.ERROR_COLOR));
    }
    state = state.copyWith(isLoading: false);
  }
}
