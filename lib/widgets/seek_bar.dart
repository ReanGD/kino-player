import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SeekBar extends StatefulWidget {
  final bool autofocus;
  final double max;
  final double step;
  final double value;
  final double markerValue;

  final double trackHeight;
  final double activeTrackHeight;
  final Color trackColor;
  final Color markeredTrackColor;

  final double thumbRadius;
  final double activeThumbRadius;
  final Color thumbColor;
  final Color activeThumbColor;

  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeStart;
  final ValueChanged<double> onChangeEnd;
  final double _height;

  SeekBar({
    Key key,
    this.autofocus = false,
    this.max = 100.0,
    this.step = 1.0,
    this.value = 0.0,
    this.markerValue = 0.0,
    this.trackHeight = 2.0,
    this.activeTrackHeight = 2.0,
    this.trackColor = Colors.white,
    this.markeredTrackColor = Colors.blue,
    this.thumbRadius = 4.0,
    this.activeThumbRadius = 6.0,
    this.thumbColor = const Color(0xBB2196F3),
    this.activeThumbColor = Colors.blue,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
  })  : _height = 7.0 +
            _max(
                thumbRadius, activeThumbRadius, trackHeight, activeTrackHeight),
        super(key: key);

  static double _max(double v0, double v1, double v2, double v3) {
    double v01 = v0 > v1 ? v0 : v1;
    double v23 = v2 > v3 ? v2 : v3;

    return v01 > v23 ? v01 : v23;
  }

  @override
  State<StatefulWidget> createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  bool _focused = false;
  double _value = 0.0;
  double _markerValue = 0.0;

  double _clamp(double value, double min, double max) {
    return value > max
        ? max
        : value < min
            ? min
            : value;
  }

  double _getTouchValue(Offset touchPoint) {
    final value = touchPoint.dx * widget.max / context.size.width;
    return _clamp(value, 0, widget.max);
  }

  double _getKeyValue(bool isInc) {
    double value = _value;
    if (isInc) {
      value += widget.step;
    } else {
      value -= widget.step;
    }

    return _clamp(value, 0, widget.max);
  }

  void _onChangeStart(double value) {
    if (_value != value || !_focused) {
      setState(() {
        _value = value;
        _focused = true;
      });
    }
    if (widget.onChangeStart != null) {
      widget.onChangeStart(value);
    }
  }

  void _onChanged(double value) {
    if (_value != value) {
      setState(() {
        _value = value;
      });
    }
    if (widget.onChanged != null) {
      widget.onChanged(value);
    }
  }

  void _onChangeEnd() {
    if (_focused) {
      setState(() {
        _focused = false;
      });
    }
    if (widget.onChangeEnd != null) {
      widget.onChangeEnd(_value);
    }
  }

  @override
  void initState() {
    _value = _clamp(widget.value, 0, widget.max);
    _markerValue = _clamp(widget.markerValue, 0, widget.max);
    super.initState();
  }

  @override
  void didUpdateWidget(SeekBar oldWidget) {
    _value = _clamp(widget.value, 0, widget.max);
    _markerValue = _clamp(widget.markerValue, 0, widget.max);
    super.didUpdateWidget(oldWidget);
  }

  Widget _getView() {
    return Container(
      constraints: BoxConstraints.expand(height: widget._height),
      child: CustomPaint(
        painter: _SeekBarPainter(
          focused: _focused,
          max: widget.max,
          value: _value,
          markerValue: _markerValue,
          trackHeight: _focused ? widget.activeTrackHeight : widget.trackHeight,
          trackColor: widget.trackColor,
          markeredTrackColor: widget.markeredTrackColor,
          thumbRadius: widget.thumbRadius,
          activeThumbRadius: widget.activeThumbRadius,
          thumbColor: widget.thumbColor,
          activeThumbColor: widget.activeThumbColor,
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
          _onChanged(_getKeyValue(false));
          return true;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          _onChanged(_getKeyValue(true));
          return true;
        }
        return false;
      },
      onFocusChange: (bool focus) {
        if (focus) {
          _onChangeStart(_value);
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
        _onChangeStart(_getTouchValue(touchPoint));
      },
      onHorizontalDragUpdate: (details) {
        final RenderBox box = context.findRenderObject();
        final touchPoint = box.globalToLocal(details.globalPosition);
        _onChanged(_getTouchValue(touchPoint));
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
  final double value;
  final double markerValue;
  final double trackHeight;
  final Color trackColor;
  final Color markeredTrackColor;
  final double thumbRadius;
  final double activeThumbRadius;
  final Color thumbColor;
  final Color activeThumbColor;

  _SeekBarPainter({
    this.focused,
    this.max,
    this.value,
    this.markerValue,
    this.trackHeight,
    this.trackColor,
    this.markeredTrackColor,
    this.thumbRadius,
    this.activeThumbRadius,
    this.thumbColor,
    this.activeThumbColor,
  });

  @override
  bool shouldRepaint(_SeekBarPainter old) {
    return max != old.max ||
        value != old.value ||
        markerValue != old.markerValue ||
        focused != old.focused;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.square
      ..strokeWidth = trackHeight;

    final markerMax = value > markerValue ? value : markerValue;
    final maxThumbRadius =
        thumbRadius > activeThumbRadius ? thumbRadius : activeThumbRadius;
    final startX = maxThumbRadius;
    final finishX = size.width - maxThumbRadius;
    final trackWidth = finishX - startX;
    final thumbX = startX + trackWidth * (value / max);
    final markerX = startX + trackWidth * (markerMax / max);
    final centerY = size.height / 2.0;

    paint.color = trackColor;
    canvas.drawLine(Offset(startX, centerY), Offset(finishX, centerY), paint);

    paint.color = markeredTrackColor;
    canvas.drawLine(Offset(startX, centerY), Offset(markerX, centerY), paint);

    if (focused) {
      paint.color = activeThumbColor;
      canvas.drawCircle(Offset(thumbX, centerY), activeThumbRadius, paint);
    } else {
      paint.color = thumbColor;
      canvas.drawCircle(Offset(thumbX, centerY), thumbRadius, paint);
    }
  }
}
