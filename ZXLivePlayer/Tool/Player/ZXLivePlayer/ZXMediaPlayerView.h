//
//  ZXMediaPlayerView.h
//  ZXLivePlayer
//
//  Created by zhaoxin on 2017/12/21.
//  Copyright © 2017年 zhaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXMediaPlayer.h"
#import "ZXCommon.h"

@protocol MediaPlayerDelegate <NSObject>
@optional
/** 返回按钮事件 */
- (void)mediaPlayerBackAction;
/** 更多按钮 */
- (void)mediaPlayerMoreAction;
/** 当前网络改变 */
- (void)networkChangeTo:(ZXNetWorkStatus)networkStatus;
@end


// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontalMoved, // 横向移动
    PanDirectionVerticalMoved    // 纵向移动
};


@interface ZXMediaPlayerView : UIView<MediaPlayerControlViewDelagate>
@property (strong, nonatomic) DQGameModel *gameModel;

/** 是否开启预览图 */
@property (nonatomic, assign) BOOL hasPreviewView;
/** 设置代理 */
@property (nonatomic, weak) id<MediaPlayerDelegate> delegate;
/** 是否被用户暂停 */
@property (nonatomic, assign, readonly) BOOL isPauseByUser;
/** 播发器的几种状态 */
@property (nonatomic, assign, readonly) MediaPlayerState state;
/** 静音（默认为NO）*/
@property (nonatomic, assign) BOOL mute;
/** 是否允许自动转屏, 默认YES */
@property (nonatomic, assign) BOOL allowAutoRotate;
/** 允许双指点击进行全屏/非全屏切换, 默认NO */
@property (nonatomic, assign) BOOL                    enableFullScreenSwitchWith2Fingers;
/** 播放器添加到的视图控制器, 包含MediaPlayerView容器视图的视图控制器 */
@property (nonatomic, weak) UIViewController *rootViewController;
/** 是否正在旋转屏幕 */
@property (nonatomic, assign, readonly) BOOL isRotating;

@property (assign, nonatomic) AngleType angleType;

@property (assign, nonatomic) ZXNetWorkStatus netWorkStatus;
/**
 *  单例，用于列表cell上多个视频
 *
 *  @return MediaPlayer
 */
+ (instancetype)sharedPlayerView;

/**
 * 使用自带的控制层时候可使用此API
 */
- (void)playerModel:(ZXMediaPlayerModel *)playerModel;

/**
 *  自动播放，默认不自动播放
 */
- (void)playTheVideo;

/**
 *  重置player
 */
- (void)resetPlayer;

/**
 *  在当前页面，设置新的视频时候调用此方法
 */
- (void)resetToPlayNewVideo:(ZXMediaPlayerModel *)playerModel;

/** 播放 */
- (void)play;

/** 暂停 */
- (void)pause;

/** 结束播放 */
- (void)clearPlay;

@end
