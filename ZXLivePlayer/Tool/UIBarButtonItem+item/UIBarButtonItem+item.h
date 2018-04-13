//
//  UIBarButtonItem+item.h
//  ZXLivePlayer
//
//  Created by zhaoxin on 2017/12/28.
//  Copyright © 2017年 zhaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZXNavigationBarType)
{
    ZXNavigationBarType_BACK,
    ZXNavigationBarType_OTHER
};

@interface UIBarButtonItem (item)

-(instancetype)initWithBarButtonItemType:(ZXNavigationBarType)type target:(id)target action:(SEL)action;

@end
