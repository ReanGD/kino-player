class VoiceoverData {
  final int id;
  final String title;
  final String shortTitle;

  VoiceoverData.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        shortTitle = json["short_title"];
}

class VoiceoversData {
  final List<VoiceoverData> items;

  VoiceoversData.fromJson(List<dynamic> json)
      : items = json.map((item) => VoiceoverData.fromJson(item)).toList();
}
