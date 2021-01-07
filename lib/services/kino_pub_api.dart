import 'dart:io';
import 'dart:async';
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
import 'package:kino_player/services/poster_sort_field_data.dart';

class ApiException implements Exception {
  final String path;
  final String message;

  const ApiException(this.path, this.message);

  // TODO: add localization
  String toString() => "API call $path finished with error: $message";
}

class ApiAuthException implements Exception {
  final String path;
  const ApiAuthException(this.path);

  // TODO: add localization
  String toString() => "API call $path finished with auth error";
}

class _CacheValue<T> {
  T value;
  bool isFilled = false;
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
  var _posterSortFieldsCache = _CacheValue<PosterSortFieldsData>();

  KinoPubApi._() : _authHeader = "Bearer $token";

  static final KinoPubApi instance = KinoPubApi._();

  Future<T> _get<T>(
    String path,
    Map<String, String> params,
    T ctor(Map<String, dynamic> _),
  ) async {
    http.Response response;
    try {
      final uri = Uri.https(_host, path, params);
      response = await http.get(uri, headers: {
        HttpHeaders.authorizationHeader: _authHeader,
        HttpHeaders.contentTypeHeader: "application/json",
      });
    } on SocketException {
      // TODO: add localization
      throw ApiException(path, "no internet connection");
    } on TimeoutException catch (e) {
      // TODO: add localization
      throw ApiException(path, "connection timeout ($e)");
    } catch (e) {
      throw ApiException(path, e.toString());
    }

    if (response.statusCode == 401) {
      throw ApiAuthException(path);
    } else if (response.statusCode != 200) {
      // TODO: add localization
      throw ApiException(path, "status code = ${response.statusCode}");
    }

    Map<String, dynamic> jsonData;
    try {
      jsonData = jsonDecode(response.body);
    } catch (e) {
      // TODO: add localization
      throw ApiException(path, "failed parse json ($e)");
    }

    try {
      return ctor(jsonData);
    } catch (e) {
      // TODO: add localization
      throw ApiException(path, "failed parse answer ($e)");
    }
  }

  Future<T> _getWithCache<T>(
    String path,
    _CacheValue<T> cacheValue,
    T ctor(Map<String, dynamic> _),
  ) async {
    if (!cacheValue.isFilled) {
      cacheValue.value = await _get(path, Map<String, String>(), ctor);
      cacheValue.isFilled = true;
    }
    return cacheValue.value;
  }

  Future<UserData> getUser() {
    return _getWithCache(
        "/v1/user", _userCache, (j) => UserData.fromJson(j["user"]));
  }

  Future<ServerLocationsData> getServerLocations() {
    return _getWithCache("/v1/references/server-location",
        _serverLocationsCache, (j) => ServerLocationsData.fromJson(j["items"]));
  }

  Future<ContentTypesData> getContentTypes() {
    return _getWithCache("/v1/types", _contentTypesCache,
        (j) => ContentTypesData.fromJson(j["items"]));
  }

  Future<GenresData> getGenres() {
    return _getWithCache(
        "/v1/genres", _genresCache, (j) => GenresData.fromJson(j["items"]));
  }

  Future<StreamTypesData> getStreamTypes() {
    return _getWithCache("/v1/references/streaming-type", _streamTypesCache,
        (j) => StreamTypesData.fromJson(j["items"]));
  }

  Future<VideoQualitiesData> getVideoQualities() {
    return _getWithCache("/v1/references/video-quality", _videoQualitiesCache,
        (j) => VideoQualitiesData.fromJson(j["items"]));
  }

  Future<VoiceoversData> getVoiceovers() {
    return _getWithCache("/v1/references/voiceover-type", _voiceoversCache,
        (j) => VoiceoversData.fromJson(j["items"]));
  }

  Future<VoiceoverAuthorsData> getVoiceoverAuthors() {
    return _getWithCache(
        "/v1/references/voiceover-author",
        _voiceoverAuthorsCache,
        (j) => VoiceoverAuthorsData.fromJson(j["items"]));
  }

  Future<CountriesData> getCountries() {
    return _getWithCache("/v1/countries", _countriesCache,
        (j) => CountriesData.fromJson(j["items"]));
  }

  PosterSortFieldsData getPosterSortFields() {
    if (!_posterSortFieldsCache.isFilled) {
      try {
        _posterSortFieldsCache.value = PosterSortFieldsData();
      } catch (e) {
        // TODO: add localization
        throw ApiException(
            "local/PosterSortFields", "failed to init directory ($e)");
      }

      _posterSortFieldsCache.isFilled = true;
    }

    return _posterSortFieldsCache.value;
  }

  Future<VideoFilesData> getVideoFiles(int mediaId) {
    final Map<String, String> params = {"mid": mediaId.toString()};
    return _get("/v1/items/media-links", params,
        (j) => VideoFilesData.fromJson(j, _authHeader));
  }

  Future<ContentData> getContent(PosterData posterData) {
    final params = {"nolinks": "1"};
    return _get("/v1/items/${posterData.id}", params,
        (j) => ContentData.fromJson(posterData, j["item"]));
  }

  Future<PostersData> getPosters(
      PostersRequestParams p, int page, int perPage) {
    var params = {
      "page": page.toString(),
      "perpage": perPage.toString(),
    };
    if (p.sort.length != 0) {
      params["sort"] = p.sort.join(",");
    }
    if (p.contentTypeId.isNotEmpty) {
      params["type"] = p.contentTypeId;
    }
    return _get("/v1/items", params, (j) => PostersData.fromJson(j));
  }

  Future<PostersData> getHot(String contentTypeId, int page, int perPage) {
    final params = {
      "type": contentTypeId,
      "page": page.toString(),
      "perpage": perPage.toString(),
    };
    return _get("/v1/items/hot", params, (j) => PostersData.fromJson(j));
  }

  Future<PostersData> getFresh(String contentTypeId, int page, int perPage) {
    final params = {
      "type": contentTypeId,
      "page": page.toString(),
      "perpage": perPage.toString(),
    };
    return _get("/v1/items/fresh", params, (j) => PostersData.fromJson(j));
  }

  Future<PostersData> getPopular(String contentTypeId, int page, int perPage) {
    final params = {
      "type": contentTypeId,
      "page": page.toString(),
      "perpage": perPage.toString(),
    };
    return _get("/v1/items/popular", params, (j) => PostersData.fromJson(j));
  }
}
