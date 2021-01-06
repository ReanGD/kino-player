import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:better_player/better_player.dart';
import 'package:kino_player/services/video_file_data.dart';
import 'package:kino_player/view/player/control_panel.dart';

class PlayerScreen extends StatefulWidget {
  final VideoFilesData _videoFilesData;

  PlayerScreen(this._videoFilesData);

  @override
  _PlayerScreenState createState() => _PlayerScreenState(_videoFilesData);
}

class _PlayerScreenState extends State<PlayerScreen> {
  final VideoFilesData _videoFilesData;
  BetterPlayerController _playerController;

  _PlayerScreenState(this._videoFilesData);

  @override
  void initState() {
    final controlsCfg = BetterPlayerControlsConfiguration(
      customControls: Container(),
    );

    final playerCfg = BetterPlayerConfiguration(
      // aspectRatio: 21 / 9,
      // fit: BoxFit.fitHeight,
      controlsConfiguration: controlsCfg,
      handleLifecycle: true,
      autoDispose: true,
    );

    final url = _videoFilesData.getWithBestQuality().getUrl("hls4");
    // "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"; // 10 min
    // "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"; // 15 sec
    const sourceType = BetterPlayerDataSourceType.network;
    final source = BetterPlayerDataSource(sourceType, url, headers: {
      HttpHeaders.authorizationHeader:
          _videoFilesData.getWithBestQuality().authHeader,
    });
    _playerController = BetterPlayerController(playerCfg);
    _playerController.setupDataSource(source);
    // _playerController.setVolume(0);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.black,
              child: BetterPlayer(controller: _playerController),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ControlPanel(_playerController),
          ),
        ],
      ),
    );
  }
}
