import '../models/heroe_model.dart';

class HeroeMapper {
  static HeroeModel fromJson(Map<String, dynamic> json) {
    return HeroeModel(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      thumbnail: json["thumbnail"] != null
          ? "${json["thumbnail"]["path"]}.${json["thumbnail"]["extension"]}"
          : null,
    );
  }

  static List<HeroeModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((hero) => fromJson(hero)).toList();
  }
}
