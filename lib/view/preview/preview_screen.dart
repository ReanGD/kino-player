import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kino_player/generated/l10n.dart';
import 'package:kino_player/services/poster_data.dart';
import 'package:kino_player/services/content_data.dart';
import 'package:kino_player/widgets/loader_indicator.dart';
import 'package:kino_player/view/preview/preview_view.dart';

class PreviewScreen extends StatelessWidget {
  final Future<ContentData> _contentDataFuture;

  PreviewScreen(PosterData posterData)
      : _contentDataFuture = posterData.getContent();

  Widget _buildError(BuildContext context, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(S.of(context).error(error)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ContentData>(
        future: _contentDataFuture,
        builder: (BuildContext context, AsyncSnapshot<ContentData> snapshot) {
          if (snapshot.hasData) {
            return PreviewView(snapshot.data);
          } else if (snapshot.hasError) {
            return _buildError(context, snapshot.error);
          }
          return LoaderIndicator();
        },
      ),
    );
  }
}
