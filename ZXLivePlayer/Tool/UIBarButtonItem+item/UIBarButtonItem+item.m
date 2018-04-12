//
//  UIBarButtonItem+item.m
//  ZXLivePlayer
//
//  Created by zhaoxin on 2017/12/28.
//  Copyright © 2017年 zhaoxin. All rights reserved.
//

#import "UIBarButtonItem+item.h"
#import "ZXCommon.h"

@implementation UIBarButtonItem (item)
-(instancetype)initWithBarButtonItemType:(ZXNavigationBarType)type target:(id)target action:(SEL)action{
    UIButton *btn = nil;
    NSString *imgName = @"";
    NSString *title = @"";
    
    if (type == ZXNavigationBarType_OTHER) {
        UIImage *img = [UIImage imageNamed:imgName];
        btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setBackgroundImage:img forState:UIControlStateNormal];
        UIBarButtonItem *button = [self initWithCustomView:btn];
        
        return button;
    }else{
        switch (type) {
            case ZXNavigationBarType_BACK:
                imgName = @"match_btn_back";
                break;
            case ZXNavigationBarType_OTHER:
                imgName = @"match_rule";
                break;
            default:
                break;
        }
        
        UIImage *img = [UIImage imageNamed:imgName];
        btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
        btn.tag = type;
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setBackgroundImage:img forState:UIControlStateNormal];
        UIBarButtonItem *button = [self initWithCustomView:btn];
        
        return button;
    }
}

@end
