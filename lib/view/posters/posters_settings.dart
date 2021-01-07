import 'package:flutter/widgets.dart';
import 'package:kino_player/services/poster_data.dart';
import 'package:kino_player/services/content_type.dart';
import 'package:kino_player/services/poster_sort_field_data.dart';

class PostersSettings extends ChangeNotifier {
  PostersRequestParams _actual;
  PostersRequestParams _new;

  PostersSettings() {
    _actual = PostersRequestParams(
      sort: [PosterSortFieldsData.defaultId],
      contentTypeId: ContentTypesData.defaultId,
    );
    _new = PostersRequestParams.clone(_actual);
  }

  PostersRequestParams get requestParams => _actual;

  String get sortFirst => _actual.sort[0];
  set sortFirst(String v) => _new.sort[0] = v;

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
