import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kino_player/view/player/player_screen.dart';
import 'package:kino_player/view/posters/posters_screen.dart';

void main() {
  runApp(
    Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): ActivateIntent(),
      },
      child: MaterialApp(
        title: 'Kino player',
        theme: ThemeData(
          focusColor: Colors.yellow[500],
          splashColor: Colors.white70,
          primarySwatch: Colors.blue,
        ),
        home: PlayerScreen(),
        // home: PostersScreen(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
