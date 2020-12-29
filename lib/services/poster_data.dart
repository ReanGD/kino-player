import 'package:kino_player/services/content_data.dart';
import 'package:kino_player/services/kino_pub_api.dart';

class PosterData {
  final int id;
  final int year;
  final double imdbRating;
  final double kinopoiskRating;
  final double kinopubRating;
  final String plot;
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
        plot = json["plot"],
        title = json["title"],
        poster = json["posters"]["small"];

  Future<ContentData> getContent() {
    return KinoPubApi.instance.getContent(this);
  }
}

class PostersData {
  final int total;
  final List<PosterData> items;

  PostersData.fromJson(Map<String, dynamic> json)
      : total = json["pagination"]["total_items"],
        items = (json["items"] as List)
            .map((item) => PosterData.fromJson(item))
            .toList();
}
