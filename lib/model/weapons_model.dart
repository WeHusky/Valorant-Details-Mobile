
class WeaponsModel {
  final String displayName;
  final String category;
  final String displayIcon;
  final List<Skin> skins;

  WeaponsModel({
    required this.displayName,
    required this.category,
    required this.displayIcon,
    required this.skins,
  });

  factory WeaponsModel.fromJson(Map<String, dynamic> json) {
    return WeaponsModel(
      displayName: json['displayName'] ?? '',
      category: json['category'] ?? '',
      displayIcon: json['displayIcon'] ?? '',
      skins: (json['skins'] as List<dynamic>? ?? [])
          .map((x) => Skin.fromJson(x))
          .toList(),
    );
  }
}

class Skin {
  final String uuid;
  final String displayName;
  final String? displayIcon;
  final String? wallpaper;

  Skin({
    required this.uuid,
    required this.displayName,
    this.displayIcon,
    this.wallpaper,
  });

  factory Skin.fromJson(Map<String, dynamic> json) {
    return Skin(
      uuid: json['uuid'] ?? '',
      displayName: json['displayName'] ?? '',
      displayIcon: json['displayIcon'],
      wallpaper: json['wallpaper'],
    );
  }
}
