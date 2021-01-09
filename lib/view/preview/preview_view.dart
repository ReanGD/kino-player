import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kino_player/generated/l10n.dart';
import 'package:kino_player/services/content_data.dart';
import 'package:kino_player/view/player/player_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PreviewView extends StatelessWidget {
  final ContentData _contentData;
  final ScrollController _scrollController = ScrollController();

  PreviewView(this._contentData);

  static String _formatDuration(S s, Duration d) {
    final h = d.inHours;
    final m = d.inMinutes;
    final mStr = s.previewMinutes(m);
    if (h < 1) {
      return mStr;
    }

    var modM = (m - h * 60).toString();
    if (modM.length == 1) {
      modM = "0" + modM;
    }
    return "$h:$modM ($mStr)";
  }

  Widget _getView(BuildContext context) {
    final s = S.of(context);
    final screenSize = MediaQuery.of(context).size;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      controller: _scrollController,
      clipBehavior: Clip.antiAlias,
      child: DefaultTextStyle(
        style: TextStyle(
          color: Colors.white,
        ),
        child: Container(
          color: Colors.black,
          child: Column(
            children: [
              ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment(0.0, -0.01),
                    end: Alignment.bottomCenter,
                    colors: [Colors.black, Colors.transparent],
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                blendMode: BlendMode.dstIn,
                child: CachedNetworkImage(
                  imageUrl: _contentData.posterWide,
                  height: screenSize.height * 0.7,
                  width: screenSize.width,
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                  repeat: ImageRepeat.noRepeat,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              OutlinedButton(
                focusNode: FocusNode(),
                onPressed: () {
                  final season = _contentData.seasons[1];
                  print(season);
                  season.items[season.items.keys.first]
                      .getFiles()
                      .then((value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlayerScreen(value)),
                    );
                  });
                  print("film");
                },
                child: Text(s.previewViewFilm),
              ),
              OutlinedButton(
                focusNode: FocusNode(),
                onPressed: () {
                  print("trailer");
                },
                child: Text(s.previewTrailer),
              ),
              Text(_contentData.titleLocal),
              Text(_contentData.plot),
              Table(
                children: [
                  TableRow(children: [
                    Text(s.previewYear),
                    TextButton(
                        onPressed: () => print("year"),
                        child: Text(_contentData.year.toString())),
                  ]),
                  TableRow(children: [
                    Text(s.previewRating),
                    Text(
                        "${_contentData.kinopoiskRating}, ${_contentData.imdbRating}, ${_contentData.kinopubRating}"),
                  ]),
                  TableRow(children: [
                    Text(s.previewCountry),
                    TextButton(
                        onPressed: () => print("country"),
                        child: Text(_contentData.countries.items
                            .map((e) => e.title)
                            .join(","))),
                  ]),
                  TableRow(children: [
                    Text(s.previewGenre),
                    TextButton(
                        onPressed: () => print("genre"),
                        child: Text(
                            _contentData.genres.map((e) => e.title).join(","))),
                  ]),
                  TableRow(children: [
                    Text(s.previewOriginalTitle),
                    Text(_contentData.titleOriginal),
                  ]),
                  TableRow(children: [
                    Text(s.previewDirector),
                    TextButton(
                        onPressed: () => print("director"),
                        child: Text(_contentData.directors.join(", "))),
                  ]),
                  TableRow(children: [
                    Text(s.previewActors),
                    TextButton(
                        onPressed: () => print("actors"),
                        child: Text(_contentData.actors.join(", "))),
                  ]),
                  TableRow(children: [
                    Text(s.previewEpisodeDuration),
                    Text(_formatDuration(s, _contentData.averageDuration)),
                  ]),
                  TableRow(children: [
                    Text(s.previewComments),
                    TextButton(
                        onPressed: () => print("comments"),
                        child: Text(_contentData.numberOfcomments.toString())),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getView(context);
  }
}
