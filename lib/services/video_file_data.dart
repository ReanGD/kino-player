class VideoFileData {
  final int width;
  final int height;
  final int qualityId;
  final String quality;
  final String codec;
  final String authHeader;
  final Map<String, String> urls;

  VideoFileData.fromJson(Map<String, dynamic> json, this.authHeader)
      : width = json["w"],
        height = json["h"],
        qualityId = json["quality_id"],
        quality = json["quality"],
        codec = json["codec"],
        urls = Map<String, String>.from(json["url"]);

  String getUrl(String streamCode) {
    if (!urls.containsKey(streamCode)) {
      throw Exception("Not found video file for stream type $streamCode");
    }

    return urls[streamCode];
  }
}

class VideoFilesData {
  // qualityId <=> VideoFileData
  final Map<int, VideoFileData> items;

  VideoFilesData.fromJson(Map<String, dynamic> json, String authHeader)
      : items = Map.fromIterable(
            json["files"]
                .map((item) => VideoFileData.fromJson(item, authHeader)),
            key: (e) => e.qualityId,
            value: (e) => e);

  VideoFileData getWithBestQuality() {
    final key = items.keys.reduce((k0, k1) => k0 > k1 ? k0 : k1);
    return items[key];
  }

  VideoFileData getVideoFile(int videoQualityId) {
    if (items.containsKey(videoQualityId)) {
      return items[videoQualityId];
    }

    if (items.keys.where((it) => it <= videoQualityId).length > 0) {
      final key = items.keys
          .where((it) => it <= videoQualityId)
          .reduce((k0, k1) => k0 > k1 ? k0 : k1);
      return items[key];
    }

    final key = items.keys.reduce((k0, k1) => k0 < k1 ? k0 : k1);
    return items[key];
  }
}
