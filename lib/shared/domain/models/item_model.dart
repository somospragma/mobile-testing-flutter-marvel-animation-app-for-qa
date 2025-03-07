class ItemModel {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String buttonText;

  ItemModel({
    required this.title,
    required this.imageUrl,
    required this.subtitle,
    required this.buttonText,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      title: json['title'],
      imageUrl: json['image'],
      subtitle: json['subtitle'],
      buttonText: json['buttonText']
    );
  }
}
