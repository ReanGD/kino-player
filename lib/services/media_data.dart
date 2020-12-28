enum StreamType {
  unknown,
  http,
  hls,
  hls2,
  hls4,
}

StreamType _toStreamType(String v) {
  switch (v) {
    case "http":
      return StreamType.http;
    case "hls":
      return StreamType.hls;
    case "hls2":
      return StreamType.hls2;
    case "hls4":
      return StreamType.hls4;
    default:
      return StreamType.unknown;
  }
}

class VideoData {
  final int width;
  final int height;
  final int qualityId;
  final String quality;
  final String codec;
  final String token;
  final Map<StreamType, String> urls;

  VideoData.fromJson(Map<String, dynamic> json, String token)
      : width = json["w"],
        height = json["h"],
        qualityId = json["quality_id"],
        quality = json["quality"],
        codec = json["codec"],
        token = token,
        urls = (json["url"] as Map)
            .map((key, value) => MapEntry(_toStreamType(key), value));

  String getBestUrl() {
    final key = urls.keys.reduce((k0, k1) => k0.index > k1.index ? k0 : k1);
    return urls[key];
  }
}

class MediaData {
  final Map<int, VideoData> _videos;

  MediaData.fromJson(Map<String, dynamic> json, String token)
      : _videos = Map.fromIterable(
            json["item"]["videos"][0]["files"]
                .map((item) => VideoData.fromJson(item, token)),
            key: (e) => e.qualityId,
            value: (e) => e);

  VideoData getVideoWithBestQuality() {
    final key = _videos.keys.reduce((k0, k1) => k0 > k1 ? k0 : k1);
    return _videos[key];
  }
}
