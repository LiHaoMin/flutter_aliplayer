import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aliplayer/controller/ali_player_controller.dart';

class AliPlayer extends StatefulWidget {
  static const String VIEW_NAME = "li.haomin.aliplayer.view/player";

  final ValueChanged<AliPlayerController> onViewCreated;
  final Function eventListen;

  const AliPlayer({
    Key key,
    this.onViewCreated,
    this.eventListen
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => AliPlayerState();

}

class AliPlayerState extends State<AliPlayer> {

  AliPlayerController _controller;
  StreamSubscription<Map<dynamic, dynamic>> _listen;

  @override
  void dispose() {
    _controller?.release();
    _listen?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> params = {};
    var paramsCodec = StandardMessageCodec();

    if (Platform.isAndroid) {
      return AndroidView(
        viewType: AliPlayer.VIEW_NAME,
        creationParams: params,
        onPlatformViewCreated: _onViewCreated,
        creationParamsCodec: paramsCodec,
      );
    } else if (Platform.isIOS) {
      return UiKitView(
        viewType: AliPlayer.VIEW_NAME,
        creationParams: params,
        onPlatformViewCreated: _onViewCreated,
        creationParamsCodec: paramsCodec,
      );
    } else {
      return Center(
          child: Text("不支持的平台", softWrap: true,)
      );
    }
  }

  void _onViewCreated(int viewId) {
    _controller = AliPlayerController(viewId);
    _listen = _controller.eventListener().listen(widget.eventListen);
    _controller.init();
    if (widget.onViewCreated != null) {
      widget.onViewCreated(_controller);
    }
  }
}