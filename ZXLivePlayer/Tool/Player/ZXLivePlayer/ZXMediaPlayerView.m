//
//  ZXMediaPlayerView.m
//  ZXLivePlayer
//
//  Created by zhaoxin on 2017/12/21.
//  Copyright © 2017年 zhaoxin. All rights reserved.
//

#import "ZXMediaPlayerView.h"
#import <TXLiteAVSDK_Professional/TXVodPlayer.h>
#import <TXLiteAVSDK_Professional/TXLivePlayer.h>
#import <AFNetworking.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>




#pragma mark - MediaPlayerViewController

@interface ZXMediaPlayerView()<TXVodPlayListener,TXLivePlayListener,UIGestureRecognizerDelegate,DQChangeAngleViewDelegate>
{
    float _sliderValue;
}
@property (nonatomic, assign) MediaPlayerType mediaPlayerType;


/** 点播实例 */
@property (nonatomic, strong) TXVodPlayer *txVodPlayer;
/** 点播配置 */
@property (nonatomic, strong) TXVodPlayConfig *txVodConfig;

/** 直播实例 */
@property (nonatomic, strong) TXLivePlayer *txLivePlayer;
/** 直播配置 */
@property (nonatomic, strong) TXLivePlayConfig *txLiveConfig;
@property (nonatomic, assign) TX_Enum_PlayType livePlayType;

@property (nonatomic, strong) ZXMediaPlayerControlView *controlView;
@property (nonatomic, strong) ZXMediaPlayerModel *playerModel;
@property (nonatomic, assign) NSInteger seekTime;
@property (nonatomic, strong) NSString *playUrl;
@property (nonatomic, strong) NSDictionary *resolutionDic;


/** 滑杆 */
@property (nonatomic, strong) UISlider *volumeViewSlider;
/** slider上次的值 */
@property (nonatomic, assign) CGFloat sliderLastValue;

/** 是否正在拖拽 */
@property (nonatomic, assign) BOOL isDragged;

/** 是否为全屏 */
@property (nonatomic, assign) BOOL isFullScreen;
/** 是否锁定屏幕方向 */
@property (nonatomic, assign) BOOL isLocked;
/** 是否在调节音量*/
@property (nonatomic, assign) BOOL isVolume;
/** 是否被用户暂停 */
@property (nonatomic, assign) BOOL isPauseByUser;
/** 播放完了*/
@property (nonatomic, assign) BOOL playDidEnd;
/** 进入后台*/
@property (nonatomic, assign) BOOL didEnterBackground;
/** 是否正在旋转屏幕 */
@property (nonatomic, assign) BOOL isRotating;
/** 单击 */
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
/** 双击 */
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;

/** 用来保存快进的总时长 */
@property (nonatomic, assign) CGFloat sumTime;
/** 定义一个实例变量，保存枚举值 */
@property (nonatomic, assign) PanDirection panDirection;

/** 亮度view */
@property (nonatomic, strong) ZXBrightnessView *brightnessView;

@end

@implementation ZXMediaPlayerView

+ (instancetype)sharedPlayerView {
    __strong static ZXMediaPlayerView *playerView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerView = [[ZXMediaPlayerView alloc] init];

    });
    return playerView;
}

- (void)playerModel:(ZXMediaPlayerModel *)playerModel {
    // 指定默认控制层
    ZXMediaPlayerControlView *defaultControlView = [[ZXMediaPlayerControlView alloc] initWithModel:playerModel];
    
    self.controlView.model = playerModel;
    
    defaultControlView.frame = self.frame;
    _allowAutoRotate = YES;
    self.controlView = defaultControlView;
    self.playerModel = playerModel;
}

- (void)setControlView:(ZXMediaPlayerControlView *)controlView {
    if (_controlView) {
        [_controlView removeFromSuperview];
    }
    _controlView = controlView;
    controlView.delegate = self;
    [self layoutIfNeeded];
    [self addSubview:controlView];
    [controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)setPlayerModel:(ZXMediaPlayerModel *)playerModel {
    _playerModel = playerModel;
    self.mediaPlayerType = _playerModel.mediaPlayerType;
    self.angleType = AngleType_MAIN1;
    
    NSCAssert(playerModel.fatherView, @"请指定playerView的faterView");
    
    if (playerModel.seekTime) {
        self.seekTime = playerModel.seekTime;
    }
    
    [self.controlView playerModel:playerModel];
    
    if (playerModel.resolutionDic) {
        self.resolutionDic = playerModel.resolutionDic;
    }
    
    [self addPlayerToFatherView:playerModel.fatherView];
    self.playUrl = playerModel.playUrl;
}

/**
 *  player添加到fatherView上
 */
- (void)addPlayerToFatherView:(UIView *)view {
    // 这里应该添加判断，因为view有可能为空，当view为空时[view addSubview:self]会crash
    if (view) {
        [self removeFromSuperview];
        [view addSubview:self];
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsZero);
        }];
        [view layoutIfNeeded];
    }
}

-(void)playTheVideo{
    self.alpha = 1;
    //检查playUrl
    if (![self checkPlayUrl:self.playUrl]) {
        return;
    }

    switch (self.mediaPlayerType) {
        case MediaPlayerType_VOD:
            [self startVodPlayer];
            break;
        case MediaPlayerType_LIVE:
            [self startLivePlayer];
            break;
        case MediaPlayerType_PUSH:
            [self startLivePlayer];
            break;
        default:
            break;
    }

}

- (void)resetToPlayNewVideo:(ZXMediaPlayerModel *)playerModel{

    [self resetPlayer];
    [self playTheVideo];
}

-(TXVodPlayer*)txVodPlayer
{
    if (_txVodPlayer == nil) {
        _txVodPlayer = [[TXVodPlayer alloc]init];
    }
    return _txVodPlayer;
}

-(TXLivePlayer*)txLivePlayer
{
    if (_txLivePlayer == nil) {
        _txLivePlayer = [[TXLivePlayer alloc]init];
    }
    return _txLivePlayer;
}


- (void)dealloc {
    MediaPlayerShared.isLockScreen = NO;
    [self.controlView mediaPlayerCancelAutoFadeOutControlView];
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

#pragma -mark 网络状态变化
-(void)setNetWorkStatus:(ZXNetWorkStatus)netWorkStatus{
    _netWorkStatus = netWorkStatus;
    if ([self.delegate respondsToSelector:@selector(networkChangeTo:)]) {
        [self.delegate networkChangeTo:netWorkStatus];
    }
}

#pragma mark - 观察者、通知

/**
 *  添加观察者、通知
 */
- (void)addNotifications {
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayground) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    if (_allowAutoRotate) {
        // 监测设备方向
        [self addRotationNotifications];
    }
}

- (void)addRotationNotifications {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onStatusBarOrientationChange)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    [self.controlView listeningRotating];
}

- (void)removeRotationNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

#pragma -mark 设置自动旋转
- (void)setAllowAutoRotate:(BOOL)allowAutoRotate {
    if (_allowAutoRotate != allowAutoRotate) {
        _allowAutoRotate = allowAutoRotate;
    }
}

#pragma -mark 获取系统音量
/**
 *  获取系统音量
 */
- (void)configureVolume {
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    _volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    
    // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
    NSError *setCategoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance]
                    setCategory: AVAudioSessionCategoryPlayback
                    error: &setCategoryError];
    
    if (!success) { /* handle the error in setCategoryError */ }
    
    // 监听耳机插入和拔掉通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];
}

/**
 *  耳机插入、拔出事件
 */
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
            
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            // 耳机插入
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            // 耳机拔掉
            // 拔掉耳机继续播放
            [self play];
        }
            break;
            
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}

/**
 *  锁定屏幕方向按钮
 *
 *  @param sender UIButton
 */
- (void)lockScreenAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.isLocked = sender.selected;
    // 调用AppDelegate单例记录播放状态是否锁屏，在TabBarController设置哪些页面支持旋转
    MediaPlayerShared.isLockScreen = sender.selected;
}

/**
 *  解锁屏幕方向锁定
 */
- (void)unLockTheScreen {
    // 调用AppDelegate单例记录播放状态是否锁屏
    MediaPlayerShared.isLockScreen = NO;
    [self.controlView mediaPlayerLockBtnState:NO];
    self.isLocked = NO;
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
}

-(BOOL)checkPlayUrl:(NSString*)playUrl {
    if (self.mediaPlayerType == MediaPlayerType_VOD) {
        if ([playUrl hasPrefix:@"https:"] || [playUrl hasPrefix:@"http:"]) {
            if ([playUrl rangeOfString:@".flv"].length > 0) {
                
            } else if ([playUrl rangeOfString:@".m3u8"].length > 0){
                
            } else if ([playUrl rangeOfString:@".mp4"].length > 0){
                
            } else {
                [self toastTip:@"播放地址不合法，点播目前仅支持flv,hls,mp4播放方式!"];
                return NO;
            }
        }
    }else if (self.mediaPlayerType == MediaPlayerType_LIVE){
        if ([playUrl hasPrefix:@"rtmp:"]) {
            self.livePlayType = PLAY_TYPE_LIVE_RTMP;
            if ([playUrl containsString:@"txSecret="]) {
                self.livePlayType = PLAY_TYPE_LIVE_RTMP_ACC;
            }
//            else if (self.isRealtime) {
//                [self toastTip:@"播放地址非合法的低延时播放地址!"];
//            }
        } else if (([playUrl hasPrefix:@"https:"] || [playUrl hasPrefix:@"http:"]) && [playUrl rangeOfString:@".flv"].length > 0) {
            self.livePlayType = PLAY_TYPE_LIVE_FLV;
        } else{
            [self toastTip:@"播放地址不合法，直播目前仅支持rtmp,flv播放方式!"];
            return NO;
        }
    }

    
    return YES;
}

-(BOOL)startVodPlayer{
    [self.controlView mediaPlayerActivity:YES];

    self.txVodPlayer.vodDelegate = self;
    if (_txVodConfig == nil)
    {
        _txVodConfig = [[TXVodPlayConfig alloc] init];
    }

    [self.txVodPlayer setConfig:_txVodConfig];
    
    int result = [self.txVodPlayer startPlay:self.playUrl];
    if( result != 0)
    {
        NSLog(@"播放器启动失败");
        return NO;
    }
    [self.txVodPlayer setRenderMode:RENDER_MODE_FILL_EDGE];

    return YES;
}

-(BOOL)startLivePlayer{
    [self.controlView mediaPlayerActivity:YES];

    self.txLivePlayer.delegate = self;
    [self.txLivePlayer setupVideoWidget:CGRectZero containView:self insertIndex:0];

    if (_txLiveConfig == nil)
    {
        _txLiveConfig = [[TXLivePlayConfig alloc] init];
    }

    _txLiveConfig.playerPixelFormatType = kCVPixelFormatType_420YpCbCr8BiPlanarFullRange;
    
    [self.txLivePlayer setConfig:_txLiveConfig];
    
    int result = [self.txLivePlayer startPlay:self.playUrl type:self.livePlayType];
    if( result != 0)
    {
        NSLog(@"播放器启动失败");
        return NO;
    }
    [self.txLivePlayer setRenderMode:RENDER_MODE_FILL_EDGE];
    
    return YES;
}

-(void)configControlView{
    self.state = MediaPlayerStatePlaying;
    
    // 显示控制层
    [self.controlView mediaPlayerCancelAutoFadeOutControlView];
    [self.controlView mediaPlayerShowControlView];
    
}

/** 停止播放 */
-(void)stopMediaPlayer{
    [self.controlView mediaPlayerActivity:NO];
    [self.controlView mediaPlayerResetControlView];
    switch (self.mediaPlayerType) {
        case MediaPlayerType_VOD:
            if(_txVodPlayer != nil)
            {
                [_txVodPlayer stopPlay];
                [_txVodPlayer removeVideoWidget];
                _txVodPlayer.vodDelegate = nil;
            }
            break;
        case MediaPlayerType_LIVE:
            if(_txLivePlayer != nil)
            {
                [_txLivePlayer stopPlay];
                [_txLivePlayer removeVideoWidget];
                _txLivePlayer.delegate = nil;
            }
            break;
        default:
            break;
    }
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:nil];

}

/**
 *  设置播放的状态
 *
 *  @param state MediaPlayerState
 */
- (void)setState:(MediaPlayerState)state {
    _state = state;
    // 控制菊花显示、隐藏
    if (state == MediaPlayerStatePlaying || state == MediaPlayerStateBuffering) {
        // 隐藏占位图
        [self.controlView mediaPlayerItemPlaying];
    } else if (state == MediaPlayerStateFailed) {
        NSError *error = [NSError new];
        [self.controlView mediaPlayerItemStatusFailed:error];
    }
}

-(void)play{
    [self.controlView mediaPlayerPlayBtnState:YES];

    if (self.state == MediaPlayerStatePause) {
        self.state = MediaPlayerStatePlaying;
    }
    
    [self.controlView mediaPlayerPlayBtnState:YES];
    
    switch (self.mediaPlayerType) {
        case MediaPlayerType_VOD:
            if (_txVodPlayer == nil) {
                [self playTheVideo];
            }else{
                [self.txVodPlayer resume];
            }
            break;
        case MediaPlayerType_LIVE:
            if (_txLivePlayer == nil) {
                [self playTheVideo];
            }else{
                [self.txLivePlayer resume];
            }
            break;
            
        default:
            break;
    }
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    self.isPauseByUser = NO;
    // 显示控制层
    [self.controlView mediaPlayerCancelAutoFadeOutControlView];
    [self.controlView mediaPlayerShowControlView];
}

-(void)pause
{
    [self.controlView mediaPlayerPlayBtnState:NO];
    if (self.state == MediaPlayerStatePlaying) {
        self.state = MediaPlayerStatePause;
    }
    switch (self.mediaPlayerType) {
        case MediaPlayerType_VOD:
            [self.txVodPlayer pause];
            break;
        case MediaPlayerType_LIVE:
            [self.txLivePlayer pause];
            break;
        default:
            break;
    }
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    [self recoverTheBackgroundMusic];

}

-(void)clearPlay{
    [self stopMediaPlayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self recoverTheBackgroundMusic];

}

-(void)resetPlayer
{
    // 改为播放完
    self.playDidEnd         = NO;
    self.didEnterBackground = NO;
    // 视频跳转秒数置0
    self.seekTime           = 0;
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 暂停
    [self pause];

    [self.controlView mediaPlayerResetControlView];
    
}

//恢复后台第三方播放
-(void)recoverTheBackgroundMusic
{
    @try {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //恢复后台被中断的音频播放
            [[AVAudioSession sharedInstance]setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
        });

    } @catch (NSException *exception) {
        
    }
    
}

/**
 *  创建手势
 */
- (void)createGesture {
    // 单击
    self.singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
    self.singleTap.delegate = self;
    self.singleTap.numberOfTouchesRequired = 1; //手指数
    self.singleTap.numberOfTapsRequired    = 1;
    [self addGestureRecognizer:self.singleTap];
    
    // 双击(播放/暂停)
    self.doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
    self.doubleTap.delegate = self;
    self.doubleTap.numberOfTouchesRequired = 1; //手指数
    self.doubleTap.numberOfTapsRequired = 2;
    
    [self addGestureRecognizer:self.doubleTap];
    
    // 解决点击当前view时候响应其他控件事件
    [self.singleTap setDelaysTouchesBegan:YES];
    [self.doubleTap setDelaysTouchesBegan:YES];
    // 双击失败响应单击事件
    [self.singleTap requireGestureRecognizerToFail:self.doubleTap];
}

#pragma -mark 前后台切换
/** 应用退到后台 */
- (void)appDidEnterBackground {
    self.didEnterBackground     = YES;
    // 退到后台锁定屏幕方向
    MediaPlayerShared.isLockScreen = YES;
    
    [self.controlView mediaPlayerPlayBtnState:NO];
    if (self.state == MediaPlayerStatePlaying) {
        self.state = MediaPlayerStatePause;
    }
    
    [self pause];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

/** 应用进入前台 */
- (void)appDidEnterPlayground {
    self.didEnterBackground     = NO;
    // 根据是否锁定屏幕方向 来恢复单例里锁定屏幕的方向
    MediaPlayerShared.isLockScreen = self.isLocked;
    if (!self.isPauseByUser) {
        self.state = MediaPlayerStatePlaying;
        self.isPauseByUser = NO;
        [self play];
    }
}

#pragma mark 屏幕转屏相关
/**
 *  设置横屏的约束
 */
- (void)setOrientationLandscapeConstraint:(UIInterfaceOrientation)orientation {
    [self toOrientation:orientation];
    self.isFullScreen = YES;
    MediaPlayerShared.isStatusBarHidden = NO;
}

/**
 *  设置竖屏的约束
 */
- (void)setOrientationPortraitConstraint {
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    [UIView animateWithDuration:0.3 animations:^{
        // 更改了状态条的方向,但是设备方向UIInterfaceOrientation还是正方向的,这就要设置给你播放视频的视图的方向设置旋转
        // 给播放视频的view视图设置旋转
        self.transform = CGAffineTransformIdentity;
        self.transform = [self getTransformRotationAngle];
        
        [self addPlayerToFatherView:self.playerModel.fatherView];

    } completion:^(BOOL finished) {
        [self.controlView setNeedsLayout];
        [self.controlView layoutIfNeeded];
    }];
    
    self.isFullScreen = NO;
    MediaPlayerShared.isStatusBarHidden = YES;
}

- (void)toOrientation:(UIInterfaceOrientation)orientation {
    // 获取到当前状态条的方向
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    // 判断如果当前方向和要旋转的方向一致,那么不做任何操作
    if (currentOrientation == orientation) { return; }
    
    // 根据要旋转的方向,使用Masonry重新修改限制
    if (orientation != UIInterfaceOrientationPortrait) {//
        // 这个地方加判断是为了从全屏的一侧,直接到全屏的另一侧不用修改限制,否则会出错;
        if (currentOrientation == UIInterfaceOrientationPortrait) {
            
            [self removeFromSuperview];
            ZXBrightnessView *brightnessView = [ZXBrightnessView sharedBrightnessView];
            [[UIApplication sharedApplication].keyWindow.rootViewController.view insertSubview:self belowSubview:brightnessView];
            [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(kMediaPlayerScreenHeight));
                make.height.equalTo(@(kMediaPlayerScreenWidth));
                make.center.equalTo([UIApplication sharedApplication].keyWindow);
            }];
        }
    }
    // iOS6.0之后,设置状态条的方法能使用的前提是shouldAutorotate为NO,也就是说这个视图控制器内,旋转要关掉;
    // 也就是说在实现这个方法的时候-(BOOL)shouldAutorotate返回值要为NO
    [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
    [UIView animateWithDuration:0.3 animations:^{
        // 更改了状态条的方向,但是设备方向UIInterfaceOrientation还是正方向的,这就要设置给你播放视频的视图的方向设置旋转
        // 给你的播放视频的view视图设置旋转
        self.transform = CGAffineTransformIdentity;
        self.transform = [self getTransformRotationAngle];

    } completion:^(BOOL finished) {
        [self.controlView setNeedsLayout];
        [self.controlView layoutIfNeeded];
    }];

}

/**
 * 获取变换的旋转角度
 *
 * @return 角度
 */
- (CGAffineTransform)getTransformRotationAngle {
    // 状态条的方向已经设置过,所以这个就是你想要旋转的方向
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    // 根据要进行旋转的方向来计算旋转的角度
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft){
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if(orientation == UIInterfaceOrientationLandscapeRight){
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    return CGAffineTransformIdentity;
}


/**
 *  屏幕转屏
 *
 *  @param orientation 屏幕方向
 */
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) {
        // 设置横屏
        [self setOrientationLandscapeConstraint:orientation];
    } else if (orientation == UIInterfaceOrientationPortrait) {
        // 设置竖屏
        [self setOrientationPortraitConstraint];
    }
}

/**
 *  屏幕方向发生变化会调用这里
 */
- (void)onDeviceOrientationChange {
    if (self.mediaPlayerType == MediaPlayerType_VOD) {
        if (!_txVodPlayer) {
            return;
        }
    }else if (self.mediaPlayerType == MediaPlayerType_LIVE){
        if (!_txLivePlayer) {
            return;
        }
    }

    if (MediaPlayerShared.isLockScreen) {
        return;
    }
    if (self.didEnterBackground) {
        return;
    }
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown ) {
        return;
    }
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
        }
            break;
        case UIInterfaceOrientationPortrait:{
            if (self.isFullScreen) {
                [self toOrientation:UIInterfaceOrientationPortrait];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            if (self.isFullScreen == NO) {
                [self toOrientation:UIInterfaceOrientationLandscapeLeft];
                self.isFullScreen = YES;
                MediaPlayerShared.isStatusBarHidden = NO;
            } else {
                [self toOrientation:UIInterfaceOrientationLandscapeLeft];
            }
            
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            if (self.isFullScreen == NO) {
                [self toOrientation:UIInterfaceOrientationLandscapeRight];
                self.isFullScreen = YES;
                MediaPlayerShared.isStatusBarHidden = NO;
            } else {
                [self toOrientation:UIInterfaceOrientationLandscapeRight];
            }
        }
            break;
        default:
            break;
    }
}

// 状态条变化通知（在前台播放才去处理）
- (void)onStatusBarOrientationChange {
    if (!self.didEnterBackground) {
        // 获取到当前状态条的方向
        UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if (currentOrientation == UIInterfaceOrientationPortrait) {
            [self setOrientationPortraitConstraint];

            [self.brightnessView removeFromSuperview];
            [[UIApplication sharedApplication].keyWindow addSubview:self.brightnessView];
            [self.brightnessView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(155);
                make.leading.mas_equalTo((kMediaPlayerScreenWidth-155)/2);
                make.top.mas_equalTo((kMediaPlayerScreenHeight-155)/2);
            }];
        } else {
            if (currentOrientation == UIInterfaceOrientationLandscapeRight) {
                [self toOrientation:UIInterfaceOrientationLandscapeRight];
            } else if (currentOrientation == UIDeviceOrientationLandscapeLeft){
                [self toOrientation:UIInterfaceOrientationLandscapeLeft];
            }
            [self.brightnessView removeFromSuperview];
            [self addSubview:self.brightnessView];
            [self.brightnessView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self);
                make.width.height.mas_equalTo(155);
            }];
            
        }
    }
}

#pragma mark - UIPanGestureRecognizer手势方法

/**
 *  pan手势事件
 *
 *  @param pan UIPanGestureRecognizer
 */
- (void)panDirection:(UIPanGestureRecognizer *)pan {
    //根据在view上Pan的位置，确定是调音量还是亮度
    CGPoint locationPoint = [pan locationInView:self];
    
    // 我们要响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pan velocityInView:self];
    
    // 判断是垂直移动还是水平移动
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) { // 水平移动
                // 取消隐藏
                self.panDirection = PanDirectionHorizontalMoved;
                // 给sumTime初值
                self.sumTime = self.txVodPlayer.currentPlaybackTime;
            }
            else if (x < y){ // 垂直移动
                self.panDirection = PanDirectionVerticalMoved;
                // 开始滑动的时候,状态改为正在控制音量
                if (locationPoint.x > self.bounds.size.width / 2) {
                    self.isVolume = YES;
                }else { // 状态改为显示亮度调节
                    self.isVolume = NO;
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 正在移动
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    if (self.mediaPlayerType == MediaPlayerType_VOD) {
                        [self horizontalMoved:veloctyPoint.x]; // 水平移动的方法只要x方向的值
                    }
                    break;
                }
                case PanDirectionVerticalMoved:{
                    [self verticalMoved:veloctyPoint.y]; // 垂直移动方法只要y方向的值
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    if (self.mediaPlayerType == MediaPlayerType_VOD) {
                        self.isPauseByUser = NO;
                        [self.txVodPlayer seek:self.sumTime];
                        
                        // 结束滑动
                        [self.controlView mediaPlayerDraggedEnded];
                        
                        // 把sumTime滞空，不然会越加越多
                        self.sumTime = 0;

                    }
                    break;
                }
                case PanDirectionVerticalMoved:{
                    // 垂直移动结束后，把状态改为不再控制音量
                    self.isVolume = NO;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

/**
 *  pan垂直移动的方法
 *
 *  @param value void
 */
- (void)verticalMoved:(CGFloat)value {
    self.isVolume ? (self.volumeViewSlider.value -= value / 10000) : ([UIScreen mainScreen].brightness -= value / 10000);
}

/**
 *  pan水平移动的方法
 *
 *  @param value void
 */
- (void)horizontalMoved:(CGFloat)value {
    // 每次滑动需要叠加时间
    self.sumTime += value / 200;
    
    // 需要限定sumTime的范围
    float totalTime = self.txVodPlayer.duration;
    if (self.sumTime > totalTime) { self.sumTime = totalTime;}
    if (self.sumTime < 0) { self.sumTime = 0; }
    
    BOOL style = false;
    if (value > 0) { style = YES; }
    if (value < 0) { style = NO; }
    if (value == 0) { return; }
    
    self.isDragged = YES;
    [self.controlView mediaPlayerDraggedTime:self.sumTime totalTime:totalTime isForward:style hasPreview:NO];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        if (self.playDidEnd || self.isLocked){
            
            return NO;
        }
    }
//    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
//        if (!self.isFullScreen) {
//            return NO;
//        }
//    }
    if ([touch.view isKindOfClass:[UISlider class]]) {
        return NO;
    }
    
    return YES;
}
#pragma mark - Action

/**
 *   轻拍方法
 *
 *  @param gesture UITapGestureRecognizer
 */
- (void)singleTapAction:(UIGestureRecognizer *)gesture {
    if ([gesture isKindOfClass:[NSNumber class]] && ![(id)gesture boolValue]) {
        [self fullScreenAction];
        return;
    }
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        if (self.playDidEnd) {
            return;
        }else {
            [self.controlView mediaPlayerShowControlView];
            
        }
    }
}

/**
 *  双击播放/暂停
 *
 *  @param gesture UITapGestureRecognizer
 */
- (void)doubleTapAction:(UIGestureRecognizer *)gesture {
    if (self.playDidEnd) {
        return;
    }
    // 显示控制层
    [self.controlView mediaPlayerCancelAutoFadeOutControlView];
    [self.controlView mediaPlayerShowControlView];
    if (self.isPauseByUser) {
        [self play];
    }else {
        [self pause];
        
    }
}

/** 全屏 */
- (void)fullScreenAction {
    if (MediaPlayerShared.isLockScreen) {
        [self unLockTheScreen];
        return;
    }
    if (self.isFullScreen) {
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
        self.isFullScreen = NO;
        MediaPlayerShared.isStatusBarHidden = YES;
        if (MediaPlayerType_LIVE == self.mediaPlayerType) {
            [self.txLivePlayer setRenderRotation:HOME_ORIENTATION_DOWN];
        }else{
            [self.txVodPlayer setRenderRotation:HOME_ORIENTATION_DOWN];
        }
        return;
    } else {

        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation == UIDeviceOrientationLandscapeRight) {
            [self interfaceOrientation:UIInterfaceOrientationLandscapeLeft];
        } else {
            [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
        }
        self.isFullScreen = YES;
        MediaPlayerShared.isStatusBarHidden = NO;
    }
}

#pragma mark - DQChangeAngleViewDelegate
-(void)closeChangeAngleView:(MediaPlayerState)state{
    if (state == MediaPlayerStatePlaying) {
        [self play];
    }
}

-(void)changeAngle:(UIButton *)button angleType:(AngleType)angleType{
    self.angleType = angleType;
    
    [self play];
}

#pragma mark - MediaPlayerControlViewDelegate
- (void)playerControlView:(ZXMediaPlayerControlView *)controlView playAction:(UIButton *)sender {
    if (self.state == MediaPlayerStatePlaying) {
        [self pause];
        self.isPauseByUser = YES;
        
    } else {
        [self play];
        if (self.state == MediaPlayerStatePause) {
            self.state = MediaPlayerStatePlaying;
        }
    }
    
}

- (void)playerControlView:(ZXMediaPlayerControlView *)controlView backAction:(UIButton *)sender {
    if (MediaPlayerShared.isLockScreen) {
        [self unLockTheScreen];
    } else {
        if (!self.isFullScreen) {
            // player加到控制器上，只有一个player时候
            [self pause];
            if ([self.delegate respondsToSelector:@selector(mediaPlayerBackAction)]) {
                [self.delegate mediaPlayerBackAction];
            }
        } else {
            [self interfaceOrientation:UIInterfaceOrientationPortrait];
        }
    }
}

- (void)playerControlView:(ZXMediaPlayerControlView *)controlView closeAction:(UIButton *)sender {
    [self resetPlayer];
    [self removeFromSuperview];
}

- (void)playerControlView:(ZXMediaPlayerControlView *)controlView fullScreenAction:(UIButton *)sender {
    if (MediaPlayerType_LIVE == self.mediaPlayerType) {
        if (NO == self.txLivePlayer.isPlaying) {
            return;
        }
    }else{
        if (NO == self.txVodPlayer.isPlaying) {
            return;
        }
    }
    sender.selected = !sender.selected;
    [self fullScreenAction];
}

- (void)playerControlView:(ZXMediaPlayerControlView *)controlView lockScreenAction:(UIButton *)sender {
    self.isLocked               = sender.selected;
    // 调用AppDelegate单例记录播放状态是否锁屏
    MediaPlayerShared.isLockScreen = sender.selected;
}

- (void)playerControlView:(ZXMediaPlayerControlView *)controlView centerPlayAction:(UIButton *)sender {
//    [self configMediaPlayer];
}

- (void)playerControlView:(ZXMediaPlayerControlView *)controlView repeatPlayAction:(UIButton *)sender {
    // 没有播放完
    self.playDidEnd   = NO;
    
    [self play];

}

/** 加载失败按钮事件 */
- (void)playerControlView:(ZXMediaPlayerControlView *)controlView failAction:(UIButton *)sender {
    [self playTheVideo];
}

- (void)playerControlView:(ZXMediaPlayerControlView *)controlView resolutionAction:(UIButton *)sender {
//    // 记录切换分辨率的时刻
//    NSInteger currentTime = (NSInteger)CMTimeGetSeconds([self.player currentTime]);
//    NSString *videoStr = self.videoURLArray[sender.tag - 200];
//    NSURL *videoURL = [NSURL URLWithString:videoStr];
//    if ([videoURL isEqual:self.videoURL]) { return; }
//    self.isChangeResolution = YES;
//    // reset player
//    [self resetToPlayNewURL];
//    self.videoURL = videoURL;
//    // 从xx秒播放
//    self.seekTime = currentTime;
//    // 切换完分辨率自动播放
//    [self playTheVideo];
}

- (void)playerControlView:(ZXMediaPlayerControlView *)controlView moreAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(mediaPlayerMoreAction)]) {
        [self.delegate mediaPlayerMoreAction];
    }
}

- (void)playerControlView:(ZXMediaPlayerControlView *)controlView progressSliderTap:(CGFloat)value {
    
    NSInteger dragedSeconds = floorf(self.txVodPlayer.duration*value);
    
    [self.controlView mediaPlayerPlayBtnState:YES];
    
    self.isDragged = NO;
    
    [self.txVodPlayer seek:dragedSeconds];
    
    [self.controlView mediaPlayerDraggedEnd];

}

- (void)playerControlView:(ZXMediaPlayerControlView *)controlView progressSliderValueChanged:(UISlider *)slider {
    
    self.isDragged = YES;
    BOOL style = false;
    CGFloat value   = slider.value - self.sliderLastValue;
    if (value > 0) { style = YES; }
    if (value < 0) { style = NO; }
    if (value == 0) { return; }
    
    self.sliderLastValue  = slider.value;
    

    
    NSInteger dragedSeconds = floorf(self.txVodPlayer.duration*slider.value);
    
    [controlView mediaPlayerDraggedTime:dragedSeconds totalTime:self.txVodPlayer.duration isForward:style hasPreview:self.isFullScreen ? self.hasPreviewView : NO];

    [self.txVodPlayer snapshot:^(UIImage *img) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [controlView mediaPlayerDraggedTime:dragedSeconds sliderImage:img ? : MediaPlayerImage(@"MediaPlayer_loading_bgView")];
        });
    }];
    
}

- (void)playerControlView:(ZXMediaPlayerControlView *)controlView progressSliderTouchEnded:(UISlider *)slider {
    self.isPauseByUser = NO;
    self.isDragged = NO;
    
    _sliderValue = slider.value;
    [self.txVodPlayer seek:self.txVodPlayer.duration*_sliderValue];
    
    [self.controlView mediaPlayerDraggedEnd];
    
    self.playDidEnd = NO;
}

-(void)playerControlView:(ZXMediaPlayerControlView *)controlView changeAngleAction:(UIButton *)sender
{
    if (self.isFullScreen) {
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
    }
    
    sender.enabled = NO;
    DQChangeAngleView *changeAngleView = [DQChangeAngleView shared];
    changeAngleView.gameModel = self.gameModel;
    
    changeAngleView.delegate = self;
    changeAngleView.state = self.state;
    
    if (_state == MediaPlayerStatePlaying) {
        [self pause];
    }

    [changeAngleView showInView:self.rootViewController.view mediaPlayView:self angleType:self.angleType];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    
}

#pragma - mark 点播事件通知
-(void) onPlayEvent:(TXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary*)param
{
    NSDictionary* dict = param;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (EvtID == PLAY_EVT_RCV_FIRST_I_FRAME) {
            
            [self.txVodPlayer setupVideoWidget:self insertIndex:0];
            
            [self addNotifications];
            // 获取系统音量
            [self configureVolume];
            //配置控制UI
            [self configControlView];
        }
        
        if (EvtID == PLAY_EVT_PLAY_BEGIN) {
            [self.controlView mediaPlayerActivity:NO];
            
            [self.controlView mediaPlayerPlayBtnState:YES];
            
            // 添加手势
            [self createGesture];

            // 加载完成后，再添加平移手势
            // 添加平移手势，用来控制音量、亮度（上下方向）和快进快退(左右方向)
            UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
            panRecognizer.delegate = self;
            [panRecognizer setMaximumNumberOfTouches:1];
            [panRecognizer setDelaysTouchesBegan:YES];
            [panRecognizer setDelaysTouchesEnded:YES];
            [panRecognizer setCancelsTouchesInView:YES];
            [self addGestureRecognizer:panRecognizer];
            
        } else if (EvtID == PLAY_EVT_PLAY_PROGRESS) {

            float progress = [dict[EVT_PLAY_PROGRESS] floatValue];
            float duration = [dict[EVT_PLAY_DURATION] floatValue];
            float playAbleProgress = [dict[EVT_PLAYABLE_DURATION] floatValue];

            [self.controlView mediaPlayerSetProgress:playAbleProgress/duration];

            [self.controlView mediaPlayerCurrentTime:progress totalTime:duration sliderValue:progress/duration];
            
            [self.controlView mediaPlayerDraggedEnded];


        } else if (EvtID == PLAY_ERR_NET_DISCONNECT || EvtID == PLAY_EVT_PLAY_END || EvtID == PLAY_ERR_FILE_NOT_FOUND || EvtID == PLAY_ERR_HLS_KEY) {
            self.state = MediaPlayerStateFailed;

            if (!self.isFullScreen) { // 播放完了，如果是在小屏模式
                self.playDidEnd   = YES;
                [self resetPlayer];
                [self.controlView mediaPlayerPlayEnd];
            } else {
                [self unLockTheScreen];
                if (!self.isDragged) { // 如果不是拖拽中，直接结束播放
                    [self interfaceOrientation:UIInterfaceOrientationPortrait];
                    self.isFullScreen = NO;
                    MediaPlayerShared.isStatusBarHidden = YES;
                    [self.txVodPlayer setRenderRotation:HOME_ORIENTATION_DOWN];
                
                    self.playDidEnd   = YES;
                    [self resetPlayer];
                    [self.controlView mediaPlayerPlayEnd];
                    return;
                }
            }

            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            
            if (EvtID == PLAY_ERR_NET_DISCONNECT) {
                
                NSString* Msg = (NSString*)[dict valueForKey:EVT_MSG];
                [self toastTip:Msg];
                
                ZXNetWorkStatus status = (ZXNetWorkStatus)[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
                if (status == ZXNetWorkStatus_Wifi || status == ZXNetWorkStatus_WWAN) {
                    [self.controlView mediaPlayerActivity:NO];
                    self.state = MediaPlayerStateFailed;
                }else{
                    if ([self.delegate respondsToSelector:@selector(networkChangeTo:)]) {
                        [self clearPlay];
                        [self.controlView mediaPlayerDisconnect];
                        self.alpha = 0;
                        [self.delegate networkChangeTo:ZXNetWorkStatus_Unknown];
                    }
                }

            }
            
        } else if (EvtID == PLAY_EVT_PLAY_LOADING){
            [self.controlView mediaPlayerActivity:YES];

        }
        else if (EvtID == PLAY_EVT_CONNECT_SUCC) {
            BOOL isWifi = [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
            if (!isWifi) {
                __weak __typeof(self) weakSelf = self;
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"您要切换到Wifi再观看吗?" preferredStyle:UIAlertControllerStyleAlert];
                __weak __typeof(alert) weakAlert = alert;
                [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                    if (weakSelf.playUrl.length == 0) {
                        return;
                    }
                    if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
                        [weakAlert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [weakAlert dismissViewControllerAnimated:YES completion:nil];
                            [weakSelf stopMediaPlayer];
                            [weakSelf playTheVideo];
                        }]];
                        [weakAlert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            [weakAlert dismissViewControllerAnimated:YES completion:nil];
                        }]];
                        [weakSelf.rootViewController presentViewController:weakAlert animated:YES completion:nil];
                    }
                }];
            }
        }

    });
}

-(void) onNetStatus:(TXVodPlayer *)player withParam:(NSDictionary*) param
{
    NSLog(@"onNetStatus %@", player);
    
    NSDictionary* dict = param;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        int netspeed  = [(NSNumber*)[dict valueForKey:NET_STATUS_NET_SPEED] intValue];
        int vbitrate  = [(NSNumber*)[dict valueForKey:NET_STATUS_VIDEO_BITRATE] intValue];
        int abitrate  = [(NSNumber*)[dict valueForKey:NET_STATUS_AUDIO_BITRATE] intValue];
        int cachesize = [(NSNumber*)[dict valueForKey:NET_STATUS_CACHE_SIZE] intValue];
        int dropsize  = [(NSNumber*)[dict valueForKey:NET_STATUS_DROP_SIZE] intValue];
        int jitter    = [(NSNumber*)[dict valueForKey:NET_STATUS_NET_JITTER] intValue];
        int fps       = [(NSNumber*)[dict valueForKey:NET_STATUS_VIDEO_FPS] intValue];
        int width     = [(NSNumber*)[dict valueForKey:NET_STATUS_VIDEO_WIDTH] intValue];
        int height    = [(NSNumber*)[dict valueForKey:NET_STATUS_VIDEO_HEIGHT] intValue];
        float cpu_usage = [(NSNumber*)[dict valueForKey:NET_STATUS_CPU_USAGE] floatValue];
        float cpu_app_usage = [(NSNumber*)[dict valueForKey:NET_STATUS_CPU_USAGE_D] floatValue];
        NSString *serverIP = [dict valueForKey:NET_STATUS_SERVER_IP];
        int codecCacheSize = [(NSNumber*)[dict valueForKey:NET_STATUS_CODEC_CACHE] intValue];
        int nCodecDropCnt = [(NSNumber*)[dict valueForKey:NET_STATUS_CODEC_DROP_CNT] intValue];
        int nCahcedSize = [(NSNumber*)[dict valueForKey:NET_STATUS_CACHE_SIZE] intValue]/1000;
        
        NSString* log = [NSString stringWithFormat:@"CPU:%.1f%%|%.1f%%\tRES:%d*%d\tSPD:%dkb/s\nJITT:%d\tFPS:%d\tARA:%dkb/s\nQUE:%d|%d\tDRP:%d|%d\tVRA:%dkb/s\nSVR:%@\t\tCAH:%d kb",
                         cpu_app_usage*100,
                         cpu_usage*100,
                         width,
                         height,
                         netspeed,
                         jitter,
                         fps,
                         abitrate,
                         codecCacheSize,
                         cachesize,
                         nCodecDropCnt,
                         dropsize,
                         vbitrate,
                         serverIP,
                         nCahcedSize];
//        [_statusView setText:log];
//        AppDemoLogOnlyFile(@"Current status, VideoBitrate:%d, AudioBitrate:%d, FPS:%d, RES:%d*%d, netspeed:%d", vbitrate, abitrate, fps, width, height, netspeed);
    });
}

#pragma -mark TXLivePlayListener
-(void) onPlayEvent:(int)EvtID withParam:(NSDictionary*)param{
    if (EvtID == PLAY_EVT_RCV_FIRST_I_FRAME) {
        if (self.mediaPlayerType != MediaPlayerType_LIVE) {
            [self.txLivePlayer setupVideoWidget:CGRectZero containView:self insertIndex:0];

        }
        // 获取系统音量
        [self configureVolume];
        //配置控制UI
        [self configControlView];
        [self addNotifications];

    }
    
    if (EvtID == PLAY_EVT_PLAY_BEGIN) {
        
        [self.controlView mediaPlayerActivity:NO];
        
        [self.controlView mediaPlayerPlayBtnState:YES];
        
        // 添加手势
        [self createGesture];
        // 加载完成后，再添加平移手势
        // 添加平移手势，用来控制音量、亮度（上下方向）和快进快退(左右方向)
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
        panRecognizer.delegate = self;
        [panRecognizer setMaximumNumberOfTouches:1];
        [panRecognizer setDelaysTouchesBegan:YES];
        [panRecognizer setDelaysTouchesEnded:YES];
        [panRecognizer setCancelsTouchesInView:YES];
        [self addGestureRecognizer:panRecognizer];
    } else if (EvtID == PLAY_EVT_PLAY_PROGRESS) {
        [self.controlView mediaPlayerActivity:NO];

    }
}

/**
 @method 获取指定宽度width的字符串在UITextView上的高度
 @param textView 待计算的UITextView
 @param width 限制字符串显示区域的宽度
 @result float 返回的高度
 */
- (float) heightForString:(UITextView *)textView andWidth:(float)width{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

- (void) toastTip:(NSString*)toastInfo
{
    CGRect frameRC = [[UIScreen mainScreen] bounds];
    frameRC.origin.y = frameRC.size.height - 110;
    frameRC.size.height -= 110;
    __block UITextView * toastView = [[UITextView alloc] init];
    
    toastView.editable = NO;
    toastView.selectable = NO;
    
    frameRC.size.height = [self heightForString:toastView andWidth:frameRC.size.width];
    
    toastView.frame = frameRC;
    
    toastView.text = toastInfo;
    toastView.backgroundColor = [UIColor whiteColor];
    toastView.alpha = 0.5;
    
    [self addSubview:toastView];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(){
        [toastView removeFromSuperview];
        toastView = nil;
    });
}

- (BOOL)onPlayerPixelBuffer:(CVPixelBufferRef)pixelBuffer;
{
    return NO;
}

- (ZXBrightnessView *)brightnessView {
    if (!_brightnessView) {
        _brightnessView = [ZXBrightnessView sharedBrightnessView];
    }
    return _brightnessView;
}
@end
