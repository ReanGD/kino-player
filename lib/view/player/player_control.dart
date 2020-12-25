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
  final BetterPlayerController _controller;

  ControlPanel(this._controller);

  @override
  _ControlPanelState createState() => _ControlPanelState(_controller);
}

class _ControlPanelState extends State<ControlPanel> {
  double _position = 0.0;
  bool _actionInProgress = false;
  final BetterPlayerController _controller;

  _ControlPanelState(this._controller);

  Widget _getSeekBar() {
    return SeekBar(
      value: _position,
      onChanged: (value) {
        _position = value;
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
          _controller.isPlaying() ? Icons.pause : Icons.play_arrow,
          () {
            if (_actionInProgress) {
              return;
            }
            _actionInProgress = true;
            Future<void> action = _controller.isPlaying()
                ? _controller.pause()
                : _controller.play();

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

  @override
  void initState() {
    super.initState();
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
