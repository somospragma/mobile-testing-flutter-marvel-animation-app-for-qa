class HeroModel {
  const HeroModel({
    required this.id,
    this.name,
    this.description,
    this.thumbnail,
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
  final int id;
  final String? description;
  final String? name;
  final String? thumbnail;
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

  HeroModel copyWith({
    int? id,
    String? description,
    String? name,
    String? thumbnail,
    String? fullName,
    String? publisher,
    String? alignment,
    String? gender,
    String? race,
    String? occupation,
    String? intelligence,
    String? strength,
    String? speed,
    String? durability,
    String? power,
    String? combat,
    String? groupAffiliation,
    String? relatives,
    String? placeOfBirth,
    String? firstAppearance,
    String? alterEgos,
    List<String>? aliases,
    List<String>? height,
    List<String>? weight,
    String? eyeColor,
    String? hairColor,
    String? base,
  }) {
    return HeroModel(
      id: id ?? this.id,
      description: description ?? this.description,
      name: name ?? this.name,
      thumbnail: thumbnail ?? this.thumbnail,
      fullName: fullName ?? this.fullName,
      publisher: publisher ?? this.publisher,
      alignment: alignment ?? this.alignment,
      gender: gender ?? this.gender,
      race: race ?? this.race,
      occupation: occupation ?? this.occupation,
      intelligence: intelligence ?? this.intelligence,
      strength: strength ?? this.strength,
      speed: speed ?? this.speed,
      durability: durability ?? this.durability,
      power: power ?? this.power,
      combat: combat ?? this.combat,
      groupAffiliation: groupAffiliation ?? this.groupAffiliation,
      relatives: relatives ?? this.relatives,
      placeOfBirth: placeOfBirth ?? this.placeOfBirth,
      firstAppearance: firstAppearance ?? this.firstAppearance,
      alterEgos: alterEgos ?? this.alterEgos,
      aliases: aliases ?? this.aliases,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      eyeColor: eyeColor ?? this.eyeColor,
      hairColor: hairColor ?? this.hairColor,
      base: base ?? this.base,
    );
  }
}
