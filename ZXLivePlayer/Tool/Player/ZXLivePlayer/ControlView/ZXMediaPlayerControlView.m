//
//  ZXMediaPlayerControlView.m
//  MediaPlayer
//
//  Created by zhaoxin on 2017/10/25.
//  Copyright © 2017年 zhaoxin. All rights reserved.
//

#import "ZXMediaPlayerControlView.h"
//#import "MMMaterialDesignSpinner.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "ZXMediaPlayerLoadingView.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

static const CGFloat MediaPlayerAnimationTimeInterval             = 7.0f;
static const CGFloat MediaPlayerControlBarAutoFadeOutTimeInterval = 0.35f;

@interface ZXMediaPlayerControlView () <UIGestureRecognizerDelegate>

/** 标题 */
@property (nonatomic, strong) UILabel                 *titleLabel;
/** 开始播放按钮 */
@property (nonatomic, strong) UIButton                *startBtn;
/** 当前播放时长label */
@property (nonatomic, strong) UILabel                 *currentTimeLabel;
/** 视频总时长label */
@property (nonatomic, strong) UILabel                 *totalTimeLabel;
/** 缓冲进度条 */
@property (nonatomic, strong) UIProgressView          *progressView;
/** 滑杆 */
@property (nonatomic, strong) ASValueTrackingSlider   *videoSlider;
/** 全屏按钮 */
@property (nonatomic, strong) UIButton                *fullScreenBtn;
/** 锁定屏幕方向按钮 */
@property (nonatomic, strong) UIButton                *lockBtn;
/** 系统菊花 */
@property (nonatomic, strong) ZXMediaPlayerLoadingView *activity;
/** 返回按钮*/
@property (nonatomic, strong) UIButton                *backBtn;
/** 关闭按钮*/
@property (nonatomic, strong) UIButton                *closeBtn;
/** 重播按钮 */
@property (nonatomic, strong) UIButton                *repeatBtn;
/** bottomView*/
@property (nonatomic, strong) UIImageView             *bottomImageView;
/** topView */
@property (nonatomic, strong) UIImageView             *topImageView;
/** 切换分辨率按钮 */
@property (nonatomic, strong) UIButton                *resolutionBtn;
/** 分辨率的View */
@property (nonatomic, strong) UIView                  *resolutionView;
/** 播放按钮 */
@property (nonatomic, strong) UIButton                *playBtn;
/** 加载失败按钮 */
@property (nonatomic, strong) UIButton                *failBtn;
/** 快进快退View*/
@property (nonatomic, strong) UIView                  *fastView;
/** 快进快退进度progress*/
@property (nonatomic, strong) UIProgressView          *fastProgressView;
/** 快进快退时间*/
@property (nonatomic, strong) UILabel                 *fastTimeLabel;
/** 快进快退ImageView*/
@property (nonatomic, strong) UIImageView             *fastImageView;
/** 当前选中的分辨率btn按钮 */
@property (nonatomic, weak  ) UIButton                *resoultionCurrentBtn;
/** 占位图 */
@property (nonatomic, strong) UIImageView             *placeholderImageView;
/** 控制层消失时候在底部显示的播放进度progress */
@property (nonatomic, strong) UIProgressView          *bottomProgressView;

/** 切换视角 */
@property (strong, nonatomic) UIButton *changeAngleBtn;

#pragma mark - 其他
/** 分辨率的名称 */
@property (nonatomic, strong) NSArray                 *resolutionArray;

/** 显示控制层 */
@property (nonatomic, assign, getter=isShowing) BOOL  showing;
/** 小屏播放 */
@property (nonatomic, assign, getter=isShrink ) BOOL  shrink;
/** 在cell上播放 */
@property (nonatomic, assign, getter=isCellVideo)BOOL cellVideo;
/** 是否拖拽slider控制播放进度 */
@property (nonatomic, assign, getter=isDragged) BOOL  dragged;
/** 是否播放结束 */
@property (nonatomic, assign, getter=isPlayEnd) BOOL  playeEnd;
/** 是否全屏播放 */
@property (nonatomic, assign,getter=isFullScreen)BOOL fullScreen;

@end

@implementation ZXMediaPlayerControlView

-(instancetype)initWithModel:(ZXMediaPlayerModel*)model{
    self = [super init];
    if (self) {
        self.model = model;

        [self addSubview:self.placeholderImageView];
        [self addSubview:self.topImageView];
        [self.topImageView addSubview:self.backBtn];
        [self addSubview:self.activity];

        [self addSubview:self.bottomImageView];
        [self addSubview:self.lockBtn];
        [self addSubview:self.repeatBtn];
        [self addSubview:self.playBtn];
        [self addSubview:self.failBtn];
        
        [self addSubview:self.fastView];
        [self.fastView addSubview:self.fastImageView];
        [self.fastView addSubview:self.fastTimeLabel];
        [self.fastView addSubview:self.fastProgressView];
        
        [self.topImageView addSubview:self.changeAngleBtn];
        [self.topImageView addSubview:self.resolutionBtn];
        [self.topImageView addSubview:self.titleLabel];
        [self addSubview:self.closeBtn];
        [self addSubview:self.bottomProgressView];
        
        [self.bottomImageView addSubview:self.fullScreenBtn];
        [self.bottomImageView addSubview:self.currentTimeLabel];
        if (MediaPlayerType_VOD == model.mediaPlayerType) {
            [self.bottomImageView addSubview:self.startBtn];
            [self.bottomImageView addSubview:self.progressView];
            [self.bottomImageView addSubview:self.videoSlider];
            [self.bottomImageView addSubview:self.totalTimeLabel];
        }
        // 添加子控件的约束
        [self makeSubViewsConstraints];
        
        // 初始化时重置controlView
        [self mediaPlayerResetControlView];
        // app退到后台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
        // app进入前台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayground) name:UIApplicationDidBecomeActiveNotification object:nil];
        
        [self onDeviceOrientationChange];

    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (void)makeSubViewsConstraints{
    [self layoutIfNeeded];
    [self.placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.mas_trailing).offset(7);
        make.top.equalTo(self.mas_top).offset(-7);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.mas_top).offset(15);
        make.height.mas_equalTo(45);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.topImageView.mas_leading).offset(10);
        make.top.equalTo(self.topImageView.mas_top).offset(0);
        make.width.height.mas_equalTo(45);
    }];
    
    self.resolutionBtn.hidden = YES;
    [self.resolutionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(25);
        make.trailing.equalTo(self.topImageView.mas_trailing).offset(-10);
        make.centerY.equalTo(self.backBtn.mas_centerY);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.backBtn.mas_trailing).offset(5);
        make.centerY.equalTo(self.backBtn.mas_centerY);
        make.trailing.equalTo(self.resolutionBtn.mas_leading).offset(-40);
    }];
    
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.changeAngleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(24);
        make.trailing.equalTo(self.topImageView.mas_trailing).offset(-10);
        make.centerY.equalTo(self.backBtn.mas_centerY);
    }];
    
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.trailing.equalTo(self.bottomImageView.mas_trailing).offset(-2);
        make.bottom.equalTo(self.bottomImageView.mas_bottom).offset(0);
    }];
    self.fullScreenBtn.imageEdgeInsets = UIEdgeInsetsMake(13, 10, 7, 10);
    
    if (MediaPlayerType_VOD == self.model.mediaPlayerType) {
        [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.bottomImageView.mas_leading).offset(2);
            make.centerY.equalTo(self.fullScreenBtn);
            make.width.height.mas_equalTo(50);
        }];
        
        self.startBtn.imageEdgeInsets = UIEdgeInsetsMake(13, 10, 7, 10);

        [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.startBtn.mas_trailing).offset(-3);
            make.centerY.equalTo(self.startBtn.mas_centerY);
            make.width.mas_equalTo(43);
        }];
        
        [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.fullScreenBtn.mas_leading).offset(3);
            make.centerY.equalTo(self.startBtn.mas_centerY);
            make.width.mas_equalTo(43);
        }];
        
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(4);
            make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-4);
            make.centerY.equalTo(self.startBtn.mas_centerY);
        }];
        
        [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(4);
            make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-4);
            make.centerY.equalTo(self.currentTimeLabel.mas_centerY).offset(-1);
            make.height.mas_equalTo(30);
        }];
    }else{
        self.currentTimeLabel.textAlignment = NSTextAlignmentLeft;
        [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(16);
            make.centerY.equalTo(self.fullScreenBtn);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(30);
        }];
    }
    
    [self.lockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.mas_equalTo(32);
    }];
    
    [self.repeatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.center.equalTo(self);
    }];
    
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.with.height.mas_equalTo(self);
        make.top.equalTo(self).offset(50);
    }];
    
    [self.failBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(33);
    }];
    
    [self.fastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(125);
        make.height.mas_equalTo(80);
        make.center.equalTo(self);
    }];
    
    [self.fastImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(32);
        make.height.mas_offset(32);
        make.top.mas_equalTo(5);
        make.centerX.mas_equalTo(self.fastView.mas_centerX);
    }];
    
    [self.fastTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.with.trailing.mas_equalTo(0);
        make.top.mas_equalTo(self.fastImageView.mas_bottom).offset(2);
    }];
    
    [self.fastProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(12);
        make.trailing.mas_equalTo(-12);
        make.top.mas_equalTo(self.fastTimeLabel.mas_bottom).offset(10);
    }];
    
    [self.bottomProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutIfNeeded];
    [self mediaPlayerCancelAutoFadeOutControlView];
    if (!self.isShrink && !self.isPlayEnd) {
        // 只要屏幕旋转就显示控制层
//        [self mediaPlayerShowControlView];
    }
    
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (currentOrientation == UIDeviceOrientationPortrait) {
        [self setOrientationPortraitConstraint];
    } else {
        [self setOrientationLandscapeConstraint];
    }
}

#pragma -mark model
-(void)setModel:(ZXMediaPlayerModel *)model{
    _model = model;
}

#pragma mark - Action

/**
 *  点击切换分别率按钮
 */
- (void)changeResolution:(UIButton *)sender {
    sender.selected = YES;
    if (sender.isSelected) {
        sender.backgroundColor = RGBA(86, 143, 232, 1);
    } else {
        sender.backgroundColor = [UIColor clearColor];
    }
    self.resoultionCurrentBtn.selected = NO;
    self.resoultionCurrentBtn.backgroundColor = [UIColor clearColor];
    self.resoultionCurrentBtn = sender;
    // 隐藏分辨率View
    self.resolutionView.hidden  = YES;
    // 分辨率Btn改为normal状态
    self.resolutionBtn.selected = NO;
    // topImageView上的按钮的文字
    [self.resolutionBtn setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(playerControlView:resolutionAction:)]) {
        [self.delegate playerControlView:self resolutionAction:sender];
    }
}

/**
 *  UISlider TapAction
 */
- (void)tapSliderAction:(UITapGestureRecognizer *)tap {
    if ([tap.view isKindOfClass:[UISlider class]]) {
        UISlider *slider = (UISlider *)tap.view;
        CGPoint point = [tap locationInView:slider];
        CGFloat length = slider.frame.size.width;
        // 视频跳转的value
        CGFloat tapValue = point.x / length;
        if ([self.delegate respondsToSelector:@selector(playerControlView:progressSliderTap:)]) {
            [self.delegate playerControlView:self progressSliderTap:tapValue];
        }
    }
}
// 不做处理，只是为了滑动slider其他地方不响应其他手势
- (void)panRecognizer:(UIPanGestureRecognizer *)sender {}

- (void)backBtnClick:(UIButton *)sender {
    // 状态条的方向旋转的方向,来判断当前屏幕的方向
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    // 在cell上并且是竖屏时候响应关闭事件
    if (self.isCellVideo && orientation == UIInterfaceOrientationPortrait) {
        if ([self.delegate respondsToSelector:@selector(playerControlView:closeAction:)]) {
            [self.delegate playerControlView:self closeAction:sender];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(playerControlView:backAction:)]) {
            [self.delegate playerControlView:self backAction:sender];
        }
    }
}

- (void)lockScrrenBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.showing = NO;
    [self mediaPlayerShowControlView];
    if ([self.delegate respondsToSelector:@selector(playerControlView:lockScreenAction:)]) {
        [self.delegate playerControlView:self lockScreenAction:sender];
    }
}

- (void)playBtnClick:(UIButton *)sender {
    BOOL selected = !sender.selected;
    sender.selected = selected;
    self.playBtn.selected = selected;
    
    if ([self.delegate respondsToSelector:@selector(playerControlView:playAction:)]) {
        [self.delegate playerControlView:self playAction:sender];
    }
    
    if (selected) {
        self.playBtn.alpha = 0;
    }else{
        [self showControlView];
        [self mediaPlayerCancelAutoFadeOutControlView];
    }
}

- (void)closeBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(playerControlView:closeAction:)]) {
        [self.delegate playerControlView:self closeAction:sender];
    }
}

- (void)fullScreenBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(playerControlView:fullScreenAction:)]) {
        [self.delegate playerControlView:self fullScreenAction:sender];
    }
}

- (void)repeatBtnClick:(UIButton *)sender {
    // 重置控制层View
    [self mediaPlayerResetControlView];
    [self mediaPlayerShowControlView];
    if ([self.delegate respondsToSelector:@selector(playerControlView:repeatPlayAction:)]) {
        [self.delegate playerControlView:self repeatPlayAction:sender];
    }
}

- (void)resolutionBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    // 显示隐藏分辨率View
    self.resolutionView.hidden = !sender.isSelected;
}

-(void)changeAngleBtnClick:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(playerControlView:changeAngleAction:)]) {
        [self.delegate playerControlView:self changeAngleAction:sender];
    }
}

- (void)centerPlayBtnClick:(UIButton *)sender {
    BOOL selected = !sender.selected;
    sender.selected = selected;
    self.startBtn.selected = selected;

    if (selected) {
        self.playBtn.alpha = 0;
    }else{
        [self showControlView];
        [self mediaPlayerCancelAutoFadeOutControlView];
    }
    
    if ([self.delegate respondsToSelector:@selector(playerControlView:playAction:)]) {
        [self.delegate playerControlView:self playAction:sender];
    }
    
}

- (void)failBtnClick:(UIButton *)sender {
    self.failBtn.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(playerControlView:failAction:)]) {
        [self.delegate playerControlView:self failAction:sender];
    }
}

- (void)progressSliderTouchBegan:(ASValueTrackingSlider *)sender {
    [self mediaPlayerCancelAutoFadeOutControlView];
    self.videoSlider.popUpView.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(playerControlView:progressSliderTouchBegan:)]) {
        [self.delegate playerControlView:self progressSliderTouchBegan:sender];
    }
}

- (void)progressSliderValueChanged:(ASValueTrackingSlider *)sender {
    if ([self.delegate respondsToSelector:@selector(playerControlView:progressSliderValueChanged:)]) {
        [self.delegate playerControlView:self progressSliderValueChanged:sender];
    }
}

- (void)progressSliderTouchEnded:(ASValueTrackingSlider *)sender {
    self.showing = YES;
    if ([self.delegate respondsToSelector:@selector(playerControlView:progressSliderTouchEnded:)]) {
        [self.delegate playerControlView:self progressSliderTouchEnded:sender];
    }
}

/**
 *  应用退到后台
 */
- (void)appDidEnterBackground {
    [self mediaPlayerCancelAutoFadeOutControlView];
}

/**
 *  应用进入前台
 */
- (void)appDidEnterPlayground {
    
    if (!self.isShrink) {
        [self mediaPlayerShowControlView];
    }
}

- (void)playerPlayDidEnd {
    self.backgroundColor  = RGBA(0, 0, 0, .6);
    self.repeatBtn.hidden = NO;
    // 初始化显示controlView为YES
    self.showing = NO;
    // 延迟隐藏controlView
    [self mediaPlayerShowControlView];
}

/**
 *  屏幕方向发生变化会调用这里
 */
- (void)onDeviceOrientationChange {
    if (MediaPlayerShared.isLockScreen) {
        return;
    }
    self.lockBtn.hidden         = !self.isFullScreen;
    self.fullScreenBtn.selected = self.isFullScreen;
//    self.topImageView.hidden = !self.isFullScreen;
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown || orientation == UIDeviceOrientationPortraitUpsideDown) { return; }
    if (MediaPlayerOrientationIsLandscape) {
        [self setOrientationLandscapeConstraint];
    } else {
        [self setOrientationPortraitConstraint];
    }
    [self layoutIfNeeded];
}

- (void)setOrientationLandscapeConstraint {
    if (self.isCellVideo) {
        self.shrink             = NO;
    }
    self.fullScreen             = YES;
    self.lockBtn.hidden         = !self.isFullScreen;
//    self.topImageView.hidden = !self.isFullScreen;

    self.fullScreenBtn.selected = self.isFullScreen;
    [self.backBtn setImage:MediaPlayerImage(@"MediaPlayer_back_full") forState:UIControlStateNormal];
    [self layoutIfNeeded];
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.mas_top).offset(15);
        make.height.mas_equalTo(45);
    }];
    
    [self.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topImageView.mas_top).offset(0);
        make.leading.equalTo(self.topImageView.mas_leading).offset(10);
        make.width.height.mas_equalTo(45);
    }];
}
/**
 *  设置竖屏的约束
 */
- (void)setOrientationPortraitConstraint {
    self.fullScreen             = NO;
    self.lockBtn.hidden         = !self.isFullScreen;
//    self.topImageView.hidden = !self.isFullScreen;

    self.fullScreenBtn.selected = self.isFullScreen;
    [self layoutIfNeeded];
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.mas_top).offset(15);
        make.height.mas_equalTo(45);
    }];
    
    [self.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.topImageView.mas_leading).offset(10);
        make.top.equalTo(self.topImageView.mas_top).offset(0);
        make.width.height.mas_equalTo(45);
    }];
    
    if (self.isCellVideo) {
        [self.backBtn setImage:MediaPlayerImage(@"MediaPlayer_close") forState:UIControlStateNormal];
    }
}

#pragma mark - Private Method
- (void)showControlView {
    if (self.lockBtn.isSelected) {
        self.topImageView.alpha    = 0;
        self.bottomImageView.alpha = 0;
        self.playBtn.alpha = 0;
    } else {
        self.topImageView.alpha    = 1;
        self.bottomImageView.alpha = 1;
        self.playBtn.alpha = 1;
    }
    self.backgroundColor           = RGBA(0, 0, 0, 0.3);
    self.lockBtn.alpha             = 1;
    self.bottomProgressView.alpha  = 0;
    if (self.isFullScreen) {
        MediaPlayerShared.isStatusBarHidden = NO;
    }else{
        MediaPlayerShared.isStatusBarHidden = YES;
    }
    
}

- (void)cancelFadeOutAndShowControlView{
    [self mediaPlayerCancelAutoFadeOutControlView];
    [UIView animateWithDuration:MediaPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self showControlView];
    } completion:^(BOOL finished) {
        self.showing = YES;
        [self autoFadeOutControlView];
    }];
}

- (void)cancelFadeOutAndHideControlView{
    [self mediaPlayerCancelAutoFadeOutControlView];
    [self hideControlView];
    self.showing = NO;
}

- (void)hideControlView {
    self.backgroundColor          = RGBA(0, 0, 0, 0);
    self.topImageView.alpha       = self.playeEnd;
    self.bottomImageView.alpha    = 0;
    self.playBtn.alpha = 0;
    self.lockBtn.alpha            = 0;
    self.bottomProgressView.alpha = 1;
    // 隐藏resolutionView
    self.resolutionBtn.selected = YES;
    [self resolutionBtnClick:self.resolutionBtn];
    if (self.isFullScreen) {
        MediaPlayerShared.isStatusBarHidden = NO;
    }else{
        MediaPlayerShared.isStatusBarHidden = YES;
    }
    
}

/**
 *  监听设备旋转通知
 */
- (void)listeningRotating {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}


- (void)autoFadeOutControlView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(mediaPlayerHideControlView) object:nil];
    [self performSelector:@selector(mediaPlayerHideControlView) withObject:nil afterDelay:MediaPlayerAnimationTimeInterval];
}

/**
 slider滑块的bounds
 */
- (CGRect)thumbRect {
    return [self.videoSlider thumbRectForBounds:self.videoSlider.bounds
                                      trackRect:[self.videoSlider trackRectForBounds:self.videoSlider.bounds]
                                          value:self.videoSlider.value];
}

#pragma mark - setter

- (void)setShrink:(BOOL)shrink {
    _shrink = shrink;
    self.closeBtn.hidden = !shrink;
    self.bottomProgressView.hidden = shrink;
}

- (void)setFullScreen:(BOOL)fullScreen {
    _fullScreen = fullScreen;
    MediaPlayerShared.isLandscape = fullScreen;
}

#pragma mark - getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _titleLabel;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:MediaPlayerImage(@"MediaPlayer_back_full") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView                        = [[UIImageView alloc] init];
        _topImageView.userInteractionEnabled = YES;
    }
    return _topImageView;
}



- (UIImageView *)bottomImageView {
    if (!_bottomImageView) {
        _bottomImageView                        = [[UIImageView alloc] init];
        _bottomImageView.userInteractionEnabled = YES;
//        _bottomImageView.image                  = MediaPlayerImage(@"MediaPlayer_bottom_shadow");
    }
    return _bottomImageView;
}

- (UIButton *)lockBtn {
    if (!_lockBtn) {
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockBtn setImage:MediaPlayerImage(@"MediaPlayer_unlock-nor") forState:UIControlStateNormal];
        [_lockBtn setImage:MediaPlayerImage(@"MediaPlayer_lock-nor") forState:UIControlStateSelected];
        [_lockBtn addTarget:self action:@selector(lockScrrenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _lockBtn;
}

- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn setImage:MediaPlayerImage(@"MediaPlayer_play") forState:UIControlStateNormal];
        [_startBtn setImage:MediaPlayerImage(@"MediaPlayer_pause") forState:UIControlStateSelected];
        [_startBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:MediaPlayerImage(@"MediaPlayer_close") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel               = [[UILabel alloc] init];
        _currentTimeLabel.textColor     = [UIColor whiteColor];
        _currentTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView                   = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _progressView.trackTintColor    = [UIColor clearColor];
    }
    return _progressView;
}

- (ASValueTrackingSlider *)videoSlider {
    if (!_videoSlider) {
        _videoSlider                       = [[ASValueTrackingSlider alloc] init];
        _videoSlider.popUpViewCornerRadius = 0.0;
        _videoSlider.popUpViewColor = RGBA(19, 19, 9, 1);
        _videoSlider.popUpViewArrowLength = 8;
        
        [_videoSlider setThumbImage:MediaPlayerImage(@"MediaPlayer_slider") forState:UIControlStateNormal];
        _videoSlider.maximumValue          = 1;
        _videoSlider.minimumTrackTintColor = [UIColor whiteColor];
        _videoSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        
        // slider开始滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [_videoSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
        
        UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSliderAction:)];
        [_videoSlider addGestureRecognizer:sliderTap];
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panRecognizer:)];
        panRecognizer.delegate = self;
        [panRecognizer setMaximumNumberOfTouches:1];
        [panRecognizer setDelaysTouchesBegan:YES];
        [panRecognizer setDelaysTouchesEnded:YES];
        [panRecognizer setCancelsTouchesInView:YES];
        [_videoSlider addGestureRecognizer:panRecognizer];
    }
    return _videoSlider;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel               = [[UILabel alloc] init];
        _totalTimeLabel.textColor     = [UIColor whiteColor];
        _totalTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}

- (UIButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:MediaPlayerImage(@"MediaPlayer_fullscreen") forState:UIControlStateNormal];
        [_fullScreenBtn setImage:MediaPlayerImage(@"MediaPlayer_shrinkscreen") forState:UIControlStateSelected];
        [_fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenBtn;
}

- (ZXMediaPlayerLoadingView *)activity {
    if (!_activity) {
        _activity = [[ZXMediaPlayerLoadingView alloc] init];
//        _activity.lineWidth = 1;
//        _activity.duration  = 1;
//        _activity.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    }
    return _activity;
}

- (UIButton *)repeatBtn {
    if (!_repeatBtn) {
        _repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_repeatBtn setImage:MediaPlayerImage(@"MediaPlayer_repeat_video") forState:UIControlStateNormal];
        [_repeatBtn addTarget:self action:@selector(repeatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _repeatBtn;
}

- (UIButton *)resolutionBtn {
    if (!_resolutionBtn) {
        _resolutionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resolutionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _resolutionBtn.backgroundColor = RGBA(0, 0, 0, 0.7);
        [_resolutionBtn addTarget:self action:@selector(resolutionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resolutionBtn;
}

-(UIButton*)changeAngleBtn{
    if (_changeAngleBtn == nil) {
        _changeAngleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeAngleBtn setTitle:@"切换视角" forState:UIControlStateNormal];
        _changeAngleBtn.layer.cornerRadius = 12;
        _changeAngleBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _changeAngleBtn.layer.borderWidth = 1;
        _changeAngleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_changeAngleBtn addTarget:self action:@selector(changeAngleBtnClick:) forControlEvents:UIControlEventTouchDown];
    }
    return _changeAngleBtn;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"match_btn_suspend"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"match_btn_paly"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(centerPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIButton *)failBtn {
    if (!_failBtn) {
        _failBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_failBtn setTitle:@"加载失败,点击重试" forState:UIControlStateNormal];
        [_failBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _failBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _failBtn.backgroundColor = RGBA(0, 0, 0, 0.7);
        [_failBtn addTarget:self action:@selector(failBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _failBtn;
}

- (UIView *)fastView {
    if (!_fastView) {
        _fastView                     = [[UIView alloc] init];
        _fastView.backgroundColor     = RGBA(0, 0, 0, 0.8);
        _fastView.layer.cornerRadius  = 4;
        _fastView.layer.masksToBounds = YES;
    }
    return _fastView;
}

- (UIImageView *)fastImageView {
    if (!_fastImageView) {
        _fastImageView = [[UIImageView alloc] init];
    }
    return _fastImageView;
}

- (UILabel *)fastTimeLabel {
    if (!_fastTimeLabel) {
        _fastTimeLabel               = [[UILabel alloc] init];
        _fastTimeLabel.textColor     = [UIColor whiteColor];
        _fastTimeLabel.textAlignment = NSTextAlignmentCenter;
        _fastTimeLabel.font          = [UIFont systemFontOfSize:14.0];
    }
    return _fastTimeLabel;
}

- (UIProgressView *)fastProgressView {
    if (!_fastProgressView) {
        _fastProgressView                   = [[UIProgressView alloc] init];
        _fastProgressView.progressTintColor = [UIColor whiteColor];
        _fastProgressView.trackTintColor    = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    }
    return _fastProgressView;
}

- (UIImageView *)placeholderImageView {
    if (!_placeholderImageView) {
        _placeholderImageView = [[UIImageView alloc] init];
        _placeholderImageView.userInteractionEnabled = YES;
        _placeholderImageView.backgroundColor = [UIColor clearColor];
    }
    return _placeholderImageView;
}

- (UIProgressView *)bottomProgressView {
    if (!_bottomProgressView) {
        _bottomProgressView                   = [[UIProgressView alloc] init];
        _bottomProgressView.progressTintColor = [UIColor redColor];
        _bottomProgressView.trackTintColor    = [UIColor clearColor];
    }
    return _bottomProgressView;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGRect rect = [self thumbRect];
    CGPoint point = [touch locationInView:self.videoSlider];
    if ([touch.view isKindOfClass:[UISlider class]]) { // 如果在滑块上点击就不响应pan手势
        if (point.x <= rect.origin.x + rect.size.width && point.x >= rect.origin.x) { return NO; }
    }
    return YES;
}

#pragma mark - Public method
/** 重置ControlView */
- (void)mediaPlayerResetControlView {
    [self.activity stopLoading];
    self.backgroundColor = [UIColor clearColor];

    self.videoSlider.value           = 0;
    self.bottomProgressView.progress = 0;
    self.progressView.progress       = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
    self.fastView.hidden             = YES;
    self.repeatBtn.hidden            = YES;
    //    self.playBtn.hidden             = YES;
    self.resolutionView.hidden       = YES;
    self.failBtn.hidden              = YES;
    self.shrink                      = NO;
    self.showing                     = NO;
    self.playeEnd                    = NO;
    self.lockBtn.hidden              = !self.isFullScreen;
    
    self.placeholderImageView.alpha  = 1;
    self.changeAngleBtn.alpha = 1;
    self.titleLabel.alpha = 1;
        
}

- (void)mediaPlayerResetControlViewForResolution {
    self.fastView.hidden        = YES;
    self.repeatBtn.hidden       = YES;
    self.resolutionView.hidden  = YES;
//    self.playBtn.hidden        = YES;
    self.failBtn.hidden         = YES;
    self.backgroundColor        = [UIColor clearColor];
    self.shrink                 = NO;
    self.showing                = NO;
    self.playeEnd               = NO;
}

/**
 *  取消延时隐藏controlView的方法
 */
- (void)mediaPlayerCancelAutoFadeOutControlView {
    self.showing = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

/** 设置播放模型 */
- (void)playerModel:(ZXMediaPlayerModel *)playerModel {
    
    if (playerModel.title) { self.titleLabel.text = playerModel.title; }
    // 设置网络占位图片
    if (playerModel.placeholderImageURLString) {
//        [self.placeholderImageView sd_setImageWithURL:[NSURL URLWithString:playerModel.placeholderImageURLString]
//                   placeholderImage:MediaPlayerImage(@"MediaPlayer_loading_bgView")];
    } else {
        self.placeholderImageView.image = playerModel.placeholderImage;
    }
    if (playerModel.resolutionDic) {
        [self mediaPlayerResolutionArray:[playerModel.resolutionDic allKeys]];
    }
}

/** 正在播放（隐藏placeholderImageView） */
- (void)mediaPlayerItemPlaying {
    [UIView animateWithDuration:0.2 animations:^{
        self.placeholderImageView.alpha = 0;
    }];
}

/**
 *  显示控制层
 */
- (void)mediaPlayerShowControlView {
    if (self.isShowing) {
        [self mediaPlayerHideControlView];
        return;
    }
    [self cancelFadeOutAndShowControlView];
}

/**
 *  隐藏控制层
 */
- (void)mediaPlayerHideControlView {
    if (!self.isShowing) { return; }
    [self mediaPlayerCancelAutoFadeOutControlView];
    [UIView animateWithDuration:MediaPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self hideControlView];
    }completion:^(BOOL finished) {
        self.showing = NO;
    }];
}

/** 小屏播放 */
- (void)mediaPlayerBottomShrinkPlay {
    [self updateConstraints];
    [self layoutIfNeeded];
    self.shrink = YES;
    [self hideControlView];
}

/** 在cell播放 */
- (void)mediaPlayerCellPlay {
    self.cellVideo = YES;
    self.shrink    = YES;
    [self.backBtn setImage:MediaPlayerImage(@"MediaPlayer_close") forState:UIControlStateNormal];
    [self layoutIfNeeded];
    [self mediaPlayerShowControlView];
}

- (void)mediaPlayerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)value {
    // 当前时长进度progress
    NSInteger proMin = currentTime / 60;//当前秒
    NSInteger proSec = currentTime % 60;//当前分钟
    // duration 总时长
    NSInteger durMin = totalTime / 60;//总秒
    NSInteger durSec = totalTime % 60;//总分钟
    if (!self.isDragged) {
        // 更新slider
        self.videoSlider.value           = value;
        self.bottomProgressView.progress = value;
        // 更新当前播放时间
        self.currentTimeLabel.text       = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    }
    // 更新总时间
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
}

- (void)mediaPlayerDraggedTime:(NSInteger)draggedTime totalTime:(NSInteger)totalTime isForward:(BOOL)forawrd hasPreview:(BOOL)preview {
    [self cancelFadeOutAndShowControlView];
    
    // 快进快退时候停止菊花
    [self.activity stopLoading];
    // 拖拽的时长
    NSInteger proMin = draggedTime / 60;//当前秒
    NSInteger proSec = draggedTime % 60;//当前分钟
    
    //duration 总时长
    NSInteger durMin = totalTime / 60;//总秒
    NSInteger durSec = totalTime % 60;//总分钟
    
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    NSString *totalTimeStr   = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    CGFloat  draggedValue    = (CGFloat)draggedTime/(CGFloat)totalTime;
    NSString *timeStr        = [NSString stringWithFormat:@"%@ / %@", currentTimeStr, totalTimeStr];
    
    // 显示、隐藏预览窗
    self.videoSlider.popUpView.hidden = !preview;
    // 更新slider的值
    self.videoSlider.value            = draggedValue;
    // 更新bottomProgressView的值
    self.bottomProgressView.progress  = draggedValue;
    // 更新当前时间
    self.currentTimeLabel.text        = currentTimeStr;
    // 正在拖动控制播放进度
    self.dragged = YES;
    
    if (forawrd) {
        self.fastImageView.image = MediaPlayerImage(@"MediaPlayer_fast_forward");
    } else {
        self.fastImageView.image = MediaPlayerImage(@"MediaPlayer_fast_backward");
    }
    self.fastView.hidden           = preview;
    self.fastTimeLabel.text        = timeStr;
    self.fastProgressView.progress = draggedValue;
    
}

-(void)mediaPlayerDraggedEnded{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.fastView.hidden = YES;
    });
    self.dragged = NO;
}

- (void)mediaPlayerDraggedEnd {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.fastView.hidden = YES;
    });
    self.dragged = NO;
    // 结束滑动时候把开始播放按钮改为播放状态
//    self.startBtn.selected = YES;
    // 滑动结束延时隐藏controlView
    [self autoFadeOutControlView];
}

- (void)mediaPlayerDraggedTime:(NSInteger)draggedTime sliderImage:(UIImage *)image; {
    // 拖拽的时长
    NSInteger proMin = draggedTime / 60;//当前秒
    NSInteger proSec = draggedTime % 60;//当前分钟
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    [self.videoSlider setImage:image];
    [self.videoSlider setText:currentTimeStr];
    self.fastView.hidden = YES;
}

/** progress显示缓冲进度 */
- (void)mediaPlayerSetProgress:(CGFloat)progress {
    [self.progressView setProgress:progress animated:NO];
}

/** 视频加载失败 */
- (void)mediaPlayerItemStatusFailed:(NSError *)error {
    self.failBtn.hidden = NO;
    
    self.backBtn.alpha = 1;
    self.playBtn.alpha = 0;
    self.fastView.hidden = YES;
    
    self.bottomImageView.alpha = 0;
    self.repeatBtn.alpha = 0;
    self.changeAngleBtn.alpha = 0;
}

/** 加载的菊花 */
- (void)mediaPlayerActivity:(BOOL)animated {
    if (animated) {
        [self.activity startLoading];
        self.activity.status = YES;
        
        self.backBtn.alpha = 1;
        self.playBtn.alpha = 0;
        self.fastView.hidden = YES;
        
        self.bottomImageView.alpha = 0;
        self.repeatBtn.alpha = 0;
        self.changeAngleBtn.alpha = 0;
    } else {
        [self.activity stopLoading];
        
        self.bottomImageView.alpha = 1;
        self.repeatBtn.alpha = 1;
        self.changeAngleBtn.alpha = 1;
    }
}

-(void)mediaPlayerDisconnect{
    [self.activity stopLoading];

    self.topImageView.alpha = 0;
    self.fastView.hidden = YES;
    
    self.bottomImageView.alpha = 0;
    self.repeatBtn.alpha = 0;
    self.changeAngleBtn.alpha = 0;
    
    [self cancelFadeOutAndHideControlView];
}

/** 播放完了 */
- (void)mediaPlayerPlayEnd {
    self.repeatBtn.hidden = YES;
    self.playeEnd         = YES;
    self.showing          = NO;
    // 隐藏controlView
    [self hideControlView];
    self.backgroundColor  = RGBA(0, 0, 0, .3);
    MediaPlayerShared.isStatusBarHidden = NO;
    self.bottomProgressView.alpha = 0;
    
}

/**
 是否有切换分辨率功能
 */
- (void)mediaPlayerResolutionArray:(NSArray *)resolutionArray {
    self.resolutionBtn.hidden = NO;
    
    _resolutionArray = resolutionArray;
    [_resolutionBtn setTitle:resolutionArray.firstObject forState:UIControlStateNormal];
    // 添加分辨率按钮和分辨率下拉列表
    self.resolutionView = [[UIView alloc] init];
    self.resolutionView.hidden = YES;
    self.resolutionView.backgroundColor = RGBA(0, 0, 0, 0.7);
    [self addSubview:self.resolutionView];
    
    [self.resolutionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(25*resolutionArray.count);
        make.leading.equalTo(self.resolutionBtn.mas_leading).offset(0);
        make.top.equalTo(self.resolutionBtn.mas_bottom).offset(0);
    }];
    
    // 分辨率View上边的Btn
    for (NSInteger i = 0 ; i < resolutionArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        btn.layer.borderWidth = 0.5;
        btn.tag = 200+i;
        btn.frame = CGRectMake(0, 25*i, 40, 25);
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitle:resolutionArray[i] forState:UIControlStateNormal];
        if (i == 0) {
            self.resoultionCurrentBtn = btn;
            btn.selected = YES;
            btn.backgroundColor = RGBA(86, 143, 232, 1);
        }
        [self.resolutionView addSubview:btn];
        [btn addTarget:self action:@selector(changeResolution:) forControlEvents:UIControlEventTouchUpInside];
    }
}

/** 播放按钮状态 */
- (void)mediaPlayerPlayBtnState:(BOOL)state {
    self.startBtn.selected = state;
    self.playBtn.selected = state;
}

/** 锁定屏幕方向按钮状态 */
- (void)mediaPlayerLockBtnState:(BOOL)state {
    self.lockBtn.selected = state;
}

#pragma clang diagnostic pop

@end

