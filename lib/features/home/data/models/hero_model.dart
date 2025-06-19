class HeroModel {
  const HeroModel({
    required this.id,
    this.name,
    this.description,
    this.thumbnail,
  });
  final int id;
  final String? description;
  final String? name;
  final String? thumbnail;

  HeroModel copyWith({
    int? id,
    String? description,
    String? name,
    String? thumbnail,
  }) {
    return HeroModel(
      id: id ?? this.id,
      description: description ?? this.description,
      name: name ?? this.name,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }
}
