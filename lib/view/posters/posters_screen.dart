import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kino_player/view/posters/posters_grid.dart';
import 'package:kino_player/view/posters/posters_navbar.dart';
import 'package:kino_player/view/posters/posters_toolbar.dart';
import 'package:kino_player/view/posters/posters_settings.dart';

class PostersScreen extends StatelessWidget {
  final _settings = PostersSettings();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PostersToolBar(_settings),
      drawer: PostersNavbar(_settings),
      body: PostersGrid(_settings),
    );
  }
}
