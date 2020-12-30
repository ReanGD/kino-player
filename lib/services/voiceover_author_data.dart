class VoiceoverAuthorData {
  final int id;
  final String title;
  final String shortTitle;

  VoiceoverAuthorData.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        shortTitle = json["short_title"];
}

class VoiceoverAuthorsData {
  final List<VoiceoverAuthorData> items;

  VoiceoverAuthorsData.fromJson(List<dynamic> json)
      : items = json.map((item) => VoiceoverAuthorData.fromJson(item)).toList();
}
