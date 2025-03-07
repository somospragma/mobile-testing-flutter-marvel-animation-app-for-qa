class HeroeModel {
  const HeroeModel({
    required this.id,
    this.name,
    this.description,
    this.thumbnail,
  });
  final int id;
  final String? description;
  final String? name;
  final String? thumbnail;

  HeroeModel copyWith({
    int? id,
    String? description,
    String? name,
    String? thumbnail,
  }) {
    return HeroeModel(
      id: id ?? this.id,
      description: name ?? this.description,
      name: name ?? this.name,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }
}
