//
//  ZXMediaPlayerModel.h
//  MediaPlayer
//
//  Created by zhaoxin on 2017/10/25.
//  Copyright © 2017年 zhaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZXNetWorkStatus)
{
    ZXNetWorkStatus_Unknown= -1,
    ZXNetWorkStatus_Not_Reachable = 0,
    ZXNetWorkStatus_WWAN = 1,
    ZXNetWorkStatus_Wifi = 2
};

typedef NS_ENUM(NSInteger, MediaPlayerType)
{
    MediaPlayerType_VOD, //点播
    MediaPlayerType_LIVE, //直播
    MediaPlayerType_PUSH,//推流
    MediaPlayerType_OTHER
};



// 播放器的几种状态
typedef NS_ENUM(NSInteger, MediaPlayerState)
{
    MediaPlayerStateFailed,     // 播放失败
    MediaPlayerStateBuffering,  // 缓冲中
    MediaPlayerStatePlaying,    // 播放中
    MediaPlayerStateStopped,    // 停止播放
    MediaPlayerStatePause       // 暂停播放
};

@interface ZXMediaPlayerModel : NSObject
/** 视频标题 */
@property (nonatomic, copy  ) NSString *title;
/** 视频url */
@property (nonatomic, strong) NSString *playUrl;
/** 视频封面本地图片 */
@property (nonatomic, strong) UIImage *placeholderImage;
/**
 * 视频封面网络图片url
 * 如果和本地图片同时设置，则忽略本地图片，显示网络图片
 */
@property (nonatomic, copy  ) NSString *placeholderImageURLString;

/** 从xx秒开始播放视频(默认0) */
@property (nonatomic, assign) NSInteger seekTime;

/** 播放器View的父视图（必须指定父视图）*/
@property (nonatomic, weak  ) UIView *fatherView;

/** 播放类型 */
@property (assign, nonatomic) MediaPlayerType mediaPlayerType;

/** 网络状态 */
@property (assign, nonatomic) ZXNetWorkStatus netWorkStatus;

@end
