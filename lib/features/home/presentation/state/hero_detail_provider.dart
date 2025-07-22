import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mappers/hero_mapper.dart';
import 'hero_detail_state.dart';

class HeroDetailNotifier extends StateNotifier<HeroDetailState> {
  HeroDetailNotifier() : super(const HeroDetailState());

  final Dio _dio = Dio();

  Future<void> loadHeroDetails(int heroId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _dio.get(
        'https://superheroapi.com/api/f0f27a795e0e94417178352f2e3f7c97/$heroId'
      );

      if (response.data != null && response.data['response'] == 'success') {
        final heroModel = HeroMapper.fromJson(response.data);
        final hero = HeroMapper.toEntity(heroModel);
        
        state = state.copyWith(
          hero: hero,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load hero data',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error loading hero: ${e.toString()}',
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

final heroDetailProvider = StateNotifierProvider.family<HeroDetailNotifier, HeroDetailState, int>(
  (ref, heroId) {
    final notifier = HeroDetailNotifier();
    notifier.loadHeroDetails(heroId);
    return notifier;
  },
);
