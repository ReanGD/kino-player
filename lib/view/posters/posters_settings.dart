import 'package:flutter/widgets.dart';
import 'package:kino_player/services/poster_data.dart';

class PostersSettings extends ChangeNotifier {
  PostersRequestParams _actual;
  PostersRequestParams _new;

  PostersSettings() {
    _actual = PostersRequestParams(contentTypeId: "movie");
    _new = PostersRequestParams.clone(_actual);
  }

  PostersRequestParams get requestParams => _actual;

  String get contentTypeId => _actual.contentTypeId;
  set contentTypeId(String v) => _new.contentTypeId = v;

  void apply() {
    if (_actual == _new) {
      return;
    }
    _actual = PostersRequestParams.clone(_new);
    notifyListeners();
  }
}
