import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kino_player/view/posters/posters_grid.dart';

class PostersScreen extends StatelessWidget {
  AppBar _getBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.menu),
        tooltip: 'Navigation menu',
        onPressed: null,
      ),
      title: Text('Kino player'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          tooltip: 'Search',
          onPressed: null,
        ),
        IconButton(
          icon: Icon(Icons.sort),
          tooltip: 'Sort',
          onPressed: null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getBar(),
      body: PostersGrid(),
    );
  }
}
