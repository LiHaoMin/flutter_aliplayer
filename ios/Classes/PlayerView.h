//
//  PlayerView.h
//  Pods
//
//  Created by Mao Yanfei on 2020/8/31.
//

#import <Flutter/Flutter.h>

@interface PlayerView : NSObject<FlutterPlatformView>
- (instancetype)initWithWithFrame:(CGRect)frame
                   viewIdentifier:(int64_t)viewId
                        arguments:(id _Nullable)args
                  binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

@end
