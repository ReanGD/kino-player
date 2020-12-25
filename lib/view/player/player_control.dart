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
  @override
  _ControlPanelState createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  double _position = 0.0;
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
          Icons.play_arrow,
          () {},
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
    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          _getSeekBar(),
          _getControlButtons(),
        ]);
  }
}
