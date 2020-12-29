class VideoQualityData {
  final int id;
  final int quality;
  final String title;

  VideoQualityData.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        quality = json["quality"],
        title = json["title"];
}

class VideoQualitiesData {
  final List<VideoQualityData> items;

  VideoQualitiesData.fromJson(List<dynamic> json)
      : items = json.map((item) => VideoQualityData.fromJson(item)).toList();
}
