class FeatureImage {
  final String small;
  final String medium;
  final String large;

  FeatureImage({this.small, this.medium, this.large});

  factory FeatureImage.fromJson(Map<String, dynamic> json) {
    if (json == null) return new FeatureImage();

    return FeatureImage(
        small: json["small"], medium: json["medium"], large: json["large"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'small': small,
      'medium': medium,
      'large': large,
    };
  }

  static List<dynamic> toJsonFromList(List<FeatureImage> featureImages) {
    return featureImages.map((p) => p.toJson()).toList();
  }
}
