class BundlesModel {
  final String displayName;
  final String description;
  final String displayIcon;
  final String verticalPromoImage;
  

  BundlesModel({
    required this.displayName,
    required this.description,
    required this.displayIcon,
    required this.verticalPromoImage,
    
  });

  factory BundlesModel.fromJson(Map<String, dynamic> json) {
    return BundlesModel(
      displayName: json['displayName'] ?? '',
      description: json['description'] ?? '',
      displayIcon: json['displayIcon'] ?? '',
      verticalPromoImage: json['verticalPromoImage'] ?? '',
    );
  }
}