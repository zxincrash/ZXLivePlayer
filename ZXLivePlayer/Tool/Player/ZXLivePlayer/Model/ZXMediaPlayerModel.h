//
//  ZXMediaPlayerModel.h
//  MediaPlayer
//
//  Created by zhaoxin on 2017/10/25.
//  Copyright © 2017年 zhaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum
{
    ZXNetWorkStatus_Unknown= -1,
    ZXNetWorkStatus_Not_Reachable = 0,
    ZXNetWorkStatus_WWAN = 1,
    ZXNetWorkStatus_Wifi = 2
}ZXNetWorkStatus;

typedef enum
{
    MediaPlayerType_VOD, //点播
    MediaPlayerType_LIVE, //直播
    MediaPlayerType_PUSH,//推流
    MediaPlayerType_OTHER
}MediaPlayerType;



// 播放器的几种状态
typedef enum
{
    MediaPlayerStateFailed,     // 播放失败
    MediaPlayerStateBuffering,  // 缓冲中
    MediaPlayerStatePlaying,    // 播放中
    MediaPlayerStateStopped,    // 停止播放
    MediaPlayerStatePause       // 暂停播放
}MediaPlayerState;

@interface ZXMediaPlayerModel : NSObject
/** 视频标题 */
@property (nonatomic, copy  ) NSString     *title;
/** 视频url */
@property (nonatomic, strong) NSString        *playUrl;
/** 视频封面本地图片 */
@property (nonatomic, strong) UIImage      *placeholderImage;
/**
 * 视频封面网络图片url
 * 如果和本地图片同时设置，则忽略本地图片，显示网络图片
 */
@property (nonatomic, copy  ) NSString     *placeholderImageURLString;
/**
 * 视频分辨率字典, 分辨率标题与该分辨率对应的视频URL.
 * 例如: @{@"高清" : @"https://xx/xx-hd.mp4", @"标清" : @"https://xx/xx-sd.mp4"}
 */
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *resolutionDic;
/** 从xx秒开始播放视频(默认0) */
@property (nonatomic, assign) NSInteger    seekTime;
// cell播放视频，以下属性必须设置值
@property (nonatomic, strong) UITableView  *tableView;
/** cell所在的indexPath */
@property (nonatomic, strong) NSIndexPath  *indexPath;
/** 播放器View的父视图（必须指定父视图）*/
@property (nonatomic, weak  ) UIView       *fatherView;

@property (assign, nonatomic) MediaPlayerType mediaPlayerType;
@property (assign, nonatomic) ZXNetWorkStatus netWorkStatus;

@end
