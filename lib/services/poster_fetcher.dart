import 'package:kino_player/services/poster_data.dart';

typedef AsyncPostersCallback = Future<PostersData> Function(
    int page, int perPage);

class PosterFetcher {
  static const int _perPage = 8;
  final AsyncPostersCallback _callback;
  int _page = 0;
  int _total = 0;

  PosterFetcher(this._callback);

  int get total => _total;

  Future<List<PosterData>> getNext() async {
    _page++;
    final result = await _callback(_page, _perPage);
    _total = result.total;
    return result.items;
  }
}
