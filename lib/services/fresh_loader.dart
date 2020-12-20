import 'package:kino_player/services/poster_data.dart';
import 'package:kino_player/services/kino_pub_api.dart';

class FreshLoader {
  final _api = KinoPubApi.instance;
  static const String _type = "movie";
  static const int _perPage = 25;
  int _page = 0;

  Future<List<PosterData>> getFirst() async {
    _page = 0;
    return _api.getFresh(_type, _page, _perPage);
  }

  Future<List<PosterData>> getNext() async {
    _page++;
    return _api.getFresh(_type, _page, _perPage);
  }
}
