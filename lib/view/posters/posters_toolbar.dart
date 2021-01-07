import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kino_player/services/kino_pub_service.dart';
import 'package:kino_player/view/posters/posters_settings.dart';

const double _kToolbarHeight = 56.0;

class _PostersSortField extends StatefulWidget {
  final PostersSettings _settings;

  _PostersSortField(this._settings) : super();

  @override
  createState() => _PostersSortFieldState();
}

class _PostersSortFieldState extends State<_PostersSortField> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget._settings.sortFirst,
      icon: Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: Icon(Icons.sort),
      ),
      underline: const SizedBox.shrink(),
      onChanged: (String key) {
        setState(() {
          widget._settings.sortFirst = key;
          widget._settings.apply();
        });
      },
      items: KinoPubService.getPosterSortFields()
          .items
          .map((item) => DropdownMenuItem<String>(
                value: "-" + item.id,
                child: Text(item.title),
              ))
          .toList(),
    );
  }
}

class PostersToolBar extends StatelessWidget implements PreferredSizeWidget {
  final PostersSettings _settings;

  PostersToolBar(this._settings) : super();

  @override
  Size get preferredSize => Size.fromHeight(_kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      title: _PostersSortField(_settings),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: null,
        ),
      ],
    );
  }
}
