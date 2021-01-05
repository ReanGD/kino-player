import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

const double _kToolbarHeight = 56.0;

class PostersToolBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(_kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.menu),
        tooltip: 'Navigation menu',
        onPressed: () => Scaffold.of(context).openDrawer(),
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
}
