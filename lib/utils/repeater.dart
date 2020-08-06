import 'dart:async';

import 'package:flutter/foundation.dart';

class Repeater {
  static Future<void> repeat(
      {@required VoidCallback callback,
      @required int repeatNumber,
      Duration repeatDuration = const Duration(milliseconds: 300)}) async {
    for (int i = 0; i < repeatNumber - 1; i++) {
      callback();
      await Future.delayed(repeatDuration);
    }
    callback();
  }
}
