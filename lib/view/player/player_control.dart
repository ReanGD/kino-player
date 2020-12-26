import 'package:better_player/better_player.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kino_player/widgets/seek_bar.dart';

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

class _ControlPanelState extends State<ControlPanel> {
  final BetterPlayerController _playerController;
  bool _actionInProgress = false;
  bool _isVisible = true;
  var _videoController; // type = VideoPlayerController
  VideoPlayerValue _latestValue;

  _ControlPanelState(this._playerController);

  Widget _getSeekBar() {
    final position = _latestValue != null && _latestValue.position != null
        ? _latestValue.position
        : Duration.zero;
    final duration = _latestValue != null && _latestValue.duration != null
        ? _latestValue.duration
        : Duration.zero;

    return SeekBar(
      max: duration.inSeconds.toDouble(),
      value: position.inSeconds.toDouble(),
      onChanged: (value) {
        // TODO: seek to value
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
          autofocus: true,
        ),
        ControlButton(
          _playerController.isPlaying() ? Icons.pause : Icons.play_arrow,
          () {
            if (_actionInProgress) {
              return;
            }
            _actionInProgress = true;
            Future<void> action = _playerController.isPlaying()
                ? _playerController.pause()
                : _playerController.play();

            action.then((value) {
              setState(() {
                _actionInProgress = false;
              });
            });
          },
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

  void _updateState() {
    if (mounted) {
      if (_isVisible) {
        setState(() {
          _latestValue = _videoController.value;
        });
      }
    }
  }

  @override
  void initState() {
    _videoController = _playerController.videoPlayerController;
    _latestValue = _videoController.value;
    _videoController.addListener(_updateState);
    _updateState();
    super.initState();
  }

  @override
  void dispose() {
    _videoController?.removeListener(_updateState);
    super.dispose();
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
