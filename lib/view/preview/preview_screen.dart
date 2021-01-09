import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kino_player/widgets/load_error.dart';
import 'package:kino_player/services/poster_data.dart';
import 'package:kino_player/services/content_data.dart';
import 'package:kino_player/widgets/loader_indicator.dart';
import 'package:kino_player/view/preview/preview_view.dart';

class PreviewScreen extends StatelessWidget {
  final Future<ContentData> _contentDataFuture;

  PreviewScreen(PosterData posterData)
      : _contentDataFuture = posterData.getContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ContentData>(
        future: _contentDataFuture,
        builder: (BuildContext context, AsyncSnapshot<ContentData> snapshot) {
          if (snapshot.hasData) {
            return PreviewView(snapshot.data);
          } else if (snapshot.hasError) {
            return LoadError(snapshot.error);
          }
          return LoaderIndicator();
        },
      ),
    );
  }
}
