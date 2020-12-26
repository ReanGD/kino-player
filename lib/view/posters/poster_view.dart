import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kino_player/utils/keys.dart';
import 'package:kino_player/services/poster_data.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PosterView extends StatelessWidget {
  final bool _isAutofocus;
  final PosterData _metaData;

  PosterView(this._isAutofocus, this._metaData);

  Widget _getView(bool focused) {
    return Column(
      children: <Widget>[
        Expanded(
          child: CachedNetworkImage(
            imageUrl: _metaData.poster,
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Text(
            _metaData.title,
            style: TextStyle(
                fontWeight: focused ? FontWeight.bold : FontWeight.normal),
          ),
        )
      ],
    );
  }

  bool _keyHandler(FocusNode node, RawKeyEvent event) {
    if (isKeySelectPressed(event)) {
      print("Key select");
      return true;
    }

    return false;
  }

  Widget _getFocusedView() {
    return Focus(
      autofocus: _isAutofocus,
      onKey: _keyHandler,
      child: Builder(
        builder: (BuildContext context) {
          return _getView(Focus.of(context).hasPrimaryFocus);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getFocusedView();
  }
}
