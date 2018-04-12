//
//  UIWindow+CurrentViewController.h
//  MediaPlayer
//
//  Created by zhaoxin on 2017/10/25.
//  Copyright © 2017年 zhaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (CurrentViewController)

/*!
 Current controller
 @return Returns the current topmost controller.
 */
- (UIViewController*)getCurrentViewController;

@end
