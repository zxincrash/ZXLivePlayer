//
//  ZXMediaPlayer.h
//  MediaPlayer
//
//  Created by zhaoxin on 2017/10/25.
//  Copyright © 2017年 zhaoxin. All rights reserved.
//

#import "ZXBrightnessView.h"

// 监听TableView的contentOffset
#define kMediaPlayerViewContentOffset  @"contentOffset"
// player的单例
#define MediaPlayerShared  [ZXBrightnessView sharedBrightnessView]
// 屏幕的宽
#define kMediaPlayerScreenWidth  [[UIScreen mainScreen] bounds].size.width
// 屏幕的高
#define kMediaPlayerScreenHeight  [[UIScreen mainScreen] bounds].size.height
// 颜色值RGB
#define RGBA(r,g,b,a)  [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

// 图片路径
#define MediaPlayerSrcName(file)  [@"ZXMediaPlayer.bundle" stringByAppendingPathComponent:file]

#define MediaPlayerFrameworkSrcName(file) [@"Frameworks/ZXLivePlayer.framework/ZXMediaPlayer.bundle" stringByAppendingPathComponent:file]

#define MediaPlayerImage(file)   [UIImage imageNamed:MediaPlayerSrcName(file)] ? :[UIImage imageNamed:MediaPlayerFrameworkSrcName(file)]

#define MediaPlayerOrientationIsLandscape      UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)

#define MediaPlayerOrientationIsPortrait       UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)

#import "MMMaterialDesignSpinner.h"
#import "ASValuePopUpView.h"
#import "ASValueTrackingSlider.h"
#import <Masonry.h>
#import "ZXMediaPlayerModel.h"
#import "ZXMediaPlayerControlViewDelegate.h"
#import "ZXMediaPlayerControlView.h"
#import "UIViewController+MediaPlayerRotation.h"
#import "UINavigationController+MediaPlayerRotation.h"
#import "UIWindow+CurrentViewController.h"
#import "DQChangeAngleView.h"

