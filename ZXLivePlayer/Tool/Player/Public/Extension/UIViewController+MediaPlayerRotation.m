//
//  UIViewController+MediaPlayerRotation.m
//  MediaPlayer
//
//  Created by zhaoxin on 2017/10/25.
//  Copyright © 2017年 zhaoxin. All rights reserved.
//

#import "UIViewController+MediaPlayerRotation.h"

@implementation UIViewController (MediaPlayerRotation)

/**
 * 默认所有都不支持转屏,如需个别页面支持除竖屏外的其他方向，请在viewController重新下边这三个方法
 */

// 是否支持自动转屏
- (BOOL)shouldAutorotate {
    return NO;
}

// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent; // your own style
}

- (BOOL)prefersStatusBarHidden {
    return NO; // your own visibility code
}

@end