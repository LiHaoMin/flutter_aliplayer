#import "FlutterAliplayerPlugin.h"
#import "PlayerViewFactory.h"

@implementation FlutterAliplayerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_aliplayer"
            binaryMessenger:[registrar messenger]];
  FlutterAliplayerPlugin* instance = [[FlutterAliplayerPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
    PlayerViewFactory* factory = [[PlayerViewFactory alloc] initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:factory withId:@"li.haomin.aliplayer.view/player"];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
