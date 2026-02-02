import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/constants/network_paths.dart';
import '../../data/mappers/hero_mapper.dart';
import 'hero_detail_state.dart';

class HeroDetailNotifier extends AsyncNotifier<HeroDetailState> {
  final Dio _dio = Dio();
  final int heroId;

  HeroDetailNotifier(this.heroId);

  @override
  Future<HeroDetailState> build() async {
    await loadHeroDetails(heroId);

    return const HeroDetailState();
  }

  Future<void> loadHeroDetails(int heroId) async {
    if (state.value?.hero != null) {
      return;
    }

    state =
        AsyncValue.data(HeroDetailState(isLoading: true, errorMessage: null));

    try {
      final response = await _dio.get(getHeroPath(heroId));

      if (response.data != null && response.data['response'] == 'success') {
        final heroModel = HeroMapper.fromJson(response.data);
        final hero = HeroMapper.toEntity(heroModel);

        state = AsyncValue.data(
          HeroDetailState(
            hero: hero,
            isLoading: false,
          ),
        );
      } else {
        state = AsyncValue.data(
          HeroDetailState(
            isLoading: false,
            errorMessage: 'Failed to load hero data',
          ),
        );
      }
    } catch (e) {
      state = AsyncValue.data(
        HeroDetailState(
          isLoading: false,
          errorMessage: 'Error loading hero: ${e.toString()}',
        ),
      );
    }
  }

  void clearError() {
    state = AsyncValue.data(
      HeroDetailState(
        hero: state.value?.hero,
        isLoading: state.value?.isLoading ?? false,
        errorMessage: null,
      ),
    );
  }
}

final heroDetailProvider =
    AsyncNotifierProvider.family<HeroDetailNotifier, HeroDetailState, int>(
  HeroDetailNotifier.new,
);
