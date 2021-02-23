//
//  PlayerViewFactory.h
//  Pods
//
//  Created by Mao Yanfei on 2020/8/31.
//

#import <Flutter/Flutter.h>

@interface PlayerViewFactory : NSObject<FlutterPlatformViewFactory>
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end
