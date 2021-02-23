//
//  PlayerViewFactory.m
//  flutter_aliplayer
//
//  Created by Mao Yanfei on 2020/8/31.
//

#import "PlayerViewFactory.h"
#import "PlayerView.h"

@interface PlayerViewFactory ()
@property(nonatomic)NSObject<FlutterBinaryMessenger>* messenger;
@end

@implementation PlayerViewFactory

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messenger {
    self = [super init];
    if (self) {
        self.messenger = messenger;
    }
    return self;
}

- (NSObject<FlutterMessageCodec> *)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args {
    PlayerView *playerView = [[PlayerView alloc] initWithWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
    return playerView;
}

@end
