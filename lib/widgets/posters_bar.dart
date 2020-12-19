import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PostersBar extends AppBar {
  PostersBar()
      : super(
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
