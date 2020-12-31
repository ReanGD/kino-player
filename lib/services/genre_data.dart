class GenreData {
  final int id;
  final String title;

  GenreData.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"];
}

class GenresData {
  // metatypeof(ContentTypeData.id) <=> []GenreData
  final Map<String, List<GenreData>> items;

  static Map<String, List<GenreData>> _buildMap(List<dynamic> json) {
    Map<String, List<GenreData>> result = {};
    json.forEach((item) {
      final key = item["type"];
      final genre = GenreData.fromJson(item);
      if (result.containsKey(key)) {
        result[key].add(genre);
      } else {
        result[key] = [genre];
      }
    });

    return result;
  }

  static String metaType(String contentTypeId) {
    switch (contentTypeId) {
      case "concert":
        return "music";
      case "tvshow":
        return "tvshow";
      case "documovie":
        return "docu";
      case "docuserial":
        return "docu";
      default:
        return "movie";
    }
  }

  GenresData.fromJson(List<dynamic> json) : items = _buildMap(json);

  List<GenreData> getAvaible(List<String> contentTypeIds) {
    List<GenreData> result = [];
    contentTypeIds.map((e) => metaType(e)).toSet().forEach((type) {
      result.addAll(items[type]);
    });

    return result;
  }
}
