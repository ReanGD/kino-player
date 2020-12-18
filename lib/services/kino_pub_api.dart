import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class VideoMetaData {
  final int id;
  final String title;
  final String poster;

  VideoMetaData.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        poster = json["posters"]["medium"];
}

class KinoPubApi {
  final String host = "api.service-kp.com";
  final String _token;

  KinoPubApi(this._token);

  Future<List<VideoMetaData>> getFresh() async {
    const params = {
      "type": "movie",
      "page": "0",
      "perpage": "100",
    };
    final uri = Uri.https(host, "/v1/items/fresh", params);
    final response = await http.get(uri, headers: {
      HttpHeaders.authorizationHeader: "Bearer $_token",
      HttpHeaders.contentTypeHeader: "application/json",
    });

    if (response.statusCode != 200) {
      throw Exception("Failed to load fresh films ");
    }
    final jsonData = jsonDecode(response.body);
    final jsonItems = jsonData["items"] as List;
    return jsonItems.map((item) => VideoMetaData.fromJson(item)).toList();
  }
}
