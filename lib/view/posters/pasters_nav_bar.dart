import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kino_player/services/content_type.dart';
import 'package:kino_player/services/kino_pub_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NavBar extends StatelessWidget {
  Widget _getHeader() {
    return DrawerHeader(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CachedNetworkImage(
            imageUrl: "https://gravatar.com/avatar/adasd2fr3495igjfiug",
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Text(
            'User name',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.green,
      ),
    );
  }

  Widget _buildNavMenu(BuildContext context, ContentTypesData data) {
    List<Widget> children = [_getHeader()];
    data.items.forEach((element) {
      children.add(ListTile(
        leading: Icon(Icons.verified_user),
        title: Text(element.title),
        onTap: () => {Navigator.of(context).pop()},
      ));
    });

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

  Widget _buildProgressWidget() {
    return Center(
      child: SizedBox(
        child: CircularProgressIndicator(),
        width: 60,
        height: 60,
      ),
    );
  }

  Widget _builder(
    BuildContext context,
    AsyncSnapshot<ContentTypesData> snapshot,
  ) {
    if (snapshot.hasData) {
      return _buildNavMenu(context, snapshot.data);
    } else if (snapshot.hasError) {
      return _buildErrorMessage(snapshot.error);
    }
    return _buildProgressWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<ContentTypesData>(
        future: KinoPubService.getContentTypes(),
        builder: _builder,
      ),
    );
  }
}
