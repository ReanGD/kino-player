import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kino_player/generated/l10n.dart';
import 'package:kino_player/services/content_data.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PreviewScreen extends StatelessWidget {
  final ContentData _contentData;
  final ScrollController _scrollController = ScrollController();

  PreviewScreen(this._contentData);

  static String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes;
    if (h < 1) {
      return "$m мин";
    }

    var modM = (m - h * 60).toString();
    if (modM.length == 1) {
      modM = "0" + modM;
    }
    return "$h:$modM ($m мин)";
  }

  Widget _getView(BuildContext context) {
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
              Text(_contentData.titleLocal),
              Text(_contentData.plot),
              Table(
                children: [
                  // TODO: Text(S.of(context).NameOfFilm),
                  TableRow(children: [
                    Text("Год"),
                    Text(_contentData.year.toString()),
                  ]),
                  TableRow(children: [
                    Text("Рейтинг"),
                    Text(
                        "${_contentData.kinopoiskRating}, ${_contentData.imdbRating}, ${_contentData.kinopubRating}"),
                  ]),
                  TableRow(children: [
                    Text("Страна"),
                    Text(_contentData.countries.items
                        .map((e) => e.title)
                        .join(",")),
                  ]),
                  TableRow(children: [
                    Text("Жанр"),
                    Text(_contentData.genres.items
                        .map((e) => e.title)
                        .join(",")),
                  ]),
                  TableRow(children: [
                    Text("Оригинальное название"),
                    Text(_contentData.titleOriginal),
                  ]),
                  TableRow(children: [
                    Text("Режисер"),
                    Text(_contentData.directors.join(", ")),
                  ]),
                  TableRow(children: [
                    Text("В ролях"),
                    Text(_contentData.actors.join(", ")),
                  ]),
                  TableRow(children: [
                    Text("Время"),
                    Text(_formatDuration(_contentData.averageDuration)),
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Focus(
        onKey: (FocusNode node, RawKeyEvent event) {
          double step = 100.0;
          if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
            step = -step;
          } else if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
            // pass
          } else {
            return false;
          }
          _scrollController.animateTo(
            _scrollController.offset + step,
            duration: Duration(milliseconds: 500),
            curve: Curves.ease,
          );
          return true;
        },
        child: _getView(context),
      ),
    );
  }
}
