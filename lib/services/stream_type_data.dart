class StreamTypeData {
  final int id;
  final String code;
  final String name;
  final String description;

  StreamTypeData.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        code = json["code"],
        name = json["name"],
        description = json["description"];
}

class StreamTypesData {
  final List<StreamTypeData> items;

  StreamTypesData.fromJson(List<dynamic> json)
      : items = json.map((item) => StreamTypeData.fromJson(item)).toList();
}
