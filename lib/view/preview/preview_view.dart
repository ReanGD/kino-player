import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kino_player/utils/assets.dart';
import 'package:kino_player/generated/l10n.dart';
import 'package:kino_player/services/content_data.dart';
import 'package:kino_player/widgets/platform_icon.dart';
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

  Widget _getImage(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
          begin: Alignment.topCenter,
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
    );
  }

  Widget _getStartButtons(BuildContext context) {
    final s = S.of(context);

    final borderSide = BorderSide(
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
      width: 2,
    );
    final padding = ButtonTheme.of(context).padding.add(EdgeInsets.all(10));

    List<Widget> buttons = [
      OutlineButton(
        autofocus: true,
        padding: padding,
        borderSide: borderSide,
        onPressed: () {
          final season = _contentData.seasons[1];
          season.items[season.items.keys.first].getFiles().then((value) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlayerScreen(value)),
            );
          });
        },
        child: Text(
          s.previewViewFilm,
          style: const TextStyle(fontSize: 17.0),
        ),
      ),
    ];

    if (_contentData.trailer != null) {
      buttons.add(
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: OutlineButton(
            padding: padding,
            borderSide: borderSide,
            onPressed: () {
              print("trailer");
            },
            child: Text(
              s.previewTrailer,
              style: const TextStyle(fontSize: 17.0),
            ),
          ),
        ),
      );
    }

    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: buttons,
      ),
    );
  }

  Widget _getHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 10, left: 15),
      child: Text(
        _contentData.titleLocal,
        style: Theme.of(context)
            .textTheme
            .headline6
            .copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _getPlatformRating(BuildContext context, double rating, int votes) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(rating.toStringAsFixed(1)),
        Text("/$votes", style: Theme.of(context).textTheme.caption),
      ],
    );
  }

  Widget _getRaitingView(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PlatformIcon(GraphicsAssets.kinopoiskAsset),
        _getPlatformRating(
            context, _contentData.kinopoiskRating, _contentData.kinopoiskVotes),
        PlatformIcon(GraphicsAssets.imdbAsset),
        _getPlatformRating(
            context, _contentData.imdbRating, _contentData.imdbVotes),
        PlatformIcon(GraphicsAssets.kinopubAsset),
        _getPlatformRating(
            context, _contentData.kinopubRating, _contentData.kinopubVotes),
      ],
    );
  }

  Widget _getView(BuildContext context) {
    final s = S.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      controller: _scrollController,
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              _getImage(context),
              _getStartButtons(context),
            ],
          ),
          _getHeader(context),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Text(_contentData.plot),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(children: [
                  Text(s.previewYear),
                  TextButton(
                      onPressed: () => print("year"),
                      child: Text(_contentData.year.toString())),
                ]),
                TableRow(children: [
                  Text(s.previewRating),
                  _getRaitingView(context),
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
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getView(context);
  }
}
