class ServerLocationData {
  final int id;
  final String name;
  final String location;

  ServerLocationData.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        location = json["location"];
}

class ServerLocationsData {
  final List<ServerLocationData> items;

  ServerLocationsData.fromJson(List<dynamic> json)
      : items = json.map((item) => ServerLocationData.fromJson(item)).toList();
}
