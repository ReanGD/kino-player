import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kino_player/services/poster_data.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Poster extends StatelessWidget {
  final bool _isAutofocus;
  final PosterData _metaData;

  Poster(this._isAutofocus, this._metaData);

  bool _isKeySelectPressed(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.select) {
        return true;
      }
    } else if (event is RawKeyUpEvent) {
      // xiaomi + samsung remote
      if ((event.logicalKey == LogicalKeyboardKey.select) &&
          (event.physicalKey.usbHidUsage == 0x000700e4)) {
        return true;
      }
    }

    return false;
  }

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
    if (_isKeySelectPressed(event)) {
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
