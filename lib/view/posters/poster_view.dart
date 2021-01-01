import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kino_player/utils/keys.dart';
import 'package:kino_player/services/poster_data.dart';
import 'package:kino_player/view/preview/preview_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PosterView extends StatelessWidget {
  final bool _isAutofocus;
  final PosterData _posterData;

  PosterView(this._isAutofocus, this._posterData);

  void _openPreviewScreen(BuildContext context) {
    _posterData.getContent().then((contentData) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PreviewScreen(contentData)),
      );
    });
  }

  Widget _getView(bool focused) {
    return Column(
      children: <Widget>[
        Expanded(
          child: CachedNetworkImage(
            imageUrl: _posterData.posterSmall,
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Text(
            _posterData.titleLocal,
            style: TextStyle(
                fontWeight: focused ? FontWeight.bold : FontWeight.normal),
          ),
        )
      ],
    );
  }

  Widget _getFocusedView(BuildContext context) {
    return Focus(
      autofocus: _isAutofocus,
      onKey: (FocusNode node, RawKeyEvent event) {
        if (isKeySelectPressed(event)) {
          _openPreviewScreen(context);
          return true;
        }

        return false;
      },
      child: Builder(
        builder: (BuildContext context) {
          return _getView(Focus.of(context).hasPrimaryFocus);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _openPreviewScreen(context);
      },
      child: _getFocusedView(context),
    );
  }
}
