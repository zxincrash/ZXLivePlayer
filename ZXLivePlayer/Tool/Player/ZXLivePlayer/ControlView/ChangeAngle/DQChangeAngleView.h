//
//  DQChangeAngleView.h
//  ZXLivePlayer
//
//  Created by zhaoxin on 2017/12/31.
//  Copyright © 2017年 zhaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXMediaPlayer.h"

@class DQGameModel;
@class ZXMediaPlayerView;
typedef NS_ENUM(NSInteger, AngleType)
{
    AngleType_MAIN1 = 100,
    AngleType_MAIN2,
    AngleType_SOUTH_EAST,
    AngleType_SOUTH_NORTH,
    AngleType_WEST_SOUTH,
    AngleType_WEST_NORTH
};

@protocol DQChangeAngleViewDelegate<NSObject>

@optional
-(void)closeChangeAngleView:(MediaPlayerState)state;

-(void)changeAngle:(UIButton*)button angleType:(AngleType)angleType;

@end

@interface DQChangeAngleView : UIView

@property (weak, nonatomic) id<DQChangeAngleViewDelegate> delegate;
@property (assign, nonatomic) MediaPlayerState state;
@property (assign, nonatomic) AngleType angleType;

@property (strong, nonatomic) DQGameModel *gameModel;

@property (copy, nonatomic) NSString *Live_Match_Guid;

+ (instancetype)shared;

- (void)showInView:(UIView*)view mediaPlayView:(ZXMediaPlayerView*)playView angleType:(AngleType)angleType;

@end
