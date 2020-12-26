import 'package:flutter/widgets.dart';
import 'package:better_player/better_player.dart';

abstract class VideoController<T extends StatefulWidget> extends State<T> {
  final BetterPlayerController _playerController;
  var _controller; // type = VideoPlayerController
  bool _isVisible = true;

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

  void doSeek(int position, VoidCallback fn) {
    if (positionInSec != position) {
      _playerController.seekTo(Duration(seconds: position)).then((_) => fn());
    } else {
      fn();
    }
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
