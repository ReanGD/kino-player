import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kino_player/services/kino_pub_api.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Poster extends StatelessWidget {
  final VideoMetaData _metaData;
  final bool _isSelected;

  Poster(this._metaData, this._isSelected);

  Widget _getView(BuildContext context) {
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
                fontWeight: _isSelected ? FontWeight.bold : FontWeight.normal),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getView(context);
  }
}
