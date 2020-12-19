import 'package:flutter/widgets.dart';
import 'package:kino_player/widgets/poster.dart';
import 'package:kino_player/services/kino_pub_api.dart';

class PostersGrid extends StatefulWidget {
  final List<VideoMetaData> _videosMetaData;

  PostersGrid(this._videosMetaData);

  @override
  createState() => _PostersGridState(_videosMetaData);
}

class _PostersGridState extends State<PostersGrid> {
  final List<VideoMetaData> _videosMetaData;

  _PostersGridState(this._videosMetaData);

  @override
  void initState() {
    super.initState();
  }

  List<Container> _buildPostersList(List<VideoMetaData> items) {
    return List<Container>.generate(
      items.length,
      (int index) => Container(
        child: Poster(index == 0, items[index]),
      ),
    );
  }

  GridView _buildPostersGrid(List<Container> items) {
    return GridView.extent(
      maxCrossAxisExtent: 300,
      padding: const EdgeInsets.all(4),
      mainAxisSpacing: 0,
      crossAxisSpacing: 0,
      children: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _buildPostersList(_videosMetaData);
    return _buildPostersGrid(items);
  }
}
