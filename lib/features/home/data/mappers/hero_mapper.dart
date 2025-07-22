import '../../domain/entities/hero.dart';
import '../models/hero_model.dart';

class HeroMapper {
  static HeroModel fromJson(Map<String, dynamic> json) {
    return HeroModel(
      id: int.tryParse(json["id"]?.toString() ?? "0") ?? 0,
      name: json["name"],
      description: json["biography"]?["full-name"] ?? json["name"],
      thumbnail: json["image"]?["url"],
      fullName: json["biography"]?["full-name"],
      publisher: json["biography"]?["publisher"],
      alignment: json["biography"]?["alignment"],
      gender: json["appearance"]?["gender"],
      race: json["appearance"]?["race"],
      occupation: json["work"]?["occupation"],
      intelligence: _parseStatValue(json["powerstats"]?["intelligence"]),
      strength: _parseStatValue(json["powerstats"]?["strength"]),
      speed: _parseStatValue(json["powerstats"]?["speed"]),
      durability: _parseStatValue(json["powerstats"]?["durability"]),
      power: _parseStatValue(json["powerstats"]?["power"]),
      combat: _parseStatValue(json["powerstats"]?["combat"]),
      groupAffiliation: json["connections"]?["group-affiliation"],
      relatives: json["connections"]?["relatives"],
      placeOfBirth: json["biography"]?["place-of-birth"],
      firstAppearance: json["biography"]?["first-appearance"],
      alterEgos: json["biography"]?["alter-egos"],
      aliases: json["biography"]?["aliases"] != null 
          ? List<String>.from(json["biography"]["aliases"])
          : null,
      height: json["appearance"]?["height"] != null 
          ? List<String>.from(json["appearance"]["height"])
          : null,
      weight: json["appearance"]?["weight"] != null 
          ? List<String>.from(json["appearance"]["weight"])
          : null,
      eyeColor: json["appearance"]?["eye-color"],
      hairColor: json["appearance"]?["hair-color"],
      base: json["work"]?["base"],
    );
  }

  static List<HeroModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => fromJson(json)).toList();
  }

  /// Helper method to parse stat values from API strings to valid numbers
  /// SuperHero API returns stats as strings like "100", "null", or "-"
  static String _parseStatValue(dynamic value) {
    if (value == null || value == "null" || value == "-") {
      return "0";
    }
    
    // Try to parse as int to validate it's a number
    final parsed = int.tryParse(value.toString());
    if (parsed != null && parsed >= 0 && parsed <= 100) {
      return parsed.toString();
    }
    
    return "0"; // Default fallback
  }

  static Hero toEntity(HeroModel model) {
    return Hero(
      id: model.id,
      name: model.name ?? 'No Name',
      description: model.description ?? 'No Description',
      picture: model.thumbnail ?? '',
      fullName: model.fullName,
      publisher: model.publisher,
      alignment: model.alignment,
      gender: model.gender,
      race: model.race,
      occupation: model.occupation,
      intelligence: model.intelligence,
      strength: model.strength,
      speed: model.speed,
      durability: model.durability,
      power: model.power,
      combat: model.combat,
      groupAffiliation: model.groupAffiliation,
      relatives: model.relatives,
      placeOfBirth: model.placeOfBirth,
      firstAppearance: model.firstAppearance,
      alterEgos: model.alterEgos,
      aliases: model.aliases,
      height: model.height,
      weight: model.weight,
      eyeColor: model.eyeColor,
      hairColor: model.hairColor,
      base: model.base,
    );
  }
}
