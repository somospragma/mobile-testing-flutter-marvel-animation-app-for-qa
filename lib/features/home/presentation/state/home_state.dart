import '../../../../shared/domain/models/error_model.dart';
import '../../../../shared/domain/models/item_model.dart';
import '../../domain/models/heroe_model.dart';

class HomeState {

  HomeState({
    this.heroes = const [],
    this.selectedHero,
    this.isLoading = false,
    this.offset = 0,
    this.alert,
  });
  final List<ItemModel> heroes;
  final HeroeModel? selectedHero;
  final bool isLoading;
  final AlertModel? alert;
  final int offset;

  HomeState copyWith({
    List<ItemModel>? heroes,
    HeroeModel? selectedHero,
    bool? isLoading,
    AlertModel? alert,
    int? offset,
  }) {
    return HomeState(
      heroes: heroes ?? this.heroes,
      selectedHero: selectedHero ?? this.selectedHero,
      isLoading: isLoading ?? this.isLoading,
      alert: alert ?? this.alert,
      offset: offset ?? this.offset,
    );
  }
}
