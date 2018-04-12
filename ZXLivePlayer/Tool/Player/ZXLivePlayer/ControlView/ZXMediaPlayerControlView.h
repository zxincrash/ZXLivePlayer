//
//  MediaPlayerControlView.h
//  MediaPlayer
//
//  Created by zhaoxin on 2017/10/25.
//  Copyright © 2017年 zhaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASValueTrackingSlider.h"
#import "ZXMediaPlayer.h"

typedef enum
{
    DQMediaplayerRenderMode_FILL_SCREEN  = 0,    // 图像铺满屏幕
    DQMediaplayerRenderMode_FILL_EDGE            // 图像长边填满屏幕
}DQMediaplayerRenderMode;

@interface ZXMediaPlayerControlView : UIView

-(instancetype)initWithModel:(ZXMediaPlayerModel*)model;

@property (nonatomic, strong) ZXMediaPlayerModel *model;

@property (nonatomic, weak) id<MediaPlayerControlViewDelagate> delegate;

/**
 * 设置播放模型
 */
- (void)playerModel:(ZXMediaPlayerModel *)playerModel;

/**
 * 显示控制层
 */
- (void)mediaPlayerShowControlView;

/**
 * 隐藏控制层*/
- (void)mediaPlayerHideControlView;

/** 监听设备转屏通知 */
-(void)listeningRotating;
-(void)mediaPlayerDraggedEnded;

-(void)mediaPlayerDisconnect;
/**
 * 重置ControlView
 */
- (void)mediaPlayerResetControlView;

/**
 * 切换分辨率时重置ControlView
 */
- (void)mediaPlayerResetControlViewForResolution;

/**
 * 取消自动隐藏控制层view
 */
- (void)mediaPlayerCancelAutoFadeOutControlView;

/**
 * 开始播放（用来隐藏placeholderImageView）
 */
- (void)mediaPlayerItemPlaying;

/**
 * 播放完了
 */
- (void)mediaPlayerPlayEnd;

/**
 * 是否有切换分辨率功能
 * @param resolutionArray 分辨率名称的数组
 */
- (void)mediaPlayerResolutionArray:(NSArray *)resolutionArray;

/**
 * 播放按钮状态 (播放、暂停状态)
 */
- (void)mediaPlayerPlayBtnState:(BOOL)state;

/**
 * 锁定屏幕方向按钮状态
 */
- (void)mediaPlayerLockBtnState:(BOOL)state;


/**
 * 加载的菊花
 */
- (void)mediaPlayerActivity:(BOOL)animated;

/**
 * 设置预览图
 
 * @param draggedTime 拖拽的时长
 * @param image       预览图
 */
- (void)mediaPlayerDraggedTime:(NSInteger)draggedTime sliderImage:(UIImage *)image;

/**
 * 拖拽快进 快退
 
 * @param draggedTime 拖拽的时长
 * @param totalTime   视频总时长
 * @param forawrd     是否是快进
 * @param preview     是否有预览图
 */
- (void)mediaPlayerDraggedTime:(NSInteger)draggedTime totalTime:(NSInteger)totalTime isForward:(BOOL)forawrd hasPreview:(BOOL)preview;

/**
 * 滑动调整进度结束结束
 */
- (void)mediaPlayerDraggedEnd;

/**
 * 正常播放
 
 * @param currentTime 当前播放时长
 * @param totalTime   视频总时长
 * @param value       slider的value(0.0~1.0)
 */
- (void)mediaPlayerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)value;

/**
 * progress显示缓冲进度
 */
- (void)mediaPlayerSetProgress:(CGFloat)progress;

/**
 * 视频加载失败
 */
- (void)mediaPlayerItemStatusFailed:(NSError *)error;

/**
 * 小屏播放
 */
- (void)mediaPlayerBottomShrinkPlay;

/**
 * 在cell播放
 */
- (void)mediaPlayerCellPlay;

@end
