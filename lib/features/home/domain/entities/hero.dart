class Hero {
  final int id;
  final String name;
  final String description;
  final String picture;
  final String? fullName;
  final String? publisher;
  final String? alignment;
  final String? gender;
  final String? race;
  final String? occupation;
  final String? intelligence;
  final String? strength;
  final String? speed;
  final String? durability;
  final String? power;
  final String? combat;
  final String? groupAffiliation;
  final String? relatives;
  final String? placeOfBirth;
  final String? firstAppearance;
  final String? alterEgos;
  final List<String>? aliases;
  final List<String>? height;
  final List<String>? weight;
  final String? eyeColor;
  final String? hairColor;
  final String? base;

  Hero({
    required this.id,
    required this.name,
    required this.description,
    required this.picture,
    this.fullName,
    this.publisher,
    this.alignment,
    this.gender,
    this.race,
    this.occupation,
    this.intelligence,
    this.strength,
    this.speed,
    this.durability,
    this.power,
    this.combat,
    this.groupAffiliation,
    this.relatives,
    this.placeOfBirth,
    this.firstAppearance,
    this.alterEgos,
    this.aliases,
    this.height,
    this.weight,
    this.eyeColor,
    this.hairColor,
    this.base,
  });
}
