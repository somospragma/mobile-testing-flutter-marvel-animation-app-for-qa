import '../../domain/entities/hero.dart';

class HeroDetailState {
  final Hero? hero;
  final bool isLoading;
  final String? errorMessage;

  const HeroDetailState({
    this.hero,
    this.isLoading = false,
    this.errorMessage,
  });

  HeroDetailState copyWith({
    Hero? hero,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HeroDetailState(
      hero: hero ?? this.hero,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
