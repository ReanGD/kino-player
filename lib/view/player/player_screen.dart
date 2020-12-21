import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';

class PlayerScreen extends StatefulWidget {
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  BetterPlayerController _controller;

  @override
  void initState() {
    final controlsCfg = BetterPlayerControlsConfiguration(
      customControls: Container(),
    );

    final playerCfg = BetterPlayerConfiguration(
      aspectRatio: 21 / 9,
      fit: BoxFit.fitHeight,
      controlsConfiguration: controlsCfg,
    );

    const url =
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4";
    const sourceType = BetterPlayerDataSourceType.network;
    final source = BetterPlayerDataSource(sourceType, url);
    _controller = BetterPlayerController(playerCfg);
    _controller.setupDataSource(source);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Player"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Normal player with configuration managed by developer.",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Stack(
            children: <Widget>[
              Expanded(
                child: BetterPlayer(controller: _controller),
              ),
              Container(
                width: 90,
                height: 90,
                color: Colors.green,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
          )
        ],
      ),
    );
  }
}
