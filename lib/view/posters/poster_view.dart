import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kino_player/utils/keys.dart';
import 'package:kino_player/utils/assets.dart';
import 'package:kino_player/services/poster_data.dart';
import 'package:kino_player/widgets/platform_icon.dart';
import 'package:kino_player/view/preview/preview_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

const double _kTextHeight = 29.0;
const double _kOriginImageWidth = 165.0;
const double _kOriginImageHeight = 250.0;
const double _kImageBorderRadius = 5.0;
const _kRatingTextStyle = const TextStyle(fontWeight: FontWeight.w300);
const _kImagePadding =
    const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 2);

class PosterView extends StatelessWidget {
  static double calcImageHeight(double width) {
    return _kOriginImageHeight * width / _kOriginImageWidth;
  }

  static double calcAspectRatio(double width) {
    return width / (calcImageHeight(width) + _kTextHeight);
  }

  final bool _isAutofocus;
  final double _itemWidth;
  final PosterData _posterData;

  PosterView(this._isAutofocus, this._itemWidth, this._posterData);

  void _openPreviewScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PreviewScreen(_posterData)),
    );
  }

  Widget _getPlatformRating(double rating) {
    return Text(rating.toStringAsFixed(1), style: _kRatingTextStyle);
  }

  Widget _getView() {
    return Column(
      children: [
        Padding(
          padding: _kImagePadding,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.all(Radius.circular(_kImageBorderRadius)),
            ),
            child: CachedNetworkImage(
              imageUrl: _posterData.posterSmall,
              errorWidget: (context, url, error) => Icon(Icons.error),
              width: _itemWidth - _kImagePadding.horizontal,
              height: calcImageHeight(_itemWidth - _kImagePadding.horizontal),
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        Column(
          children: [
            Text(
              _posterData.titleLocal,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_posterData.year.toString(), style: _kRatingTextStyle),
                PlatformIcon(GraphicsAssets.kinopoiskAsset),
                _getPlatformRating(_posterData.kinopoiskRating),
                PlatformIcon(GraphicsAssets.imdbAsset),
                _getPlatformRating(_posterData.imdbRating),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: _isAutofocus,
      onKey: (FocusNode node, RawKeyEvent event) {
        if (isKeySelectPressed(event)) {
          _openPreviewScreen(context);
          return true;
        }
        return false;
      },
      child: GestureDetector(
        onTap: () => _openPreviewScreen(context),
        child: Builder(
          builder: (BuildContext context) {
            if (Focus.of(context).hasPrimaryFocus) {
              return ColoredBox(
                color: Colors.grey[300],
                child: DefaultTextStyle(
                  style: TextStyle(color: Colors.black87),
                  child: _getView(),
                ),
              );
            }

            return _getView();
          },
        ),
      ),
    );
  }
}
