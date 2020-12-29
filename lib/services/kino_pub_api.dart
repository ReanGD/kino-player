import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kino_player/services/token.dart';
import 'package:kino_player/services/media_data.dart';
import 'package:kino_player/services/poster_data.dart';

class KinoPubApi {
  final String _host = "api.service-kp.com";
  final String _authHeader;

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

  Future<ContentTypesData> getContentTypes() async {
    final Map<String, String> params = {};
    final jsonData = await _get("/v1/types", params);
    return ContentTypesData.fromJson(jsonData["items"]);
  }

  Future<StreamTypesData> getStreamTypes() async {
    final Map<String, String> params = {};
    final jsonData = await _get("/v1/references/streaming-type", params);
    return StreamTypesData.fromJson(jsonData["items"]);
  }

  }

  }

    final params = {
      "type": type,
      "page": page.toString(),
      "perpage": perPage.toString(),
    };
    final jsonData = await _get("/v1/items/hot", params);
    return PostersData.fromJson(jsonData);
  }

  Future<PostersData> getFresh(String type, int page, int perPage) async {
    final params = {
      "type": type,
      "page": page.toString(),
      "perpage": perPage.toString(),
    };
    final jsonData = await _get("/v1/items/fresh", params);
    return PostersData.fromJson(jsonData);
  }

  Future<PostersData> getPopular(String type, int page, int perPage) async {
    final params = {
      "type": type,
      "page": page.toString(),
      "perpage": perPage.toString(),
    };
    final jsonData = await _get("/v1/items/popular", params);
    return PostersData.fromJson(jsonData);
  }
    final jsonData = await _get("/v1/items/$id", params);
    return MediaData.fromJson(jsonData, _token);
  }
}
