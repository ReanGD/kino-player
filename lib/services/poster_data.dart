class PosterData {
  final int id;
  final int year;
  final double imdbRating;
  final double kinopoiskRating;
  final double kinopubRating;
  final String title;
  final String poster;

  PosterData.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        year = json["year"],
        imdbRating =
            json["imdb_rating"] == null ? 0 : json["imdb_rating"].toDouble(),
        kinopoiskRating = json["kinopoisk_rating"] == null
            ? 0
            : json["kinopoisk_rating"].toDouble(),
        kinopubRating = json["rating_percentage"] == null
            ? 0
            : json["rating_percentage"].toDouble() / 10.0,
        title = json["title"],
        poster = json["posters"]["small"];
}
