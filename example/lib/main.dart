import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_aliplayer/controller/ali_player_controller.dart';
import 'package:flutter_aliplayer/flutter_aliplayer.dart';
import 'package:flutter_aliplayer/view/ali_player.dart';
import 'package:seekbar/seekbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  final String vid = 'c91f0c83ee704a9b9ad19ba315eca526';
  final String auth = 'eyJTZWN1cml0eVRva2VuIjoiQ0FJUzN3SjFxNkZ0NUIyeWZTaklyNWZCZmZuWGlMcDJ6dnF5TVUrQ3NsTm5RTXR1cTRUc296ejJJSGhKZVhOdkJPMGV0ZjQrbVdCWTdQY1lsck1xRXNBZUdoMmVQSk1wc2NRSnFGLzZKcExGc3QySjZyOEpqc1VncHE1Zm9GaXBzdlhKYXNEVkVma3VFNVhFTWlJNS8wMGU2TC8rY2lyWVhEN0JHSmFWaUpsaFE4MEtWdzJqRjFSdkQ4dFhJUTBRazYxOUszemRaOW1nTGlidWkzdnhDa1J2MkhCaWptOHR4cW1qL015UTV4MzFpMXYweStCM3dZSHRPY3FjYThCOU1ZMVdUc3Uxdm9oemFyR1Q2Q3BaK2psTStxQVU2cWxZNG1YcnM5cUhFa0ZOd0JpWFNaMjJsT2RpTndoa2ZLTTNOcmRacGZ6bjc1MUN0L2ZVaXA3OHhtUW1YNGdYY1Z5R0dOLzZuNU9aUXJ6emI0WmhKZWVsQVJtWGpJRFRiS3VTbWhnL2ZIY1dPRGxOZjljY01YSnFBWFF1TUdxQ2QvTDlwdzJYT2x6NUd2WFZnUHRuaTRBSjVsSHA3TWVNR1YrRGVMeVF5aDBFSWFVN2EwNDQvNWVUWWFwazFNVWFnQUVjYmhXTDUrZGhrY2NJTWZ2cXZOT0I3cmZWSk9MRTRnTjhZZ05QRW5ObUhvU2ZXWEhhTmszdlhteXpFQ1hiSGgzV28xcHJORmNCQ0FpMlI1VFRBdFEwRWVEL0JmTE9tMFVoU2ZsbS9TTlluUlBLMUhNREJDTXZsaGlCcndLdGI1TmYxczcvckxVTWxFL21tR0dsRUFwUnVqQlpYbVBQWndMbUloaURPdmdOS0E9PSIsIkF1dGhJbmZvIjoie1wiQ0lcIjpcIlBJU2JNR3IvUHJuQk9MZEJvN2pMM0UvUjJhOW5GMHhSVHBRMlhBQ0xHTTFVVS9SMVEyMC9aclE3aGlqVHZ5a1RmWXM2TkdNNmdVdEFcXHJcXG5PNGdURDVhRk9YaGtOK2ZxeGdSZUVBK2pMTXN4Z1FZPVxcclxcblwiLFwiQ2FsbGVyXCI6XCI3bkFlZ3lwTnBqeGFuNEtmMEw4Yy9jQnVTZHZkdjUyR0JLVFlRZ1RtbVNJPVxcclxcblwiLFwiRXhwaXJlVGltZVwiOlwiMjAyMC0wOC0yOFQxMDowMDowMlpcIixcIk1lZGlhSWRcIjpcImM5MWYwYzgzZWU3MDRhOWI5YWQxOWJhMzE1ZWNhNTI2XCIsXCJQbGF5RG9tYWluXCI6XCJ2b2R0cC5sb3Roei5jb21cIixcIlNpZ25hdHVyZVwiOlwiZHUrTS9sZjRJOHNoMnF2RkNsNkw0QnJKZUI0PVwifSIsIlZpZGVvTWV0YSI6eyJTdGF0dXMiOiJOb3JtYWwiLCJWaWRlb0lkIjoiYzkxZjBjODNlZTcwNGE5YjlhZDE5YmEzMTVlY2E1MjYiLCJUaXRsZSI6Ik1SV1gzLjAxLm1wNCIsIkNvdmVyVVJMIjoiaHR0cDovL3ZvZHRwLmxvdGh6LmNvbS9jOTFmMGM4M2VlNzA0YTliOWFkMTliYTMxNWVjYTUyNi9zbmFwc2hvdHMvZTEzNTE0M2UyYzQ4NDlmYzkxNGJiMzllMDk5NWQyNzEtMDAwMDUuanBnIiwiRHVyYXRpb24iOjI1ODUuMzk1fSwiQWNjZXNzS2V5SWQiOiJTVFMuTlR0NkNjZWVXeThZM2kzVlMyTERCREFHQSIsIlBsYXlEb21haW4iOiJ2b2R0cC5sb3Roei5jb20iLCJBY2Nlc3NLZXlTZWNyZXQiOiI1Um9hdmZVeFM5RU1DWkczZDl6QVZSZDFhUWFtc2kxc1dheWNMdnBlcGlNciIsIlJlZ2lvbiI6ImNuLXNoYW5naGFpIiwiQ3VzdG9tZXJJZCI6MTE3Mzc5MjkwMTc4NjE0M30=';

  AliPlayerController _controller;
  double _seekValue = 0.0;
  double _seekBufValue = 0.0;
  int _duration = 0;
  int _buffPos = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterAliplayer.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            Text('Running on: $_platformVersion\n'),
            AspectRatio(
              child: AliPlayer(
                onViewCreated: (ctrl) => _controller = ctrl,
                eventListen: _eventListen,
              ),
              aspectRatio: 16 / 9,
            ),
            SeekBar(
              barColor: Colors.blue,
              progressColor: Colors.red,
              value: _seekValue,
              secondValue: _seekBufValue,
              secondProgressColor: Colors.black87,
              onProgressChanged: (seek) => _controller.seekTo((seek * _duration).floor()),
            ),
            _buffPos != 0 ? Text("缓冲中：$_buffPos%") : SizedBox(),
            Wrap(
              children: <Widget>[
                RaisedButton(
                  child: Text('setDataSource'),
                  onPressed: () => _controller.setDataSource(vid, auth),
                ),
                RaisedButton(
                  child: Text('start'),
                  onPressed: () => _controller.start(),
                ),
                RaisedButton(
                  child: Text('stop'),
                  onPressed: () => _controller.stop(),
                ),
                RaisedButton(
                  child: Text('pause'),
                  onPressed: () => _controller.pause(),
                ),
                RaisedButton(
                  child: Text('setMute'),
                  onPressed: () => _controller.isMute().then((value) => _controller.setMute(!value)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _eventListen(e) {
    var event = e['event'];
    switch(event) {
      case 'onPrepared':
        _controller.getDuration().then((value) => _duration = value);
        break;
      case "onCurrentPosition":
        setState(() {
          _seekValue = e['position'] / _duration;
        });
        break;
      case "onBufferedPosition":
      setState(() {
        _seekBufValue = e['position'] / _duration;
      });
      break;
      case "onLoadingBegin":
        setState(() {
          _buffPos = 0;
        });
        break;
      case "onLoadingProgress":
        setState(() {
          _buffPos = e['percent'];
        });
        break;
      case "onLoadingEnd":
        setState(() {
          _buffPos = 0;
        });
        break;
    }
  }
}
