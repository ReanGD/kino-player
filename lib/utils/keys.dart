import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

bool isKeySelectPressed(RawKeyEvent event) {
  if (event is RawKeyDownEvent) {
    if (event.logicalKey == LogicalKeyboardKey.select) {
      return true;
    }
  } else if (event is RawKeyUpEvent) {
    // xiaomi + samsung remote
    if ((event.logicalKey == LogicalKeyboardKey.select) &&
        (event.physicalKey.usbHidUsage == 0x000700e4)) {
      return true;
    }
  }

  return false;
}
