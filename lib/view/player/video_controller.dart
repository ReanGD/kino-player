import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:better_player/better_player.dart';

enum _SeekState {
  active,
  finished,
  playFromStartPosition,
  playFromCurrentPosition,
}

abstract class VideoController<T extends StatefulWidget> extends State<T> {
  final BetterPlayerController _playerController;
  var _controller; // type = VideoPlayerController
  bool _isVisible = true;

  // seek state
  int _startSeekPosition = 0;
  int _currentSeekPosition = 0;
  _SeekState _seekState = _SeekState.finished;

  VideoController(this._playerController)
      : _controller = _playerController.videoPlayerController,
        super();

  bool get isPlaying => _controller.value.isPlaying;

  int get durationInSec => _controller.value.duration != null
      ? _controller.value.duration.inSeconds
      : 0;

  int get positionInSec => _controller.value.position != null
      ? _controller.value.position.inSeconds
      : 0;

  int get thumbPositionInSec =>
      _seekState == _SeekState.finished ? positionInSec : _currentSeekPosition;

  int get markerPositionInSec =>
      _seekState == _SeekState.finished ? positionInSec : _startSeekPosition;

  void doPlay() {
    if (!isPlaying) {
      _playerController.play().then((_) => _setStateRun());
    }
  }

  void doPause() {
    if (isPlaying) {
      _playerController.pause().then((_) => _setStateRun());
    }
  }

  void doPlayPause() {
    if (isPlaying) {
      _playerController.pause().then((_) => _setStateRun());
    } else {
      _playerController.play().then((_) => _setStateRun());
    }
  }

  void doSeek(int deltaInSec) {
    _playerController
        .seekTo(Duration(seconds: positionInSec + deltaInSec))
        .then((_) => _setStateRun());
  }

  void startSeek(int position) {
    _currentSeekPosition = position;
    if (_seekState == _SeekState.finished) {
      _seekState = _SeekState.active;
      _startSeekPosition = positionInSec;
      doPause();
      _startSeekTimer();
    }
  }

  void finishSeek() {
    if (_seekState == _SeekState.active) {
      _seekState = _SeekState.playFromCurrentPosition;
    }
  }

  void cancelSeek() {
    if (_seekState == _SeekState.active) {
      _seekState = _SeekState.playFromStartPosition;
    }
  }

  void _doSeekWithCallback(int position, VoidCallback fn) {
    if (positionInSec != position) {
      _playerController.seekTo(Duration(seconds: position)).then((_) => fn());
    } else {
      fn();
    }
  }

  void _startSeekTimer() {
    if (_seekState == _SeekState.finished) {
      return;
    }

    Timer(Duration(milliseconds: 300), () {
      if (_seekState == _SeekState.active) {
        _doSeekWithCallback(_currentSeekPosition, _startSeekTimer);
      } else if (_seekState == _SeekState.playFromStartPosition) {
        _seekState = _SeekState.finished;
        _doSeekWithCallback(_startSeekPosition, doPlay);
      } else if (_seekState == _SeekState.playFromCurrentPosition) {
        _seekState = _SeekState.finished;
        _doSeekWithCallback(_currentSeekPosition, doPlay);
      }
    });
  }

  void _updateState() {
    if (mounted) {
      if (_isVisible) {
        _setStateRun();
      }
    }
  }

  void _setStateRun() {
    setState(() {});
  }

  @override
  void initState() {
    _controller.addListener(_updateState);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_updateState);
    super.dispose();
  }
}
