import '../../domain/entities/hero.dart';
import '../models/hero_model.dart';

class HeroMapper {
  static HeroModel fromJson(Map<String, dynamic> json) {
    return HeroModel(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      thumbnail: json["thumbnail"] != null
          ? "${json["thumbnail"]["path"]}.${json["thumbnail"]["extension"]}"
          : null,
    );
  }

  static List<HeroModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => fromJson(json)).toList();
  }

  static Hero toEntity(HeroModel model) {
    return Hero(
      id: model.id,
      name: model.name ?? 'No Name',
      description: model.description ?? 'No Description',
      picture: model.thumbnail ?? '',
    );
  }
}
