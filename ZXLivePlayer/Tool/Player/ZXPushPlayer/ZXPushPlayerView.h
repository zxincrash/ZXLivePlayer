//
//  ZXPushPlayerView.h
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/3/29.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXMediaPlayer.h"

@protocol ZXPushPlayerViewDelegate<NSObject>

-(void)quitPushPlayerView;

@end

@interface ZXPushPlayerView : UIView
@property (weak, nonatomic) id<ZXPushPlayerViewDelegate> delegate;
@property (nonatomic, strong) NSString *pushUrl;
@property (nonatomic, weak) UIViewController *rootViewController;

+ (instancetype)shared;

- (void)playerModel:(ZXMediaPlayerModel *)playerModel;

-(void)startRtmp;
-(void)clearPublish;

@end
