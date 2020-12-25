import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

class ControlPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}
