import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SeekBar extends StatefulWidget {
  final double max;
  final double step;
  final double value;
  final double markerValue;
  final bool autofocus;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeStart;
  final ValueChanged<double> onChangeEnd;
  // old
  final double progressWidth;
  final double thumbRadius;
  final Color barColor;
  final Color progressColor;
  final Color secondProgressColor;
  final Color thumbColor;

  SeekBar({
    Key key,
    this.max = 100.0,
    this.step = 1.0,
    this.value = 0.0,
    this.markerValue = 0.0,
    this.autofocus = false,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    // old
    this.progressWidth = 2.0,
    this.thumbRadius = 7.0,
    this.barColor = const Color(0x73FFFFFF),
    this.progressColor = Colors.white,
    this.secondProgressColor = const Color(0xBBFFFFFF),
    this.thumbColor = Colors.white,
  }) : super(key: key);

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

  double _getTouchValue(Offset touchPoint) {
    final dx = _clamp(touchPoint.dx, 0, context.size.width);
    return dx * widget.max / context.size.width;
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
  Widget build(BuildContext context) {
    return Focus(
      autofocus: widget.autofocus,
      onKey: (FocusNode node, RawKeyEvent event) {
        if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          _onChanged(_value - widget.step);
          return true;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          _onChanged(_value + widget.step);
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
      child: GestureDetector(
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
        child: Container(
          constraints: BoxConstraints.expand(height: widget.thumbRadius * 2),
          child: CustomPaint(
            painter: _SeekBarPainter(
              max: widget.max,
              value: _value,
              markerValue: _markerValue,
              // old
              progressWidth: widget.progressWidth,
              thumbRadius: widget.thumbRadius,
              barColor: widget.barColor,
              progressColor: widget.progressColor,
              secondProgressColor: widget.secondProgressColor,
              thumbColor: widget.thumbColor,
              focused: _focused,
            ),
          ),
        ),
      ),
    );
  }
}

class _SeekBarPainter extends CustomPainter {
  final double max;
  final double value;
  final double markerValue;
  // old
  final double progressWidth;
  final double thumbRadius;
  final Color barColor;
  final Color progressColor;
  final Color secondProgressColor;
  final Color thumbColor;
  final bool focused;

  _SeekBarPainter({
    this.max,
    this.value,
    this.markerValue,
    // old
    this.progressWidth,
    this.thumbRadius,
    this.barColor,
    this.progressColor,
    this.secondProgressColor,
    this.thumbColor,
    this.focused,
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
      ..strokeWidth = progressWidth;

    final centerY = size.height / 2.0;
    final barLength = size.width - thumbRadius * 2.0;

    final Offset startPoint = Offset(thumbRadius, centerY);
    final Offset endPoint = Offset(size.width - thumbRadius, centerY);
    final Offset progressPoint =
        Offset(barLength * (value / max) + thumbRadius, centerY);
    final Offset secondProgressPoint =
        Offset(barLength * (markerValue / max) + thumbRadius, centerY);

    paint.color = barColor;
    canvas.drawLine(startPoint, endPoint, paint);

    paint.color = secondProgressColor;
    canvas.drawLine(startPoint, secondProgressPoint, paint);

    paint.color = progressColor;
    canvas.drawLine(startPoint, progressPoint, paint);

    final Paint thumbPaint = Paint()..isAntiAlias = true;

    thumbPaint.color = Colors.transparent;
    canvas.drawCircle(progressPoint, centerY, thumbPaint);

    if (focused) {
      thumbPaint.color = thumbColor.withOpacity(0.6);
      canvas.drawCircle(progressPoint, thumbRadius, thumbPaint);
    }

    thumbPaint.color = thumbColor;
    canvas.drawCircle(progressPoint, thumbRadius * 0.75, thumbPaint);
  }
}
