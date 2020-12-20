import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kino_player/widgets/poster.dart';
import 'package:kino_player/services/poster_data.dart';
import 'package:kino_player/services/fresh_loader.dart';

class PostersGrid extends StatefulWidget {
  @override
  createState() => _PostersGridState();
}

class _PostersGridState extends State<PostersGrid> {
  final _loader = FreshLoader();
  final _posters = <PosterData>[];
  bool _fetchInProgress = false;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() {
    _fetchInProgress = true;
    _loader.getNext().then((List<PosterData> items) {
      setState(() {
        _posters.addAll(items);
        _fetchInProgress = false;
      });
    });
  }

  Widget _posterLoadInProgress() {
    return Center(
      child: SizedBox(
        child: CircularProgressIndicator(),
        height: 24,
        width: 24,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_posters.length == 0) {
      return CircularProgressIndicator();
    }

    return GridView.builder(
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
          return _posterLoadInProgress();
        }

        return Poster(index == 0, _posters[index]);
      },
    );
  }
}
