//
//  UINavigationController+FullscreenPopGesture.h
//  ZXLivePlayer
//
//  Created by zhaoxin on 2017/12/11.
//  Copyright © 2017年 zhaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (FullscreenPopGesture)

/// 隐藏NavigationBar（默认NO）
@property (nonatomic, assign) BOOL pf_prefersNavigationBarHidden;
/// 关闭某个控制器的pop手势（默认NO）
@property (nonatomic, assign) BOOL pf_interactivePopDisabled;
/// 自定义的滑动返回手势是否与其他手势共存，一般使用默认值(默认返回NO：不与任何手势共存)
@property (nonatomic, assign) BOOL pf_recognizeSimultaneouslyEnable;

@end

typedef NS_ENUM(NSInteger,FullscreenPopGestureStyle) {
    FullscreenPopGestureGradientStyle,   // 根据滑动偏移量背景颜色渐变
    FullscreenPopGestureShadowStyle      // 侧边阴影效果，类似系统的滑动样式
};

@interface UINavigationController (PFFullscreenPopGesture)<UIGestureRecognizerDelegate>
/** 默认FullscreenPopGestureGradientStyle */
@property (nonatomic, assign) FullscreenPopGestureStyle popGestureStyle;

@end
