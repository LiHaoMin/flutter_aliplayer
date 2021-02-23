//
//  PlayerView.m
//  flutter_aliplayer
//
//  Created by Mao Yanfei on 2020/8/31.
//

#import "PlayerView.h"
#import <AliyunPlayer/AliPlayer.h>

@interface PlayerView()<AVPDelegate>

@property(nonatomic)FlutterMethodChannel* methodChannel;
@property(nonatomic)AliPlayer * aliPlayer;
@property(nonatomic)UIView * renderView;

@end

@implementation PlayerView

- (instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger {
    if ([super init]) {
        self.renderView = [[UIView alloc] initWithFrame:frame];
        self.methodChannel = [FlutterMethodChannel
                              methodChannelWithName:[@"li.haomin.aliplayer.view/player" stringByAppendingFormat:@"_%lld", viewId]
              binaryMessenger:messenger];
        __block typeof(self) weakSelf = self;
        [self.methodChannel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
            [weakSelf handleMethodCall:call result:result];
        }];
    }
    return self;
}

- (UIView *)view {
    return self.renderView;
}

- (void) handleMethodCall:(FlutterMethodCall *) call result:(FlutterResult) result {
    
    NSDictionary *dic = (NSDictionary *) call.arguments;
    
    if ([@"init" isEqualToString:call.method]) {
        if (_aliPlayer != nil) {
            return;
        }
        _aliPlayer = [[AliPlayer alloc] init];
        _aliPlayer.playerView = _renderView;
        _aliPlayer.delegate = self;
        _aliPlayer.autoPlay = YES;
    } else if ([@"setDataSource" isEqualToString:call.method]) {
        AVPVidAuthSource *source = [[AVPVidAuthSource alloc] init];
        source.vid = dic[@"vid"];
        source.playAuth = dic[@"auth"];
        [_aliPlayer setAuthSource:source];
        [_aliPlayer prepare];
    } else if ([@"start" isEqualToString:call.method]) {
        [_aliPlayer start];
    } else if ([@"stop" isEqualToString:call.method]) {
        [_aliPlayer stop];
    } else if ([@"pause" isEqualToString:call.method]) {
        [_aliPlayer pause];
    } else if ([@"seekTo" isEqualToString:call.method]) {
        [_aliPlayer seekToTime:[dic[@"seek"] longLongValue] seekMode:AVP_SEEKMODE_INACCURATE];
    } else if ([@"release" isEqualToString:call.method]) {
        if (_aliPlayer != nil) {
            [_aliPlayer destroy];
            _aliPlayer = nil;
        }
    } else if ([@"getDuration" isEqualToString:call.method]) {
        result(@(_aliPlayer.duration));
    } else if ([@"getVideoWidth" isEqualToString:call.method]) {
        result(@(_aliPlayer.width));
    } else if ([@"getVideoHeight" isEqualToString:call.method]) {
        result(@(_aliPlayer.height));
    } else if ([@"setVolume" isEqualToString:call.method]) {
        _aliPlayer.volume = [dic[@"volume"] floatValue];
    } else if ([@"getVolume" isEqualToString:call.method]) {
        result(@(_aliPlayer.volume));
    } else if ([@"setMute" isEqualToString:call.method]) {
        _aliPlayer.muted = [dic[@"flag"] boolValue];
    } else if ([@"isMute" isEqualToString:call.method]) {
        result(@(_aliPlayer.isMuted));
    } else if ([@"redraw" isEqualToString:call.method]) {
        [_aliPlayer redraw];
    } else if ([@"reset" isEqualToString:call.method]) {
           [_aliPlayer reset];
    } else if ([@"reload" isEqualToString:call.method]) {
           [_aliPlayer reload];
    } else {
      result(FlutterMethodNotImplemented);
    }
}

- (void)onPlayerEvent:(AliPlayer *)player eventType:(AVPEventType)eventType {
    switch (eventType) {
        case AVPEventPrepareDone:
            [_methodChannel invokeMethod:@"eventListener" arguments:@{
                @"event": @"onPrepared"
            }];
            break;
        case AVPEventCompletion:
            [_methodChannel invokeMethod:@"eventListener" arguments:@{
                @"event": @"onCompletion"
            }];
            break;
        case AVPEventLoadingStart:
            [_methodChannel invokeMethod:@"eventListener" arguments:@{
                @"event": @"onLoadingBegin"
            }];
            break;
        case AVPEventLoadingEnd:
            [_methodChannel invokeMethod:@"eventListener" arguments:@{
                @"event": @"onLoadingEnd"
            }];
            break;
            
        default:
            break;
    }
}

- (void)onPlayerStatusChanged:(AliPlayer *)player oldStatus:(AVPStatus)oldStatus newStatus:(AVPStatus)newStatus {
    [_methodChannel invokeMethod:@"eventListener" arguments:@{
        @"event": @"onStateChanged",
        @"state": @(newStatus)
    }];
}

- (void)onBufferedPositionUpdate:(AliPlayer *)player position:(int64_t)position {
    [_methodChannel invokeMethod:@"eventListener" arguments:@{
        @"event": @"onBufferedPosition",
        @"position": @(position)
    }];
}

- (void)onCurrentPositionUpdate:(AliPlayer *)player position:(int64_t)position {
    [_methodChannel invokeMethod:@"eventListener" arguments:@{
        @"event": @"onCurrentPosition",
        @"position": @(position)
    }];
}

- (void)onLoadingProgress:(AliPlayer *)player progress:(float)progress {
    NSLog(@"onLoadingProgress");
    [_methodChannel invokeMethod:@"eventListener" arguments:@{
        @"event": @"onLoadingProgress",
        @"percent": @(progress),
        @"kbps": @(0)
    }];
}

- (void)onError:(AliPlayer *)player errorModel:(AVPErrorModel *)errorModel {
    [_methodChannel invokeMethod:@"eventListener" arguments:@{
        @"event": @"onError",
        @"code": @(errorModel.code),
        @"msg": errorModel.message
    }];
}

@end
