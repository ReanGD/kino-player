import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kino_player/utils/keys.dart';

class SeekBar extends StatefulWidget {
  final bool autofocus;
  final double _max;
  final double step;
  final double thumbPosition;
  final double markerPosition;

  final double trackHeight;
  final double focusedTrackHeight;
  final Color trackColor;
  final Color markeredTrackColor;

  final double thumbRadius;
  final double focusedThumbRadius;
  final Color thumbColor;
  final Color focusedThumbColor;

  final ValueChanged<double> onPressed;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeStart;
  final ValueChanged<double> onChangeEnd;
  final double _height;

  SeekBar({
    Key key,
    this.autofocus = false,
    double max = 100.0,
    this.step = 1.0,
    this.thumbPosition = 0.0,
    this.markerPosition = 0.0,
    this.trackHeight = 2.0,
    this.focusedTrackHeight = 2.0,
    this.trackColor = Colors.white,
    this.markeredTrackColor = Colors.blue,
    this.thumbRadius = 4.0,
    this.focusedThumbRadius = 6.0,
    this.thumbColor = const Color(0xBB2196F3),
    this.focusedThumbColor = Colors.blue,
    this.onPressed,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
  })  : _max = max <= 0 ? 1.0 : max,
        _height = 7.0 +
            _max4(thumbRadius, focusedThumbRadius, trackHeight,
                focusedTrackHeight),
        super(key: key);

  static double _max4(double v0, double v1, double v2, double v3) {
    double v01 = v0 > v1 ? v0 : v1;
    double v23 = v2 > v3 ? v2 : v3;

    return v01 > v23 ? v01 : v23;
  }

  @override
  State<StatefulWidget> createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  bool _focused = false;
  double _thumbPosition = 0.0;
  double _markerPosition = 0.0;

  double _clamp(double value) {
    return value > widget._max
        ? widget._max
        : value < 0.0
            ? 0.0
            : value;
  }

  double _touchPointToPosition(Offset touchPoint) {
    return _clamp(touchPoint.dx * widget._max / context.size.width);
  }

  double _getPositionAfterStep(bool isInc) {
    double position = _thumbPosition;
    if (isInc) {
      position += widget.step;
    } else {
      position -= widget.step;
    }

    return _clamp(position);
  }

  void _onPressed() {
    widget.onPressed?.call(_thumbPosition);
  }

  void _onChangeStart(double position) {
    if (_thumbPosition != position || !_focused) {
      setState(() {
        _focused = true;
        _thumbPosition = position;
      });
    }
    widget.onChangeStart?.call(position);
  }

  void _onChanged(double position) {
    if (_thumbPosition != position) {
      setState(() {
        _thumbPosition = position;
      });
    }
    widget.onChanged?.call(position);
  }

  void _onChangeEnd() {
    if (_focused) {
      setState(() {
        _focused = false;
      });
    }
    widget.onChangeEnd?.call(_thumbPosition);
  }

  @override
  void initState() {
    _thumbPosition = _clamp(widget.thumbPosition);
    _markerPosition = _clamp(widget.markerPosition);
    super.initState();
  }

  @override
  void didUpdateWidget(SeekBar oldWidget) {
    _thumbPosition = _clamp(widget.thumbPosition);
    _markerPosition = _clamp(widget.markerPosition);
    super.didUpdateWidget(oldWidget);
  }

  Widget _getView() {
    return Container(
      constraints: BoxConstraints.expand(height: widget._height),
      child: CustomPaint(
        painter: _SeekBarPainter(
          focused: _focused,
          max: widget._max,
          thumbPosition: _thumbPosition,
          markerPosition: _markerPosition,
          trackHeight:
              _focused ? widget.focusedTrackHeight : widget.trackHeight,
          trackColor: widget.trackColor,
          markeredTrackColor: widget.markeredTrackColor,
          thumbRadius: widget.thumbRadius,
          focusedThumbRadius: widget.focusedThumbRadius,
          thumbColor: widget.thumbColor,
          focusedThumbColor: widget.focusedThumbColor,
        ),
      ),
    );
  }

  Widget _getViewWithFocus() {
    return Focus(
      autofocus: widget.autofocus,
      child: _getView(),
      onKey: (FocusNode node, RawKeyEvent event) {
        if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          _onChanged(_getPositionAfterStep(false));
          return true;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          _onChanged(_getPositionAfterStep(true));
          return true;
        }
        if (isKeySelectPressed(event)) {
          _onPressed();
          return true;
        }
        return false;
      },
      onFocusChange: (bool focus) {
        if (focus) {
          _onChangeStart(_thumbPosition);
        } else {
          _onChangeEnd();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragDown: (details) {
        final RenderBox box = context.findRenderObject();
        final touchPoint = box.globalToLocal(details.globalPosition);
        _onChangeStart(_touchPointToPosition(touchPoint));
      },
      onHorizontalDragUpdate: (details) {
        final RenderBox box = context.findRenderObject();
        final touchPoint = box.globalToLocal(details.globalPosition);
        _onChanged(_touchPointToPosition(touchPoint));
      },
      onHorizontalDragEnd: (details) {
        _onChangeEnd();
      },
      child: _getViewWithFocus(),
    );
  }
}

class _SeekBarPainter extends CustomPainter {
  final bool focused;
  final double max;
  final double thumbPosition;
  final double markerPosition;
  final double trackHeight;
  final Color trackColor;
  final Color markeredTrackColor;
  final double thumbRadius;
  final double focusedThumbRadius;
  final Color thumbColor;
  final Color focusedThumbColor;

  _SeekBarPainter({
    this.focused,
    this.max,
    this.thumbPosition,
    this.markerPosition,
    this.trackHeight,
    this.trackColor,
    this.markeredTrackColor,
    this.thumbRadius,
    this.focusedThumbRadius,
    this.thumbColor,
    this.focusedThumbColor,
  });

  @override
  bool shouldRepaint(_SeekBarPainter old) {
    return max != old.max ||
        thumbPosition != old.thumbPosition ||
        markerPosition != old.markerPosition ||
        focused != old.focused;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.square
      ..strokeWidth = trackHeight;

    final maxThumbRadius =
        thumbRadius > focusedThumbRadius ? thumbRadius : focusedThumbRadius;
    final drawThumbRadius = focused ? focusedThumbRadius : thumbRadius;
    final startX = maxThumbRadius;
    final finishX = size.width - maxThumbRadius;
    final trackWidth = finishX - startX;
    final thumbX = startX + trackWidth * (thumbPosition / max);
    final markerX = startX + trackWidth * (markerPosition / max);
    final centerY = size.height / 2.0;

    paint.color = trackColor;
    canvas.drawLine(Offset(startX, centerY), Offset(finishX, centerY), paint);

    paint.color = markeredTrackColor;
    canvas.drawLine(Offset(startX, centerY), Offset(markerX, centerY), paint);

    paint.color = focused ? focusedThumbColor : thumbColor;
    canvas.drawCircle(Offset(thumbX, centerY), drawThumbRadius, paint);
  }
}
