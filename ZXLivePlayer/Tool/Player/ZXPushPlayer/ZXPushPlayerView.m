//
//  ZXPushPlayerView.m
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/3/29.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "ZXPushPlayerView.h"
#import <TXLiteAVSDK_Professional/TXLivePush.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AFNetworking.h>

#import "ZXPushControlView.h"

@interface ZXPushPlayerView()<TXLivePushListener,ZXPushControlViewDelegate>
/** 推流实例 */
@property (nonatomic, strong) TXLivePush *txLivePush;
@property (nonatomic, strong) TXLivePushConfig *txLivePushConfig;


@property (strong, nonatomic) ZXPushControlView *controlView;
@property (nonatomic, strong) ZXMediaPlayerModel *playerModel;

@end

@implementation ZXPushPlayerView
+ (instancetype)shared{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (void)playerModel:(ZXMediaPlayerModel *)playerModel {
    // 指定默认控制层
    self.playerModel = playerModel;
}

- (void)setControlView:(ZXPushControlView *)controlView {
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
    
    NSCAssert(playerModel.fatherView, @"请指定playerView的faterView");
    [self addPlayerToFatherView:playerModel.fatherView];
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

#pragma -mark - 提示框
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

#pragma -mark - 开始推流
-(void)startRtmp{
    NSString *rtmpUrl = self.pushUrl;
    if (!([rtmpUrl hasPrefix:@"rtmp://"])) {
        rtmpUrl = @"rtmp://3891.livepush.myqcloud.com/live/3891_user_bea5056c_0a23?bizid=3891&txSecret=b44be37a13dffafeca8960a446eecfd3&txTime=5AC6E64E";
    }
    if (!([rtmpUrl hasPrefix:@"rtmp://"])) {
        [self toastTip:@"推流地址不合法，目前支持rtmp推流!"];
        return;
    }
    
    //是否有摄像头权限
    AVAuthorizationStatus statusVideo = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (statusVideo == AVAuthorizationStatusDenied) {
        [self toastTip:@"获取摄像头权限失败，请前往隐私-相机设置里面打开应用权限"];
        return;
    }
    
    //是否有麦克风权限
    AVAuthorizationStatus statusAudio = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (statusAudio == AVAuthorizationStatusDenied) {
        [self toastTip:@"获取麦克风权限失败，请前往隐私-麦克风设置里面打开应用权限"];
        return;
    }
    
    TXLivePushConfig *_config = self.txLivePush.config;
    
    _config.pauseFps = 10;
    _config.pauseTime = 300;
    _config.pauseImg = [UIImage imageNamed:@"pause_publish"];
    [self.txLivePush setConfig:_config];
    
    self.txLivePush.delegate = self;
#ifdef CUSTOM_PROCESS
    //_txLivePublisher.videoProcessDelegate = self;
#endif
    
#ifdef  UGC_ACTIVITY
    if (!_isPreviewing) {
        TXUGCCustomConfig *param = [[TXUGCCustomConfig alloc] init];
        param.videoResolution = _config.videoResolution;
        param.videoFPS = _config.videoFPS;
        param.videoBitratePIN = _config.videoBitratePIN;
        param.watermark = [UIImage imageNamed:@"watermark.png"];
        param.watermarkPos = (CGPoint){10, 10};
        [[TXUGCRecord shareInstance] startCameraCustom:param preview:preViewContainer];
        _isPreviewing = YES;
    }
#else
    [self.txLivePush startPreview:self];
    
    if ([self.txLivePush startPush:rtmpUrl] != 0) {
        NSLog(@"推流器启动失败");
        return;
    }
#endif
    ZXPushControlView *defaultControlView = [[ZXPushControlView alloc] init];
    
    defaultControlView.frame = self.frame;
    self.controlView = defaultControlView;
}

-(void)stopRtmp{
    self.pushUrl = @"";
    if (_txLivePush != nil) {
        [_txLivePush stopPreview];
#ifdef  UGC_ACTIVITY
        [[TXUGCRecord shareInstance] stopCameraPreview];
#endif
        [_txLivePush stopPush];
    }
}

-(void)clearPublish{
    [self stopRtmp];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self recoverTheBackgroundMusic];
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

#pragma -mark - ZXPushControlViewDelegate
-(void)backAction{
    if ([self.delegate respondsToSelector:@selector(quitPushPlayerView)]) {
        [self.delegate quitPushPlayerView];
    }
}

-(void)publishAction:(BOOL)isPublish{
    if (isPublish) {
        [self startRtmp];
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];

    }else{
        [self stopRtmp];
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];

    }
}

-(void)switchCamera:(BOOL)isSwitch{
    [self.txLivePush switchCamera];
}

-(void)directionAction:(BOOL)direction{
    if (direction) {
        TXLivePushConfig *_config = self.txLivePush.config;
        
        _config.homeOrientation = HOME_ORIENTATION_RIGHT;
        [self.txLivePush setConfig:_config];
        [self.txLivePush setRenderRotation:90];
    }else{
        TXLivePushConfig *_config = self.txLivePush.config;
        
        _config.homeOrientation = HOME_ORIENTATION_DOWN;
        [self.txLivePush setConfig:_config];
        [self.txLivePush setRenderRotation:0];
    }
}

#pragma -mark - TXLivePushListener
-(void)onPushEvent:(int)EvtID withParam:(NSDictionary *)param{
    NSDictionary* dict = param;
    
    dispatch_async(dispatch_get_main_queue(), ^{

        if (EvtID == PUSH_ERR_NET_DISCONNECT) {
            [self startRtmp];
        } else if (EvtID == PUSH_WARNING_HW_ACCELERATION_FAIL) {
            self.txLivePush.config.enableHWAcceleration = false;

        } else if (EvtID == PUSH_ERR_OPEN_CAMERA_FAIL) {
            [self stopRtmp];
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            [self toastTip:@"获取摄像头权限失败，请前往隐私-相机设置里面打开应用权限"];
        } else if (EvtID == PUSH_ERR_OPEN_MIC_FAIL) {
            [self stopRtmp];
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            [self toastTip:@"获取麦克风权限失败，请前往隐私-麦克风设置里面打开应用权限"];
        }
        else if (EvtID == PLAY_EVT_CONNECT_SUCC) {
            BOOL isWifi = [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
            if (!isWifi) {
                __weak __typeof(self) weakSelf = self;
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"您要切换到Wifi再观看吗?" preferredStyle:UIAlertControllerStyleAlert];
                __weak __typeof(alert) weakAlert = alert;
                [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                    if (weakSelf.pushUrl.length == 0) {
                        return;
                    }
                    if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
                        [weakAlert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [weakAlert dismissViewControllerAnimated:YES completion:nil];
                            [weakSelf stopRtmp];
                        }]];
                        [weakAlert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            [weakAlert dismissViewControllerAnimated:YES completion:nil];
                        }]];
//                        [weakSelf.rootViewController presentViewController:weakAlert animated:YES completion:nil];
                    }
                }];
            }
        } else if (EvtID == PUSH_WARNING_NET_BUSY) {
            [self toastTip:@"您当前的网络环境不佳，请尽快更换网络保证正常直播"];
        }

        
    });
}

#pragma -mark - 推流实例
-(TXLivePush*)txLivePush{
    if (_txLivePush == nil) {
        TXLivePushConfig *_config = [[TXLivePushConfig alloc] init];

        _txLivePush = [[TXLivePush alloc] initWithConfig:_config];
    }
    return _txLivePush;
}

@end
