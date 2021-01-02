import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kino_player/services/token.dart';
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

class KinoPubApi {
  final String _host = "api.service-kp.com";
  final String _authHeader;
  ContentTypesData _contentTypesCache;
  ServerLocationsData _serverLocationsCache;
  GenresData _genresCache;
  StreamTypesData _streamTypesCache;
  VideoQualitiesData _videoQualitiesCache;
  VoiceoversData _voiceoversCache;
  VoiceoverAuthorsData _voiceoverAuthorsCache;
  CountriesData _countriesCache;

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

  Future<ServerLocationsData> getServerLocations() async {
    if (_serverLocationsCache != null) {
      return _serverLocationsCache;
    }
    final Map<String, String> params = {};
    final jsonData = await _get("/v1/references/server-location", params);
    _serverLocationsCache = ServerLocationsData.fromJson(jsonData["items"]);
    return _serverLocationsCache;
  }

  Future<ContentTypesData> getContentTypes() async {
    if (_contentTypesCache != null) {
      return _contentTypesCache;
    }
    final Map<String, String> params = {};
    final jsonData = await _get("/v1/types", params);
    _contentTypesCache = ContentTypesData.fromJson(jsonData["items"]);
    return _contentTypesCache;
  }

  Future<GenresData> getGenres() async {
    if (_genresCache != null) {
      return _genresCache;
    }
    final Map<String, String> params = {};
    final jsonData = await _get("/v1/genres", params);
    _genresCache = GenresData.fromJson(jsonData["items"]);
    return _genresCache;
  }

  Future<StreamTypesData> getStreamTypes() async {
    if (_streamTypesCache != null) {
      return _streamTypesCache;
    }
    final Map<String, String> params = {};
    final jsonData = await _get("/v1/references/streaming-type", params);
    _streamTypesCache = StreamTypesData.fromJson(jsonData["items"]);
    return _streamTypesCache;
  }

  Future<VideoQualitiesData> getVideoQualities() async {
    if (_videoQualitiesCache != null) {
      return _videoQualitiesCache;
    }
    final Map<String, String> params = {};
    final jsonData = await _get("/v1/references/video-quality", params);
    _videoQualitiesCache = VideoQualitiesData.fromJson(jsonData["items"]);
    return _videoQualitiesCache;
  }

  Future<VoiceoversData> getVoiceovers() async {
    if (_voiceoversCache != null) {
      return _voiceoversCache;
    }
    final Map<String, String> params = {};
    final jsonData = await _get("/v1/references/voiceover-type", params);
    _voiceoversCache = VoiceoversData.fromJson(jsonData["items"]);
    return _voiceoversCache;
  }

  Future<VoiceoverAuthorsData> getVoiceoverAuthors() async {
    if (_voiceoverAuthorsCache != null) {
      return _voiceoverAuthorsCache;
    }
    final Map<String, String> params = {};
    final jsonData = await _get("/v1/references/voiceover-author", params);
    _voiceoverAuthorsCache = VoiceoverAuthorsData.fromJson(jsonData["items"]);
    return _voiceoverAuthorsCache;
  }

  Future<CountriesData> getCountries() async {
    if (_countriesCache != null) {
      return _countriesCache;
    }
    final Map<String, String> params = {};
    final jsonData = await _get("/v1/countries", params);
    _countriesCache = CountriesData.fromJson(jsonData["items"]);
    return _countriesCache;
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
