import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kino_player/utils/keys.dart';
import 'package:kino_player/utils/assets.dart';
import 'package:kino_player/services/poster_data.dart';
import 'package:kino_player/view/preview/preview_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

const double _kTextHeight = 29.0;
const double _kOriginImageWidth = 165.0;
const double _kOriginImageHeight = 250.0;
const double _kPlatformIconSize = 19.0;
const double _kImageBorderRadius = 5.0;
const kImagePadding =
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

  Widget _getPlatformIcon(AssetImage asset) {
    return Padding(
      padding: EdgeInsets.only(
        left: 5,
        right: 5,
      ),
      child: Image(
        image: asset,
        width: _kPlatformIconSize,
        height: _kPlatformIconSize,
      ),
    );
  }

  Widget _getPlatformRating(double rating) {
    return Text(rating.toStringAsFixed(1),
        style: const TextStyle(fontWeight: FontWeight.w300));
  }

  Widget _getView() {
    return Column(
      children: [
        Padding(
          padding: kImagePadding,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.all(Radius.circular(_kImageBorderRadius)),
            ),
            child: CachedNetworkImage(
              imageUrl: _posterData.posterSmall,
              errorWidget: (context, url, error) => Icon(Icons.error),
              width: _itemWidth - kImagePadding.horizontal,
              height: calcImageHeight(_itemWidth - kImagePadding.horizontal),
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
                Text(_posterData.year.toString(),
                    style: const TextStyle(fontWeight: FontWeight.w300)),
                _getPlatformIcon(GraphicsAssets.kinopoiskAsset),
                _getPlatformRating(_posterData.kinopoiskRating),
                _getPlatformIcon(GraphicsAssets.imdbAsset),
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
    return _getView();
  }
}
