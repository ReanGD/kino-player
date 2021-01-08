// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Ошибка: {error}`
  String error(Object error) {
    return Intl.message(
      'Ошибка: $error',
      name: 'error',
      desc: '',
      args: [error],
    );
  }

  /// `дней: {proDays}`
  String postersNavbarDays(Object proDays) {
    return Intl.message(
      'дней: $proDays',
      name: 'postersNavbarDays',
      desc: '',
      args: [proDays],
    );
  }

  /// `Смотреть фильм`
  String get previewViewFilm {
    return Intl.message(
      'Смотреть фильм',
      name: 'previewViewFilm',
      desc: '',
      args: [],
    );
  }

  /// `Трейлер`
  String get previewTrailer {
    return Intl.message(
      'Трейлер',
      name: 'previewTrailer',
      desc: '',
      args: [],
    );
  }

  /// `Год`
  String get previewYear {
    return Intl.message(
      'Год',
      name: 'previewYear',
      desc: '',
      args: [],
    );
  }

  /// `Рейтинг`
  String get previewRating {
    return Intl.message(
      'Рейтинг',
      name: 'previewRating',
      desc: '',
      args: [],
    );
  }

  /// `Страна`
  String get previewCountry {
    return Intl.message(
      'Страна',
      name: 'previewCountry',
      desc: '',
      args: [],
    );
  }

  /// `Жанр`
  String get previewGenre {
    return Intl.message(
      'Жанр',
      name: 'previewGenre',
      desc: '',
      args: [],
    );
  }

  /// `Оригинальное название`
  String get previewOriginalTitle {
    return Intl.message(
      'Оригинальное название',
      name: 'previewOriginalTitle',
      desc: '',
      args: [],
    );
  }

  /// `Режисер`
  String get previewDirector {
    return Intl.message(
      'Режисер',
      name: 'previewDirector',
      desc: '',
      args: [],
    );
  }

  /// `В ролях`
  String get previewActors {
    return Intl.message(
      'В ролях',
      name: 'previewActors',
      desc: '',
      args: [],
    );
  }

  /// `Время`
  String get previewEpisodeDuration {
    return Intl.message(
      'Время',
      name: 'previewEpisodeDuration',
      desc: '',
      args: [],
    );
  }

  /// `Коментарии`
  String get previewComments {
    return Intl.message(
      'Коментарии',
      name: 'previewComments',
      desc: '',
      args: [],
    );
  }

  /// `{min} мин`
  String previewMinutes(Object min) {
    return Intl.message(
      '$min мин',
      name: 'previewMinutes',
      desc: '',
      args: [min],
    );
  }

  /// `Топ кинопоиска`
  String get posterSortFieldDataTopKinopoisk {
    return Intl.message(
      'Топ кинопоиска',
      name: 'posterSortFieldDataTopKinopoisk',
      desc: '',
      args: [],
    );
  }

  /// `Топ IMDb`
  String get posterSortFieldDataTopIMDb {
    return Intl.message(
      'Топ IMDb',
      name: 'posterSortFieldDataTopIMDb',
      desc: '',
      args: [],
    );
  }

  /// `Новое на Kinopub`
  String get posterSortFieldDataNewKinopub {
    return Intl.message(
      'Новое на Kinopub',
      name: 'posterSortFieldDataNewKinopub',
      desc: '',
      args: [],
    );
  }

  /// `отсутствует подключение к интернету`
  String get apiNoInternetConnection {
    return Intl.message(
      'отсутствует подключение к интернету',
      name: 'apiNoInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `таймаут подключения истёк ({errorMessage})`
  String apiConnectionTimeout(Object errorMessage) {
    return Intl.message(
      'таймаут подключения истёк ($errorMessage)',
      name: 'apiConnectionTimeout',
      desc: '',
      args: [errorMessage],
    );
  }

  /// `не успешный код возврата = {statusCode}`
  String apiWrongStatusCode(Object statusCode) {
    return Intl.message(
      'не успешный код возврата = $statusCode',
      name: 'apiWrongStatusCode',
      desc: '',
      args: [statusCode],
    );
  }

  /// `не удалось распарсить json ({errorMessage})`
  String apiJsonParseError(Object errorMessage) {
    return Intl.message(
      'не удалось распарсить json ($errorMessage)',
      name: 'apiJsonParseError',
      desc: '',
      args: [errorMessage],
    );
  }

  /// `не удалось распарсить ответ ({errorMessage})`
  String apiAnswerParseError(Object errorMessage) {
    return Intl.message(
      'не удалось распарсить ответ ($errorMessage)',
      name: 'apiAnswerParseError',
      desc: '',
      args: [errorMessage],
    );
  }

  /// `API вызов {path} завершился с ошибкой {errorMessage}`
  String apiCallFinishedWithError(Object path, Object errorMessage) {
    return Intl.message(
      'API вызов $path завершился с ошибкой $errorMessage',
      name: 'apiCallFinishedWithError',
      desc: '',
      args: [path, errorMessage],
    );
  }

  /// `API вызов {path} завершился с ошибкой aутентификация`
  String apiAuthError(Object path) {
    return Intl.message(
      'API вызов $path завершился с ошибкой aутентификация',
      name: 'apiAuthError',
      desc: '',
      args: [path],
    );
  }

  /// `загрузка локального справочника заверилось с ошибкой ({errorMessage})`
  String apiLocalReferenceInitError(Object errorMessage) {
    return Intl.message(
      'загрузка локального справочника заверилось с ошибкой ($errorMessage)',
      name: 'apiLocalReferenceInitError',
      desc: '',
      args: [errorMessage],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}