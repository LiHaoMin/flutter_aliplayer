import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_aliplayer/view/ali_player.dart';

class AliPlayerController {
  MethodChannel _channel;
  StreamController<Map<dynamic, dynamic>> _eventListener;

  AliPlayerController(int id) {
    _channel = new MethodChannel('${AliPlayer.VIEW_NAME}_$id');
    _eventListener = StreamController<Map<dynamic, dynamic>>.broadcast();
    _channel.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'eventListener':
        _eventListener.add(call.arguments as Map<dynamic, dynamic>);
        break;
    }
  }

  Future<void> init() async {
    return await _channel.invokeMethod('init');
  }

  Future<void> setDataSource(String vid, String auth) async {
    var params = {
      'vid': vid,
      'auth': auth,
    };
    return await _channel.invokeMethod('setDataSource', params);
  }
  Future<void> setUrlDataSource(String playurl) async {
    var params = {
      'playurl': playurl,
    };
    return await _channel.invokeMethod('setUrlDataSource', params);
  }

  Future<void> start() async {
    return await _channel.invokeMethod('start');
  }

  Future<void> stop() async {
    return await _channel.invokeMethod('stop');
  }

  Future<void> pause() async {
    return await _channel.invokeMethod('pause');
  }

  Future<void> seekTo(int seek) async {
    var params = {
      'seek': seek,
    };
    return await _channel.invokeMethod('seekTo', params);
  }

  Future<void> release() async {
    return await _channel.invokeMethod('release');
  }

  Future<int> getDuration() async {
    return await _channel.invokeMethod('getDuration');
  }

  Future<int> getVideoWidth() async {
    return await _channel.invokeMethod('getVideoWidth');
  }

  Future<int> getVideoHeight() async {
    return await _channel.invokeMethod('getVideoHeight');
  }

  Future<void> setVolume(double volume) async {
    var params = {
      'volume': volume,
    };
    return await _channel.invokeMethod('setVolume', params);
  }

  Future<double> getVolume() async {
    return await _channel.invokeMethod('getVolume');
  }

  Future<void> setMute(bool flag) async {
    var params = {
      'flag': flag,
    };
    return await _channel.invokeMethod('setMute', params);
  }

  Future<bool> isMute() async {
    return await _channel.invokeMethod('isMute');
  }

  Stream<Map<dynamic, dynamic>> eventListener() {
    return _eventListener.stream;
  }
}