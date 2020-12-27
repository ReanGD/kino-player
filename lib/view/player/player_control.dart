import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
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

enum _SeekState {
  active,
  finished,
  playFromStartPosition,
  playFromCurrentPosition,
}

class _ControlPanelState extends State<ControlPanel> {
  final BetterPlayerController _playerController;
  bool _isVisible = true;
  var _videoController; // type = VideoPlayerController
  VideoPlayerValue _latestValue;

  // seek
  int _startSeekPosition = 0;
  int _currentSeekPosition = 0;
  _SeekState _seekState = _SeekState.finished;

  _ControlPanelState(this._playerController);

  int _getDurationInSec() {
    return _latestValue != null && _latestValue.duration != null
        ? _latestValue.duration.inSeconds
        : 0;
  }

  int _getPositionInSec() {
    return _latestValue != null && _latestValue.position != null
        ? _latestValue.position.inSeconds
        : 0;
  }

  void _doPlay() {
    if (!_playerController.isPlaying()) {
      _playerController.play().then((_) => setState(() {}));
    }
  }

  void _doPause() {
    if (_playerController.isPlaying()) {
      _playerController.pause().then((_) => setState(() {}));
    }
  }

  void _doPlayPause() {
    if (_playerController.isPlaying()) {
      _playerController.pause().then((_) => setState(() {}));
    } else {
      _playerController.play().then((_) => setState(() {}));
    }
  }

  void _doSeek(int positionInSec, void Function() callback) {
    if (_getPositionInSec() != positionInSec) {
      _playerController
          .seekTo(Duration(seconds: positionInSec))
          .then((_) => callback());
    } else {
      callback();
    }
  }

  void _startSeekTimer() {
    if (_seekState == _SeekState.finished) {
      return;
    }

    Timer(Duration(milliseconds: 300), () {
      if (_seekState == _SeekState.active) {
        _doSeek(_currentSeekPosition, _startSeekTimer);
      } else if (_seekState == _SeekState.playFromStartPosition) {
        _seekState = _SeekState.finished;
        _doSeek(_startSeekPosition, _doPlay);
      } else if (_seekState == _SeekState.playFromCurrentPosition) {
        _seekState = _SeekState.finished;
        _doSeek(_currentSeekPosition, _doPlay);
      }
    });
  }

  Widget _getSeekBar() {
    final seekActive = (_seekState != _SeekState.finished);
    final position = seekActive ? _currentSeekPosition : _getPositionInSec();
    final markerPosition =
        seekActive ? _startSeekPosition : _getPositionInSec();

    return SeekBar(
      max: _getDurationInSec().toDouble(),
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
          _startSeekPosition = _getPositionInSec();
          _doPause();
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
          _playerController.isPlaying() ? Icons.pause : Icons.play_arrow,
          () {
            _doPlayPause();
          },
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
