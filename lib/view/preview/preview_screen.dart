import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kino_player/services/poster_data.dart';
import 'package:kino_player/services/content_data.dart';
import 'package:kino_player/widgets/future_widget.dart';
import 'package:kino_player/view/preview/preview_view.dart';

class PreviewScreen extends StatelessWidget {
  final PosterData _posterData;

  PreviewScreen(this._posterData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureWidget<ContentData>(
        future: () => _posterData.getContent(),
        builder: (context, data) => PreviewView(data),
      ),
    );
  }
}
