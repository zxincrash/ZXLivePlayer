//
//  ZXPushPlayerView.h
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/3/29.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXMediaPlayer.h"

#define PUSH_URL_TEST @"rtmp://3891.livepush.myqcloud.com/live/3891_user_bea5056c_0a23?bizid=3891&txSecret=b44be37a13dffafeca8960a446eecfd3&txTime=5AC6E64E"


@protocol ZXPushPlayerViewDelegate<NSObject>

-(void)quitPushPlayerView;


@end

@interface ZXPushPlayerView : UIView
@property (weak, nonatomic) id<ZXPushPlayerViewDelegate> delegate;
@property (copy, nonatomic) NSString *pushUrl;
@property (weak, nonatomic) UIViewController *rootViewController;

+ (instancetype)shared;
/** 设置播放模型数据 */
- (void)playerModel:(ZXMediaPlayerModel *)playerModel;
/** 开始推流 */
-(void)startPublish;
/** 结束推流 */
-(void)clearPublish;

@end
