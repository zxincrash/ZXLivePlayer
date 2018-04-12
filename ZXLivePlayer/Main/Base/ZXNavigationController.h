//
//  ZXNavigationController
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/3/23.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZXNavigaitonControllerPopDelegate <NSObject>
@optional
-(void)onPopViewControllerAnimated:(BOOL)animated;
@end

@interface ZXNavigationController : UINavigationController
@property (weak, nonatomic) id<ZXNavigaitonControllerPopDelegate> popDelegate;
@end
