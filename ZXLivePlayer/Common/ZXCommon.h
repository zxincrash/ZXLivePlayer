//
//  ZXCommon.h
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/3/23.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#ifndef ZXCommon_h
#define ZXCommon_h

#import <YYKit/YYkit.h>
#import <Masonry.h>
#import "UIImageView+WebCache.h"
#import "ZXAppDelegate.h"
#import "NSString+Category.h"
#import "NSMutableArray+Safe.h"
#import "NSMutableDictionary+Safe.h"
#import "UINavigationController+FullscreenPopGesture.h"
#import <AFNetworking.h>
#import "ZXMediaPlayerModel.h"

#define isPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#if DEVELOPMENT
#define BASE_URL @"http://zhibo.xahacker.com/zhibo.asmx"

#else
#define BASE_URL @"http://zhibo.xahacker.com/zhibo.asmx"

#endif

#define SYSTERM_VERTION [[UIDevice currentDevice] systemVersion]

#define COLOR_NAVIGATION    0xF05858     //状态栏、导航栏
#define COLOR_BACKGROUND    0xf6f6f6    //背景颜色
#define white        0xffffff
#define black        0x111111

static const CGFloat STATUSBAR_HEIGHT   = 20.0;

static const CGFloat NAVBAR_HEIGHT   = 64.0;
static const CGFloat TABBAR_HEIGHT   = 49.0;
static const CGFloat PAGEVIEW_HEADER_HEIGHT_0 = 0;
static const CGFloat PAGEVIEW_HEADER_HEIGHT_44 = 44;

//token失效
#define TOKEN_INVALID_3 3
#define TOKEN_MSG_TOST @"登录过期，请重新登录"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

#define kScreenWidth YYScreenSize().width

#define kScreenHeight YYScreenSize().height

#define TOAST_DEFAULT_BOTTOM  65

#define RATIO kScreenWidth/375

#define HEX_RGB(V)    [UIColor colorWithRGB:V]

#define HEX_RGBA(V, A)    [UIColor colorWithRGB:V alpha:A]

static NSString * const NETWORK_ERROR = @"网络不给力";


#endif /*  ZXCommon_h */
