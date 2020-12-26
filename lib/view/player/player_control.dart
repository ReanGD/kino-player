import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:better_player/better_player.dart';
import 'package:kino_player/widgets/seek_bar.dart';
import 'package:kino_player/view/player/video_controller.dart';

class ControlButton extends StatelessWidget {
  const ControlButton(this._icon, this._onPressed, {this.autofocus = false});

  final IconData _icon;
  final VoidCallback _onPressed;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints(minWidth: 35, minHeight: 35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      onPressed: _onPressed,
      autofocus: autofocus,
      child: Builder(
        builder: (BuildContext context) {
          return Icon(_icon,
              color: Focus.of(context).hasPrimaryFocus
                  ? Colors.black87
                  : Colors.white70);
        },
      ),
    );
  }
}

class ControlPanel extends StatefulWidget {
  final BetterPlayerController _playerController;

  ControlPanel(this._playerController);

  @override
  _ControlPanelState createState() => _ControlPanelState(_playerController);
}

class _ControlPanelState extends VideoController<ControlPanel> {
  _ControlPanelState(playerController) : super(playerController);

  Widget _getSeekBar() {
    return SeekBar(
      max: durationInSec.toDouble(),
      step: 1.0,
      thumbPosition: thumbPositionInSec.toDouble(),
      markerPosition: markerPositionInSec.toDouble(),
      onPressed: (_) {
        finishSeek();
      },
      onChanged: (position) {
        startSeek(position.toInt());
      },
      onChangeEnd: (_) {
        cancelSeek();
      },
    );
  }

  Widget _getControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ControlButton(
          Icons.replay_30,
          () {},
        ),
        ControlButton(
          isPlaying ? Icons.pause : Icons.play_arrow,
          doPlayPause,
          autofocus: true,
        ),
        ControlButton(
          Icons.stop,
          () {},
        ),
        ControlButton(
          Icons.forward_30,
          () {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withAlpha(190),
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          _getSeekBar(),
          _getControlButtons(),
        ],
      ),
    );
  }
}
