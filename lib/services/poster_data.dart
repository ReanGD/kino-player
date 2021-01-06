import 'package:kino_player/services/genre_data.dart';
import 'package:kino_player/services/content_data.dart';
import 'package:kino_player/services/country_data.dart';
import 'package:kino_player/services/kino_pub_api.dart';

class PosterData {
  final int id;
  final String contentTypeId;
  final String titleLocal;
  final String titleOriginal;
  final int year;
  final List<String> actors;
  final List<String> directors;
  final List<GenreData> genres;
  final CountriesData countries;
  // for episode
  final Duration averageDuration;
  final Duration totalDuration;
  final bool existsAC3;
  final int audioTracksCount;
  // == VideoQualityData.quality
  final int quality;
  final String plot;
  final int imdbId;
  final int imdbVotes;
  final double imdbRating;
  final int kinopoiskId;
  final int kinopoiskVotes;
  final double kinopoiskRating;
  final int kinopubVotes;
  // == (positive - negative)
  final int kinopubRatingAbsolute;
  // == (positive / kinopubVotes) * 10
  final double kinopubRating;
  final int views;
  final int numberOfcomments;
  final String posterSmall;
  final String posterWide;
  final bool serialFinished;
  final bool existsAds;
  final bool isPoorQuality;
  final bool isUserSubscribed;

  static String _getTitle(String s, bool isLocal) {
    final arr = s.split(" / ");
    return isLocal || arr.length < 2 ? arr[0] : arr[1];
  }

  static List<String> _split(String s) {
    return s.split(",").map((item) => item.trim()).toList();
  }

  static String _widePoster(Map<String, dynamic> posters) {
    if (posters["wide"] != null) {
      return posters["wide"];
    } else if (posters["big"] != null) {
      return posters["big"];
    } else if (posters["medium"] != null) {
      return posters["medium"];
    } else if (posters["small"] != null) {
      return posters["small"];
    }
    // TODO: add localization and new exception type
    throw Exception("Not found any poster");
  }

  PosterData.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        contentTypeId = json["type"],
        titleLocal = _getTitle(json["title"], true),
        titleOriginal = _getTitle(json["title"], false),
        year = json["year"],
        actors = _split(json["cast"]),
        directors = _split(json["director"]),
        genres = (json["genres"] as List)
            .map((it) => GenreData.fromJson(it))
            .toList(),
        countries = CountriesData.fromJson(json["countries"]),
        averageDuration =
            Duration(seconds: json["duration"]["average"].toInt()),
        totalDuration = Duration(seconds: json["duration"]["total"]),
        existsAC3 = (json["ac3"] == 1),
        audioTracksCount = json["langs"],
        quality = json["quality"],
        plot = json["plot"],
        imdbId = json["imdbId"],
        imdbVotes = json["imdb_votes"] == null ? 0 : json["imdb_votes"],
        imdbRating =
            json["imdb_rating"] == null ? 0 : json["imdb_rating"].toDouble(),
        kinopoiskId = json["kinopoisk"],
        kinopoiskVotes =
            json["kinopoisk_votes"] == null ? 0 : json["kinopoisk_votes"],
        kinopoiskRating = json["kinopoisk_rating"] == null
            ? 0
            : json["kinopoisk_rating"].toDouble(),
        kinopubVotes = json["rating_votes"],
        kinopubRatingAbsolute = json["rating"],
        kinopubRating = json["rating_percentage"] == null
            ? 0
            : json["rating_percentage"].toDouble() / 10.0,
        views = json["views"],
        numberOfcomments = json["comments"] == null ? 0 : json["comments"],
        posterSmall = json["posters"]["small"],
        posterWide = _widePoster(json["posters"]),
        serialFinished = json["finished"],
        existsAds = json["advert"],
        isPoorQuality = json["poor_quality"],
        isUserSubscribed = json["subscribed"];

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

class PostersRequestParams {
  String contentTypeId = "";

  PostersRequestParams({this.contentTypeId});

  PostersRequestParams.clone(PostersRequestParams other)
      : contentTypeId = other.contentTypeId;
}
