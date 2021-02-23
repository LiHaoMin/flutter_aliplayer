import 'dart:async';

import 'package:flutter/services.dart';

class FlutterAliplayer {
  static const MethodChannel _channel =
      const MethodChannel('flutter_aliplayer');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
