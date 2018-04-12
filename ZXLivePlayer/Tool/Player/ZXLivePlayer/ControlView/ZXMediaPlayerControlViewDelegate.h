//
//  ZXMediaPlayerControlViewDelegate.h
//  MediaPlayer
//
//  Created by zhaoxin on 2017/10/25.
//  Copyright © 2017年 zhaoxin. All rights reserved.
//

#ifndef ZXMediaPlayerControlViewDelegate_h
#define ZXMediaPlayerControlViewDelegate_h


#endif /* ZXMediaPlayerControlViewDelegate_h */

@protocol MediaPlayerControlViewDelagate <NSObject>

@optional
/**  返回按钮事件 */
- (void)playerControlView:(UIView *)controlView backAction:(UIButton *)sender;
/**  cell播放中小屏状态 关闭按钮事件 */
- (void)playerControlView:(UIView *)controlView closeAction:(UIButton *)sender;
/** 播放按钮事件 */
- (void)playerControlView:(UIView *)controlView playAction:(UIButton *)sender;
/** 全屏按钮事件 */
- (void)playerControlView:(UIView *)controlView fullScreenAction:(UIButton *)sender;
/** 锁定屏幕方向按钮时间 */
- (void)playerControlView:(UIView *)controlView lockScreenAction:(UIButton *)sender;
/** 重播按钮事件 */
- (void)playerControlView:(UIView *)controlView repeatPlayAction:(UIButton *)sender;
/** 中间播放按钮事件 */
- (void)playerControlView:(UIView *)controlView centerPlayAction:(UIButton *)sender;
/** 加载失败按钮事件 */
- (void)playerControlView:(UIView *)controlView failAction:(UIButton *)sender;
/** 更多按钮(如右上角的分享按钮)事件 */
- (void)playerControlView:(UIView *)controlView moreAction:(UIButton *)sender;
/** 切换分辨率按钮事件 */
- (void)playerControlView:(UIView *)controlView resolutionAction:(UIButton *)sender;
/** slider的点击事件（点击slider控制进度） */
- (void)playerControlView:(UIView *)controlView progressSliderTap:(CGFloat)value;
/** 开始触摸slider */
- (void)playerControlView:(UIView *)controlView progressSliderTouchBegan:(UISlider *)slider;
/** slider触摸中 */
- (void)playerControlView:(UIView *)controlView progressSliderValueChanged:(UISlider *)slider;
/** slider触摸结束 */
- (void)playerControlView:(UIView *)controlView progressSliderTouchEnded:(UISlider *)slider;

/** 切换视角 */
- (void)playerControlView:(UIView *)controlView changeAngleAction:(UIButton *)sender;
@end
