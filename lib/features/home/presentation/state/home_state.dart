import '../../../../shared/domain/models/error_model.dart';
import '../../../../shared/domain/models/item_model.dart';
import '../../domain/entities/hero.dart' as hero_entity;

class HomeState {

  HomeState({
    this.heroes = const [],
    this.selectedHero,
    this.isLoading = false,
    this.currentBatch = 0,
    this.alert,
  });
  final List<ItemModel> heroes;
  final hero_entity.Hero? selectedHero;
  final bool isLoading;
  final AlertModel? alert;
  final int currentBatch;

  HomeState copyWith({
    List<ItemModel>? heroes,
    hero_entity.Hero? selectedHero,
    bool? isLoading,
    AlertModel? alert,
    int? currentBatch,
  }) {
    return HomeState(
      heroes: heroes ?? this.heroes,
      selectedHero: selectedHero ?? this.selectedHero,
      isLoading: isLoading ?? this.isLoading,
      alert: alert ?? this.alert,
      currentBatch: currentBatch ?? this.currentBatch,
    );
  }
}
