class CountryData {
  final int id;
  final String title;

  CountryData.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"];
}

class CountriesData {
  final List<CountryData> items;

  CountriesData.fromJson(List<dynamic> json)
      : items = json.map((item) => CountryData.fromJson(item)).toList();
}
