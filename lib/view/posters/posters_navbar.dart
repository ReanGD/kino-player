import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kino_player/utils/assets.dart';
import 'package:kino_player/generated/l10n.dart';
import 'package:kino_player/services/user_data.dart';
import 'package:kino_player/services/content_type.dart';
import 'package:kino_player/widgets/future_widget.dart';
import 'package:kino_player/services/kino_pub_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kino_player/view/posters/posters_settings.dart';

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
  final PostersSettings _settings;

  PostersNavbar(this._settings);

  Widget _getDefaultAvatar() {
    return Image(
      image: GraphicsAssets.defaultAvatarAsset,
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
          Text(S.of(context).postersNavbarDays(data.proDays)),
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
    final selectedId = _settings.contentTypeId;
    for (var i = 0; i != items.length; ++i) {
      children.add(ListTile(
        autofocus: selectedId.isEmpty ? i == 0 : selectedId == items[i].id,
        leading: Icon(Icons.verified_user),
        title: Text(items[i].title),
        onTap: () {
          _settings.contentTypeId = items[i].id;
          _settings.apply();
          Navigator.of(context).pop();
        },
      ));
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureWidget<_NavBarData>(
        future: () => _NavBarData.asyncLoad(),
        builder: _build,
      ),
    );
  }
}
