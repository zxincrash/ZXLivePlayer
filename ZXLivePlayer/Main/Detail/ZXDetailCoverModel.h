//
//  ZXDetailCoverModel.h
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/3/23.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXCommon.h"

typedef NS_ENUM(NSInteger, GameStatus)
{
    GameStatus_UNSTART,
    GameStatus_LOADING,
    GameStatus_PLAYING,
    GameStatus_OTHER
};

@interface ZXDetailCoverModel : NSObject
/** 标题 */
@property (nonatomic, copy  ) NSString *title;
/** 描述 */
@property (nonatomic, copy  ) NSString *video_description;
/** 视频地址 */
@property (nonatomic, copy  ) NSString *playUrl;
/** 封面图 */
@property (nonatomic, copy  ) NSString *coverForFeed;
/** 视频分辨率的数组 */
@property (nonatomic, strong) NSMutableArray *playInfo;

@property (nonatomic, copy) NSString *detail;

@property (assign, nonatomic) GameStatus gameStatus;

+ (ZXDetailCoverModel*)testModelWithType:(MediaPlayerType)mediaPlayerType;

@end
