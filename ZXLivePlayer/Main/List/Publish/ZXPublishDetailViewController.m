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
    
    
    ZXPushPlayerView *pushPlayerView = [ZXPushPlayerView shared];
    pushPlayerView.delegate = self;
    pushPlayerView.rootViewController = self;
    ZXMediaPlayerModel *palyerModel = [ZXMediaPlayerModel new];
    palyerModel.fatherView = self.view;

    pushPlayerView.pushUrl = PUSH_URL_TEST;
    [pushPlayerView playerModel:palyerModel];
    [pushPlayerView startPublish];
}

-(void)onPopViewControllerAnimated:(BOOL)animated{
    [[ZXPushPlayerView shared]clearPublish];
}

#pragma -mark - ZXPushPlayerViewDelegate
-(void)quitPushPlayerView{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
