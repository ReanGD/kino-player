import 'package:kino_player/services/poster_data.dart';
import 'package:kino_player/services/kino_pub_api.dart';

class FreshLoader {
  final _api = KinoPubApi.instance;
  static const String _type = "movie";
  static const int _perPage = 25;
  int _page = 0;
  int _total = 0;

  int get total => _total;

  Future<List<PosterData>> getNext() async {
    final result = await _api.getFresh(_type, _page, _perPage);
    _total = result.total;
    _page++;
    return result.posters;
  }
}
