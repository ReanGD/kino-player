import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kino_player/services/poster_data.dart';
import 'package:kino_player/view/posters/posters_grid.dart';
import 'package:kino_player/view/posters/posters_navbar.dart';
import 'package:kino_player/view/posters/posters_toolbar.dart';

class PostersScreen extends StatelessWidget {
  final _postersParams =
      ValueNotifier<PostersRequestParams>(PostersRequestParams());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PostersToolBar(),
      drawer: PostersNavbar(_postersParams),
      body: PostersGrid(_postersParams),
    );
  }
}
