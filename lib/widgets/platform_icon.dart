import 'package:flutter/widgets.dart';

class PlatformIcon extends StatelessWidget {
  final AssetImage _asset;
  final double iconSize;
  final double horizontalPadding;

  const PlatformIcon(
    this._asset, {
    this.iconSize = 19.0,
    this.horizontalPadding = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
      ),
      child: Image(
        image: _asset,
        width: iconSize,
        height: iconSize,
      ),
    );
  }
}
