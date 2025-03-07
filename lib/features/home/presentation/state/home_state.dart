import '../../../../shared/domain/models/error_model.dart';
import '../../../../shared/domain/models/item_model.dart';

class HomeState {

  HomeState({
    this.heroes = const [],
    this.isLoading = false,
    this.offset = 0,
    this.alert,
  });
  final List<ItemModel> heroes;
  final bool isLoading;
  final AlertModel? alert;
  final int offset;

  HomeState copyWith({
    List<ItemModel>? heroes,
    bool? isLoading,
    AlertModel? alert,
    int? offset,
  }) {
    return HomeState(
      heroes: heroes ?? this.heroes,
      isLoading: isLoading ?? this.isLoading,
      alert: alert ?? this.alert,
      offset: offset ?? this.offset,
    );
  }
}
