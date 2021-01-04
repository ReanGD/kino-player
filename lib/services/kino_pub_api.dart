import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kino_player/services/token.dart';
import 'package:kino_player/services/user_data.dart';
import 'package:kino_player/services/genre_data.dart';
import 'package:kino_player/services/poster_data.dart';
import 'package:kino_player/services/country_data.dart';
import 'package:kino_player/services/content_type.dart';
import 'package:kino_player/services/content_data.dart';
import 'package:kino_player/services/voiceover_data.dart';
import 'package:kino_player/services/video_file_data.dart';
import 'package:kino_player/services/stream_type_data.dart';
import 'package:kino_player/services/video_quality_data.dart';
import 'package:kino_player/services/server_location_data.dart';
import 'package:kino_player/services/voiceover_author_data.dart';

class _CacheValue<T> {
  T _value;
  bool _isFilled = false;

  bool get isFilled => _isFilled;
  T get value => _value;

  T fill(T value) {
    _isFilled = true;
    _value = value;
    return _value;
  }
}

class KinoPubApi {
  final String _host = "api.service-kp.com";
  final String _authHeader;
  var _userCache = _CacheValue<UserData>();
  var _contentTypesCache = _CacheValue<ContentTypesData>();
  var _serverLocationsCache = _CacheValue<ServerLocationsData>();
  var _genresCache = _CacheValue<GenresData>();
  var _streamTypesCache = _CacheValue<StreamTypesData>();
  var _videoQualitiesCache = _CacheValue<VideoQualitiesData>();
  var _voiceoversCache = _CacheValue<VoiceoversData>();
  var _voiceoverAuthorsCache = _CacheValue<VoiceoverAuthorsData>();
  var _countriesCache = _CacheValue<CountriesData>();

  KinoPubApi._() : _authHeader = "Bearer $token";

  static final KinoPubApi instance = KinoPubApi._();

  Future<Map<String, dynamic>> _get(
      String path, Map<String, String> params) async {
    final uri = Uri.https(_host, path, params);
    final response = await http.get(uri, headers: {
      HttpHeaders.authorizationHeader: _authHeader,
      HttpHeaders.contentTypeHeader: "application/json",
    });

    if (response.statusCode != 200) {
      throw Exception(
          "Failed to load url $path, status code = ${response.statusCode}");
    }

    return jsonDecode(response.body);
  }

  Future<UserData> getUser() async {
    if (_userCache.isFilled) {
      return _userCache.value;
    }
    final Map<String, String> params = {};
    final jsonData = await _get("/v1/user", params);
    return _userCache.fill(UserData.fromJson(jsonData["user"]));
  }

  Future<ServerLocationsData> getServerLocations() async {
    if (_serverLocationsCache.isFilled) {
      return _serverLocationsCache.value;
    }
    final Map<String, String> params = {};
    final jsonData = await _get("/v1/references/server-location", params);
    return _serverLocationsCache
        .fill(ServerLocationsData.fromJson(jsonData["items"]));
  }

  Future<ContentTypesData> getContentTypes() async {
    if (_contentTypesCache.isFilled) {
      return _contentTypesCache.value;
    }
    final Map<String, String> params = {};
    final jsonData = await _get("/v1/types", params);
    return _contentTypesCache
        .fill(ContentTypesData.fromJson(jsonData["items"]));
  }

  Future<GenresData> getGenres() async {
    if (_genresCache.isFilled) {
      return _genresCache.value;
    }
    final Map<String, String> params = {};
    final jsonData = await _get("/v1/genres", params);
    return _genresCache.fill(GenresData.fromJson(jsonData["items"]));
  }

  Future<StreamTypesData> getStreamTypes() async {
    if (_streamTypesCache.isFilled) {
      return _streamTypesCache.value;
    }
    final Map<String, String> params = {};
    final jsonData = await _get("/v1/references/streaming-type", params);
    return _streamTypesCache.fill(StreamTypesData.fromJson(jsonData["items"]));
  }

  Future<VideoQualitiesData> getVideoQualities() async {
    if (_videoQualitiesCache.isFilled) {
      return _videoQualitiesCache.value;
    }
    final Map<String, String> params = {};
    final jsonData = await _get("/v1/references/video-quality", params);
    return _videoQualitiesCache
        .fill(VideoQualitiesData.fromJson(jsonData["items"]));
  }

  Future<VoiceoversData> getVoiceovers() async {
    if (_voiceoversCache.isFilled) {
      return _voiceoversCache.value;
    }
    final Map<String, String> params = {};
    final jsonData = await _get("/v1/references/voiceover-type", params);
    return _voiceoversCache.fill(VoiceoversData.fromJson(jsonData["items"]));
  }

  Future<VoiceoverAuthorsData> getVoiceoverAuthors() async {
    if (_voiceoverAuthorsCache.isFilled) {
      return _voiceoverAuthorsCache.value;
    }
    final Map<String, String> params = {};
    final jsonData = await _get("/v1/references/voiceover-author", params);
    return _voiceoverAuthorsCache
        .fill(VoiceoverAuthorsData.fromJson(jsonData["items"]));
  }

  Future<CountriesData> getCountries() async {
    if (_countriesCache.isFilled) {
      return _countriesCache.value;
    }
    final Map<String, String> params = {};
    final jsonData = await _get("/v1/countries", params);
    return _countriesCache.fill(CountriesData.fromJson(jsonData["items"]));
  }

  Future<VideoFilesData> getVideoFiles(int mediaId) async {
    final Map<String, String> params = {"mid": mediaId.toString()};
    final jsonData = await _get("/v1/items/media-links", params);
    return VideoFilesData.fromJson(jsonData, _authHeader);
  }

  Future<ContentData> getContent(PosterData posterData) async {
    final params = {"nolinks": "1"};
    final posterId = posterData.id;
    final jsonData = await _get("/v1/items/$posterId", params);
    return ContentData.fromJson(posterData, jsonData["item"]);
  }

  Future<PostersData> getHot(String contentType, int page, int perPage) async {
    final params = {
      "type": contentType,
      "page": page.toString(),
      "perpage": perPage.toString(),
    };
    final jsonData = await _get("/v1/items/hot", params);
    return PostersData.fromJson(jsonData);
  }

  Future<PostersData> getFresh(
      String contentType, int page, int perPage) async {
    final params = {
      "type": contentType,
      "page": page.toString(),
      "perpage": perPage.toString(),
    };
    final jsonData = await _get("/v1/items/fresh", params);
    return PostersData.fromJson(jsonData);
  }

  Future<PostersData> getPopular(
      String contentType, int page, int perPage) async {
    final params = {
      "type": contentType,
      "page": page.toString(),
      "perpage": perPage.toString(),
    };
    final jsonData = await _get("/v1/items/popular", params);
    return PostersData.fromJson(jsonData);
  }
}
