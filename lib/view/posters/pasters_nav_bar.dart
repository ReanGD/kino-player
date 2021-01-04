import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kino_player/services/user_data.dart';
import 'package:kino_player/services/content_type.dart';
import 'package:kino_player/widgets/loader_indicator.dart';
import 'package:kino_player/services/kino_pub_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

const double _kDrawerHeaderHeight = 100.0;

class NavBar extends StatelessWidget {
  final _defaultUserAvatar = AssetImage("assets/graphics/anonymous.png");

  Widget _getDefaultAvatar() {
    return Image(
      image: _defaultUserAvatar,
      width: 60,
      fit: BoxFit.contain,
    );
  }

  Widget _getUserAvatar(AsyncSnapshot<UserData> snapshot) {
    if ((snapshot.hasData) && (snapshot.data.avatar != null)) {
      return CachedNetworkImage(
        imageUrl: snapshot.data.avatar,
        errorWidget: (context, url, error) => _getDefaultAvatar(),
        width: 60,
        fit: BoxFit.contain,
      );
    }

    return _getDefaultAvatar();
  }

  Widget _getUserInfo(BuildContext context, AsyncSnapshot<UserData> snapshot) {
    final days =
        snapshot.hasData ? snapshot.data.proDays.toString() : "Unknown";
    final TextTheme theme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            snapshot.hasData ? snapshot.data.username : "Unknown",
            style: theme.headline6,
          ),
          Text(
            "дней: $days",
          ),
        ],
      ),
    );
  }

  Widget _getHeader(BuildContext context) {
    return SizedBox(
      height: _kDrawerHeaderHeight,
      child: DrawerHeader(
        padding: const EdgeInsets.only(left: 16.0),
        margin: EdgeInsets.zero,
        child: FutureBuilder<UserData>(
          future: KinoPubService.getUser(),
          builder: (BuildContext context, AsyncSnapshot<UserData> snapshot) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _getUserAvatar(snapshot),
                _getUserInfo(context, snapshot),
              ],
            );
          },
        ),
        decoration: BoxDecoration(
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _buildNavMenu(BuildContext context, ContentTypesData data) {
    List<Widget> children = [_getHeader(context)];
    for (var i = 0; i != data.items.length; ++i) {
      children.add(ListTile(
        autofocus: i == 0,
        leading: Icon(Icons.verified_user),
        title: Text(data.items[i].title),
        onTap: () => {Navigator.of(context).pop()},
      ));
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: children,
    );
  }

  Widget _buildErrorMessage(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text('Error: $error'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<ContentTypesData>(
        future: KinoPubService.getContentTypes(),
        builder: (
          BuildContext context,
          AsyncSnapshot<ContentTypesData> snapshot,
        ) {
          if (snapshot.hasData) {
            return _buildNavMenu(context, snapshot.data);
          } else if (snapshot.hasError) {
            return _buildErrorMessage(snapshot.error);
          }
          return LoaderIndicator();
        },
      ),
    );
  }
}
