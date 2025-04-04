class BannerModel {
  final String id;
  final String title;
  final String? description;

  final String? imageUrl;
  final String? link;

  final List<String> tags;

  BannerModel({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    this.link,
    required this.tags,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String?,
      link: json['url'] as String?,
      description: json['description'] as String?,
      tags: List<String>.from(json['tags'] as List),
    );
  }
}
