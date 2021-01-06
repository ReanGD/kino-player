import 'generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kino_player/view/posters/posters_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(
    Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): ActivateIntent(),
      },
      child: MaterialApp(
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        localeResolutionCallback: (locale, supportedLocales) {
          return Locale.fromSubtags(languageCode: 'ru');
        },
        title: 'Kino player',
        theme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: PostersScreen(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
