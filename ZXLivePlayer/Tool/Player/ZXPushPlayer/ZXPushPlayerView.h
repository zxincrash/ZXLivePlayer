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
/** 设置播放模型数据 */
- (void)playerModel:(ZXMediaPlayerModel *)playerModel;
/** 开始推流 */
-(void)startRtmp;
/** 结束推流 */
-(void)clearPublish;

@end
