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
  final FreshLoader _loader = FreshLoader();

  @override
  void initState() {
    super.initState();
  }

  List<Container> _buildPostersList(List<PosterData> items) {
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
    return FutureBuilder<List<PosterData>>(
      future: _loader.getFirst(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final items = _buildPostersList(snapshot.data);
          return _buildPostersGrid(items);
        }

        if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return CircularProgressIndicator();
      },
    );
  }
}
