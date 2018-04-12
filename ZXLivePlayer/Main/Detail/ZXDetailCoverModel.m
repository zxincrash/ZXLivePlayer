//
//  ZXDetailCoverModel.m
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/3/23.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "ZXDetailCoverModel.h"

@implementation ZXDetailCoverModel
+ (ZXDetailCoverModel*)testModelWithType:(MediaPlayerType)mediaPlayerType
{
    ZXDetailCoverModel *model = [[ZXDetailCoverModel alloc]init];
    model.title = @"";
    if (mediaPlayerType == MediaPlayerType_VOD) {
        model.playUrl = @"http://120.25.226.186:32812/resources/videos/minion_01.mp4";
    }else{
        model.playUrl = @"rtmp://live.hkstv.hk.lxdns.com/live/hks";
    }
    model.coverForFeed = @"http://img.wdjimg.com/image/video/ef5af677657e81b0cf79b73349446f43_0_0.jpeg";
    model.gameStatus = GameStatus_PLAYING;
    return model;
}

-(void)setGameStatus:(GameStatus)gameStatus{
    _gameStatus = gameStatus;
    
    if (gameStatus == GameStatus_UNSTART) {
        self.detail = @"比赛开始时间 14:30";
    }else if (gameStatus == GameStatus_LOADING){
        self.detail = @"精彩即将开始";
    }
}
@end
