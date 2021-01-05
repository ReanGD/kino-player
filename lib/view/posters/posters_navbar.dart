import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kino_player/services/user_data.dart';
import 'package:kino_player/services/poster_data.dart';
import 'package:kino_player/services/content_type.dart';
import 'package:kino_player/widgets/loader_indicator.dart';
import 'package:kino_player/services/kino_pub_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class _NavBarData {
  final UserData userData;
  final ContentTypesData contentType;

  _NavBarData(this.userData, this.contentType);

  static Future<_NavBarData> asyncLoad() async {
    final userData = KinoPubService.getUser();
    final contentType = KinoPubService.getContentTypes();
    return _NavBarData(await userData, await contentType);
  }
}

class PostersNavbar extends StatelessWidget {
  final Future<_NavBarData> _data;
  final ValueNotifier<PostersRequestParams> _notifier;
  static const _defaultAvatarImage =
      AssetImage("assets/graphics/anonymous.png");

  PostersNavbar(this._notifier) : _data = _NavBarData.asyncLoad();

  Widget _getDefaultAvatar() {
    return Image(
      image: _defaultAvatarImage,
      width: 60,
      fit: BoxFit.contain,
    );
  }

  Widget _getUserAvatar(UserData data) {
    if (data.avatar != null) {
      return CachedNetworkImage(
        imageUrl: data.avatar,
        errorWidget: (context, url, error) => _getDefaultAvatar(),
        width: 60,
        fit: BoxFit.contain,
      );
    }

    return _getDefaultAvatar();
  }

  Widget _getUserInfo(BuildContext context, UserData data) {
    final TextTheme theme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data.username, style: theme.headline6),
          Text("дней: ${data.proDays}"),
        ],
      ),
    );
  }

  Widget _getHeader(BuildContext context, UserData data) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _getUserAvatar(data),
          _getUserInfo(context, data),
        ],
      ),
    );
  }

  Widget _build(BuildContext context, _NavBarData data) {
    List<Widget> children = [_getHeader(context, data.userData), Divider()];
    final items = data.contentType.items;
    for (var i = 0; i != items.length; ++i) {
      children.add(ListTile(
        autofocus: i == 0,
        leading: Icon(Icons.verified_user),
        title: Text(items[i].title),
        onTap: () {
          var value = _notifier.value;
          value.contentTypeId = items[i].id;
          _notifier.value = value;
          Navigator.of(context).pop();
        },
      ));
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: children,
    );
  }

  Widget _buildError(Object error) {
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
      child: FutureBuilder<_NavBarData>(
        future: _data,
        builder: (BuildContext context, AsyncSnapshot<_NavBarData> snapshot) {
          if (snapshot.hasData) {
            return _build(context, snapshot.data);
          } else if (snapshot.hasError) {
            return _buildError(snapshot.error);
          }
          return LoaderIndicator();
        },
      ),
    );
  }
}
