import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kino_player/services/poster_data.dart';
import 'package:kino_player/services/poster_fetcher.dart';
import 'package:kino_player/view/posters/poster_view.dart';
import 'package:kino_player/widgets/loader_indicator.dart';
import 'package:kino_player/services/kino_pub_service.dart';

class PostersGrid extends StatefulWidget {
  @override
  createState() => _PostersGridState();
}

class _PostersGridState extends State<PostersGrid> {
  final PosterFetcher _fetcher = KinoPubService.getFresh("serial");
  final _posters = <PosterData>[];
  bool _fetchInProgress = false;

  @override
  void initState() {
    _fetch();
    super.initState();
  }

  void _fetch() {
    _fetchInProgress = true;
    _fetcher.getNext().then((List<PosterData> items) {
      setState(() {
        _posters.addAll(items);
        _fetchInProgress = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_posters.length == 0) {
      return LoaderIndicator();
    }

    return GridView.builder(
      itemCount: _fetcher.total,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
      ),
      itemBuilder: (BuildContext context, int index) {
        if (index >= _posters.length) {
          if (!_fetchInProgress) {
            _fetch();
          }
          return LoaderIndicator();
        }

        return PosterView(index == 0, _posters[index]);
      },
    );
  }
}
