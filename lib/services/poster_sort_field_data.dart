import 'package:kino_player/generated/l10n.dart';

class PosterSortFieldData {
  final String id;
  final String title;

  PosterSortFieldData(this.id, this.title);
}

class PosterSortFieldsData {
  final List<PosterSortFieldData> items;
  static const defaultId = "-kinopoisk_rating";

  static List<PosterSortFieldData> _init() {
    List<PosterSortFieldData> items = [];
    items.add(PosterSortFieldData(
        "kinopoisk_rating", S.current.posterSortFieldDataByKinopoiskRating));
    items.add(PosterSortFieldData(
        "imdb_rating", S.current.posterSortFieldDataByIMDbRating));

    return items;
  }

  PosterSortFieldsData() : items = _init();
}
