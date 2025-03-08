import '../../../../shared/domain/models/item_model.dart';
import '../../domain/models/heroe_model.dart';

class HeroeToItemMapper {
  static ItemModel map(HeroeModel heroe) {
    return ItemModel(
      id: heroe.id,
      title: heroe.name ?? "Unknown Hero",
      subtitle: heroe.description ?? "No description available",
      imageUrl: heroe.thumbnail ?? "",
      buttonText: "SECRET PLACE",
    );
  }
}
