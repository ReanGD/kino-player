import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kino_player/utils/keys.dart';
import 'package:kino_player/services/poster_data.dart';
import 'package:kino_player/view/preview/preview_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

const double _kTextHeight = 50.0;
const double _kOriginImageWidth = 165.0;
const double _kOriginImageHeight = 250.0;

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

  Widget _getView() {
    return Container(
      width: _itemWidth,
      height: calcImageHeight(_itemWidth) + _kTextHeight,
      color: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getView();
  }
}
