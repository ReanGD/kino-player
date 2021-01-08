import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kino_player/services/poster_data.dart';
import 'package:kino_player/services/poster_fetcher.dart';
import 'package:kino_player/view/posters/poster_view.dart';
import 'package:kino_player/widgets/loader_indicator.dart';
import 'package:kino_player/services/kino_pub_service.dart';
import 'package:kino_player/view/posters/posters_settings.dart';

const _kMaxItemWidth = 180.0;

class _GridOrderPolicy extends OrderedTraversalPolicy {
  final VoidCallback _driwerOpener;

  _GridOrderPolicy(this._driwerOpener) : super();

  @override
  bool inDirection(FocusNode currentNode, TraversalDirection direction) {
    bool result = super.inDirection(currentNode, direction);
    if ((direction == TraversalDirection.left) && !result) {
      _driwerOpener();
    }

    return result;
  }
}

class PostersGrid extends StatefulWidget {
  final PostersSettings _settings;

  PostersGrid(this._settings);

  @override
  createState() => _PostersGridState();
}

class _PostersGridState extends State<PostersGrid> {
  PosterFetcher _fetcher;
  final _posters = <PosterData>[];
  bool _fetchInProgress = false;

  @override
  void initState() {
    super.initState();
    _fetcher = KinoPubService.getPosters(widget._settings.requestParams);
    _fetch();
    widget._settings.addListener(_postersParamsUpdated);
  }

  @override
  void dispose() {
    widget._settings.removeListener(_postersParamsUpdated);
    super.dispose();
  }

  void _postersParamsUpdated() {
    setState(() {
      _fetcher = KinoPubService.getPosters(widget._settings.requestParams);
      _posters.clear();
      _fetch();
    });
  }

  void _fetch() {
    _fetchInProgress = true;
    // TODO: add process error
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

    final widgetWidth = (context.findRenderObject() as RenderBox).size.width;
    final itemsCount = (widgetWidth / _kMaxItemWidth).ceil();
    final itemWidth = widgetWidth / itemsCount;

    return FocusTraversalGroup(
      policy: _GridOrderPolicy(() => Scaffold.of(context).openDrawer()),
      child: GridView.builder(
        itemCount: _fetcher.total,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: itemWidth,
          childAspectRatio: PosterView.calcAspectRatio(itemWidth),
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

          return PosterView(index == 0, itemWidth, _posters[index]);
        },
      ),
    );
  }
}
