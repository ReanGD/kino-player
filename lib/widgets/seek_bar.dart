import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SeekBar extends StatefulWidget {
  final bool autofocus;
  final double max;
  final double step;
  final double value;
  final double markerValue;
  final double thumbRadius;
  final double activeThumbRadius;
  final double trackHeight;
  final double activeTrackHeight;
  final double _height;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeStart;
  final ValueChanged<double> onChangeEnd;
  // old
  final Color barColor;
  final Color progressColor;
  final Color secondProgressColor;
  final Color thumbColor;

  SeekBar({
    Key key,
    this.autofocus = false,
    this.max = 100.0,
    this.step = 1.0,
    this.value = 0.0,
    this.markerValue = 0.0,
    this.thumbRadius = 0.0,
    this.activeThumbRadius = 7.0,
    this.trackHeight = 2.0,
    this.activeTrackHeight = 2.0,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    // old
    this.barColor = const Color(0x73FFFFFF),
    this.progressColor = Colors.white,
    this.secondProgressColor = const Color(0xBBFFFFFF),
    this.thumbColor = Colors.white,
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
          thumbRadius: widget.thumbRadius,
          activeThumbRadius: widget.activeThumbRadius,
          trackHeight: _focused ? widget.activeTrackHeight : widget.trackHeight,
          // old
          barColor: widget.barColor,
          progressColor: widget.progressColor,
          secondProgressColor: widget.secondProgressColor,
          thumbColor: widget.thumbColor,
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
  final double thumbRadius;
  final double activeThumbRadius;
  final double trackHeight;
  // old
  final Color barColor;
  final Color progressColor;
  final Color secondProgressColor;
  final Color thumbColor;

  _SeekBarPainter({
    this.focused,
    this.max,
    this.value,
    this.markerValue,
    this.thumbRadius,
    this.activeThumbRadius,
    this.trackHeight,
    // old
    this.barColor,
    this.progressColor,
    this.secondProgressColor,
    this.thumbColor,
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
    final Offset startTrackPoint = Offset(startX, centerY);
    final Offset finishTrackPoint = Offset(finishX, centerY);
    final Offset thumbPoint = Offset(thumbX, centerY);
    final Offset markerPoint = Offset(markerX, centerY);

    paint.color = barColor;
    canvas.drawLine(startTrackPoint, finishTrackPoint, paint);

    paint.color = progressColor;
    canvas.drawLine(startTrackPoint, markerPoint, paint);

    final Paint thumbPaint = Paint()..isAntiAlias = true;

    if (focused) {
      thumbPaint.color = thumbColor.withOpacity(0.6);
      canvas.drawCircle(thumbPoint, activeThumbRadius, thumbPaint);
    } else {
      thumbPaint.color = thumbColor;
      canvas.drawCircle(thumbPoint, thumbRadius, thumbPaint);
    }
  }
}
