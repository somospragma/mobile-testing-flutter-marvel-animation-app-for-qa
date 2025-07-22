import '../../../../shared/domain/models/item_model.dart';
import '../../domain/entities/hero.dart';

class HeroToItemMapper {
  static ItemModel map(Hero hero) {
    return ItemModel(
      id: hero.id,
      title: hero.name,
      subtitle: hero.description,
      imageUrl: hero.picture,
      buttonText: "SECRET PLACE",
    );
  }
}
