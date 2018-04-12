//
//  ZXPublishDetailViewController.m
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/3/29.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "ZXPublishDetailViewController.h"
#import "ZXPushPlayerView.h"

@interface ZXPublishDetailViewController ()<ZXPushPlayerViewDelegate>

@end

@implementation ZXPublishDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pf_prefersNavigationBarHidden = YES;
    self.pf_recognizeSimultaneouslyEnable = NO;
    
//    [self addLeftBarButtonItemWithType:ZXNavigationBarType_BACK];
//    self.view.backgroundColor = HEX_RGB(COLOR_BACKGROUND);
    
    ZXPushPlayerView *pushPlayerView = [ZXPushPlayerView shared];
    pushPlayerView.delegate = self;
    pushPlayerView.rootViewController = self;
    ZXMediaPlayerModel *palyerModel = [ZXMediaPlayerModel new];
    palyerModel.fatherView = self.view;

    pushPlayerView.pushUrl = @"rtmp://3891.livepush.myqcloud.com/live/3891_user_bea5056c_0a23?bizid=3891&txSecret=b44be37a13dffafeca8960a446eecfd3&txTime=5AC6E64E";
    [pushPlayerView playerModel:palyerModel];
    [pushPlayerView startRtmp];
}

-(void)onPopViewControllerAnimated:(BOOL)animated{
    [[ZXPushPlayerView shared]clearPublish];
}

#pragma -mark - ZXPushPlayerViewDelegate
-(void)quitPushPlayerView{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
