import 'dart:async';
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

enum _SeekState {
  active,
  finished,
  playFromStartPosition,
  playFromCurrentPosition,
}

class _ControlPanelState extends VideoController<ControlPanel> {
  // seek
  int _startSeekPosition = 0;
  int _currentSeekPosition = 0;
  _SeekState _seekState = _SeekState.finished;

  _ControlPanelState(playerController) : super(playerController);

  void _startSeekTimer() {
    if (_seekState == _SeekState.finished) {
      return;
    }

    Timer(Duration(milliseconds: 300), () {
      if (_seekState == _SeekState.active) {
        doSeek(_currentSeekPosition, _startSeekTimer);
      } else if (_seekState == _SeekState.playFromStartPosition) {
        _seekState = _SeekState.finished;
        doSeek(_startSeekPosition, doPlay);
      } else if (_seekState == _SeekState.playFromCurrentPosition) {
        _seekState = _SeekState.finished;
        doSeek(_currentSeekPosition, doPlay);
      }
    });
  }

  Widget _getSeekBar() {
    final seekActive = (_seekState != _SeekState.finished);
    final position = seekActive ? _currentSeekPosition : positionInSec;
    final markerPosition = seekActive ? _startSeekPosition : positionInSec;

    return SeekBar(
      max: durationInSec.toDouble(),
      step: 1.0,
      thumbPosition: position.toDouble(),
      markerPosition: markerPosition.toDouble(),
      onPressed: (position) {
        if (_seekState == _SeekState.active) {
          _seekState = _SeekState.playFromCurrentPosition;
        }
      },
      onChanged: (position) {
        _currentSeekPosition = position.toInt();
        if (_seekState == _SeekState.finished) {
          _seekState = _SeekState.active;
          _startSeekPosition = positionInSec;
          doPause();
          _startSeekTimer();
        }
      },
      onChangeEnd: (_) {
        if (_seekState == _SeekState.active) {
          _seekState = _SeekState.playFromStartPosition;
        }
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
