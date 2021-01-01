import 'package:kino_player/services/genre_data.dart';
import 'package:kino_player/services/poster_data.dart';
import 'package:kino_player/services/kino_pub_api.dart';
import 'package:kino_player/services/country_data.dart';
import 'package:kino_player/services/video_file_data.dart';

class EpisodeData {
  final int mediaId;
  final int episodeNumber;
  final int seasonNumber;
  final String thumbnail;

  EpisodeData.fromJson(Map<String, dynamic> json)
      : mediaId = json["id"],
        episodeNumber = json["number"],
        seasonNumber = json["snumber"],
        thumbnail = json["thumbnail"];

  Future<VideoFilesData> getFiles() {
    return KinoPubApi.instance.getVideoFiles(mediaId);
  }
}

class SeasonData {
  final int seasonNumber;
  // episodeNumber <=> EpisodeData
  final Map<int, EpisodeData> items;

  SeasonData.fromJson(this.seasonNumber, List<dynamic> json)
      : items = Map.fromIterable(json.map((item) => EpisodeData.fromJson(item)),
            key: (e) => e.episodeNumber, value: (e) => e);
}

class ContentData {
  final PosterData _posterData;
  final String trailer;
  // TODO: bookmarks
  // seasonNumber <=> SeasonData
  final Map<int, SeasonData> seasons;

  String get titleLocal => _posterData.titleLocal;
  String get titleOriginal => _posterData.titleOriginal;
  int get year => _posterData.year;
  List<String> get actors => _posterData.actors;
  List<String> get directors => _posterData.directors;
  List<GenreData> get genres => _posterData.genres;
  CountriesData get countries => _posterData.countries;
  Duration get averageDuration => _posterData.averageDuration;
  Duration get totalDuration => _posterData.totalDuration;
  bool get existsAC3 => _posterData.existsAC3;
  int get audioTracksCount => _posterData.audioTracksCount;
  int get quality => _posterData.quality;
  String get plot => _posterData.plot;
  int get imdbId => _posterData.imdbId;
  int get imdbVotes => _posterData.imdbVotes;
  double get imdbRating => _posterData.imdbRating;
  int get kinopoiskId => _posterData.kinopoiskId;
  int get kinopoiskVotes => _posterData.kinopoiskVotes;
  double get kinopoiskRating => _posterData.kinopoiskRating;
  int get kinopubVotes => _posterData.kinopubVotes;
  int get kinopubRatingAbsolute => _posterData.kinopubRatingAbsolute;
  double get kinopubRating => _posterData.kinopubRating;
  int get views => _posterData.views;
  int get numberOfcomments => _posterData.numberOfcomments;
  String get posterSmall => _posterData.posterSmall;
  String get posterWide => _posterData.posterWide;
  bool get serialFinished => _posterData.serialFinished;
  bool get existsAds => _posterData.existsAds;
  bool get isPoorQuality => _posterData.isPoorQuality;
  bool get isUserSubscribed => _posterData.isUserSubscribed;

  ContentData.fromJson(this._posterData, Map<String, dynamic> json)
      : trailer = json.containsKey("trailer") ? json["trailer"]["url"] : null,
        seasons = json.containsKey("videos")
            ? {1: SeasonData.fromJson(1, json["videos"])}
            : Map.fromIterable(
                json["seasons"].map((item) =>
                    SeasonData.fromJson(item["number"], item["episodes"])),
                key: (e) => e.seasonNumber,
                value: (e) => e);
}
