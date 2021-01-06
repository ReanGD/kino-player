class ContentTypeData {
  final String id;
  final String title;

  ContentTypeData.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"];
}

class ContentTypesData {
  final List<ContentTypeData> items;

  ContentTypesData.fromJson(List<dynamic> json)
      : items = json
            .map((item) => ContentTypeData.fromJson(item))
            // TODO: WTF?
            .where((item) => item.id != "4k")
            .toList();
}
