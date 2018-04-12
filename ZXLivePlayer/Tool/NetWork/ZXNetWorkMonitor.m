//
//  ZXNetWorkMonitor.m
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/3/23.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "ZXNetWorkMonitor.h"
#import "AFNetworking.h"
#import "ZXMediaPlayerView.h"

@implementation ZXNetWorkMonitor
+(ZXNetWorkMonitor*)shared{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
        [instance startMonitoring];
    });
    
    return instance;
}

#pragma mark -- 开启网络监测
- (void)startMonitoring
{
    ZXMediaPlayerView *playerView = [ZXMediaPlayerView sharedPlayerView];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        playerView.netWorkStatus = (ZXNetWorkStatus)status;

    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

@end
