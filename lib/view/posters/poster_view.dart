import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kino_player/utils/keys.dart';
import 'package:kino_player/services/poster_data.dart';
import 'package:kino_player/view/preview/preview_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

const double _kPlatformIconSize = 20.0;

class PosterView extends StatelessWidget {
  final bool _isAutofocus;
  final PosterData _posterData;
  static const _imdbAsset = AssetImage("assets/graphics/imdb.png");
  static const _kinopubAsset = AssetImage("assets/graphics/kinopub.png");
  static const _kinopoiskAsset = AssetImage("assets/graphics/kinopoisk.png");

  PosterView(this._isAutofocus, this._posterData);

  void _openPreviewScreen(BuildContext context) {
    _posterData.getContent().then((contentData) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PreviewScreen(contentData)),
      );
    });
  }

  Widget _getPlatformIcon(AssetImage asset) {
    return Image(
      image: asset,
      width: _kPlatformIconSize,
      height: _kPlatformIconSize,
    );
  }

  Widget _getPlatformRating(double rating) {
    return Text(rating.toStringAsFixed(1));
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_posterData.year.toString()),
            _getPlatformIcon(_kinopoiskAsset),
            _getPlatformRating(_posterData.kinopoiskRating),
            _getPlatformIcon(_imdbAsset),
            _getPlatformRating(_posterData.imdbRating),
            _getPlatformIcon(_kinopubAsset),
            _getPlatformRating(_posterData.kinopubRating),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            _posterData.titleLocal,
            style: TextStyle(
                fontWeight: focused ? FontWeight.bold : FontWeight.normal),
          ),
        ),
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
