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

  static m0(errorMessage) => "не удалось распарсить ответ (${errorMessage})";

  static m1(path) => "API вызов ${path} завершился с ошибкой aутентификация";

  static m2(path, errorMessage) => "API вызов ${path} завершился с ошибкой, ${errorMessage}";

  static m3(errorMessage) => "таймаут подключения истёк (${errorMessage})";

  static m4(errorMessage) => "не удалось распарсить json (${errorMessage})";

  static m5(errorMessage) => "загрузка локального справочника заверилось с ошибкой, (${errorMessage})";

  static m6(statusCode) => "неуспешный код возврата = ${statusCode}";

  static m7(error) => "Ошибка: ${error}";

  static m8(proDays) => "дней: ${proDays}";

  static m9(min) => "${min} мин";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "apiAnswerParseError" : m0,
    "apiAuthError" : m1,
    "apiCallFinishedWithError" : m2,
    "apiConnectionTimeout" : m3,
    "apiJsonParseError" : m4,
    "apiLocalReferenceInitError" : m5,
    "apiNoInternetConnection" : MessageLookupByLibrary.simpleMessage("отсутствует подключение к интернету"),
    "apiWrongStatusCode" : m6,
    "error" : m7,
    "posterSortFieldDataNewKinopub" : MessageLookupByLibrary.simpleMessage("Новое на Kinopub"),
    "posterSortFieldDataTopIMDb" : MessageLookupByLibrary.simpleMessage("Топ IMDb"),
    "posterSortFieldDataTopKinopoisk" : MessageLookupByLibrary.simpleMessage("Топ кинопоиска"),
    "postersNavbarDays" : m8,
    "previewActors" : MessageLookupByLibrary.simpleMessage("В ролях"),
    "previewComments" : MessageLookupByLibrary.simpleMessage("Коментарии"),
    "previewCountry" : MessageLookupByLibrary.simpleMessage("Страна"),
    "previewDirector" : MessageLookupByLibrary.simpleMessage("Режисер"),
    "previewEpisodeDuration" : MessageLookupByLibrary.simpleMessage("Время"),
    "previewGenre" : MessageLookupByLibrary.simpleMessage("Жанр"),
    "previewMinutes" : m9,
    "previewOriginalTitle" : MessageLookupByLibrary.simpleMessage("Оригинальное название"),
    "previewRating" : MessageLookupByLibrary.simpleMessage("Рейтинг"),
    "previewTrailer" : MessageLookupByLibrary.simpleMessage("Трейлер"),
    "previewViewFilm" : MessageLookupByLibrary.simpleMessage("Смотреть фильм"),
    "previewYear" : MessageLookupByLibrary.simpleMessage("Год"),
    "retry" : MessageLookupByLibrary.simpleMessage("Повторить попытку")
  };
}
