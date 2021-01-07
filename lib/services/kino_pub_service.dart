import 'package:kino_player/services/user_data.dart';
import 'package:kino_player/services/genre_data.dart';
import 'package:kino_player/services/poster_data.dart';
import 'package:kino_player/services/kino_pub_api.dart';
import 'package:kino_player/services/content_type.dart';
import 'package:kino_player/services/country_data.dart';
import 'package:kino_player/services/poster_fetcher.dart';
import 'package:kino_player/services/voiceover_data.dart';
import 'package:kino_player/services/stream_type_data.dart';
import 'package:kino_player/services/video_quality_data.dart';
import 'package:kino_player/services/server_location_data.dart';
import 'package:kino_player/services/voiceover_author_data.dart';
import 'package:kino_player/services/poster_sort_field_data.dart';

class KinoPubService {
  static Future<UserData> getUser() async {
    return KinoPubApi.instance.getUser();
  }

  static Future<ServerLocationsData> getServerLocations() async {
    return KinoPubApi.instance.getServerLocations();
  }

  static Future<ContentTypesData> getContentTypes() {
    return KinoPubApi.instance.getContentTypes();
  }

  static Future<GenresData> getGenres() {
    return KinoPubApi.instance.getGenres();
  }

  static Future<StreamTypesData> getStreamTypes() {
    return KinoPubApi.instance.getStreamTypes();
  }

  static Future<VideoQualitiesData> getVideoQualities() {
    return KinoPubApi.instance.getVideoQualities();
  }

  static Future<VoiceoversData> getVoiceovers() {
    return KinoPubApi.instance.getVoiceovers();
  }

  static Future<VoiceoverAuthorsData> getVoiceoverAuthors() {
    return KinoPubApi.instance.getVoiceoverAuthors();
  }

  static Future<CountriesData> getCountries() {
    return KinoPubApi.instance.getCountries();
  }

  static PosterSortFieldsData getPosterSortFields() {
    return KinoPubApi.instance.getPosterSortFields();
  }

  static PosterFetcher getPosters(PostersRequestParams params) {
    return PosterFetcher((int page, int perPage) {
      return KinoPubApi.instance.getPosters(params, page, perPage);
    });
  }

  static PosterFetcher getHot(String contentTypeId) {
    return PosterFetcher((int page, int perPage) {
      return KinoPubApi.instance.getHot(contentTypeId, page, perPage);
    });
  }

  static PosterFetcher getFresh(String contentTypeId) {
    return PosterFetcher((int page, int perPage) {
      return KinoPubApi.instance.getFresh(contentTypeId, page, perPage);
    });
  }

  static PosterFetcher getPopular(String contentTypeId) {
    return PosterFetcher((int page, int perPage) {
      return KinoPubApi.instance.getPopular(contentTypeId, page, perPage);
    });
  }
}
