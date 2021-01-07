// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static m0(error) => "Ошибка: ${error}";

  static m1(proDays) => "дней: ${proDays}";

  static m2(min) => "${min} мин";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "error" : m0,
    "posterSortFieldDataNewKinopub" : MessageLookupByLibrary.simpleMessage("Новое на Kinopub"),
    "posterSortFieldDataTopIMDb" : MessageLookupByLibrary.simpleMessage("Топ IMDb"),
    "posterSortFieldDataTopKinopoisk" : MessageLookupByLibrary.simpleMessage("Топ кинопоиска"),
    "postersNavbarDays" : m1,
    "previewActors" : MessageLookupByLibrary.simpleMessage("В ролях"),
    "previewComments" : MessageLookupByLibrary.simpleMessage("Коментарии"),
    "previewCountry" : MessageLookupByLibrary.simpleMessage("Страна"),
    "previewDirector" : MessageLookupByLibrary.simpleMessage("Режисер"),
    "previewEpisodeDuration" : MessageLookupByLibrary.simpleMessage("Время"),
    "previewGenre" : MessageLookupByLibrary.simpleMessage("Жанр"),
    "previewMinutes" : m2,
    "previewOriginalTitle" : MessageLookupByLibrary.simpleMessage("Оригинальное название"),
    "previewRating" : MessageLookupByLibrary.simpleMessage("Рейтинг"),
    "previewTrailer" : MessageLookupByLibrary.simpleMessage("Трейлер"),
    "previewViewFilm" : MessageLookupByLibrary.simpleMessage("Смотреть фильм"),
    "previewYear" : MessageLookupByLibrary.simpleMessage("Год")
  };
}
