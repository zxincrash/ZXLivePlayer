//
//  ZXBaseViewController.h
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/3/23.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXCommon.h"
#import "UIBarButtonItem+item.h"
#import "ZXMediaPlayerModel.h"
#import "ZXNavigationController.h"

typedef void (^BackBtnClickBlock)(MediaPlayerState playerState);

@interface ZXBaseViewController : UIViewController<ZXNavigaitonControllerPopDelegate>

@property (nonatomic, assign) MediaPlayerState playerState;
@property (copy, nonatomic) BackBtnClickBlock backBlcok;

#pragma mark -- 导航栏
-(void)addLeftBarButtonItemWithType:(ZXNavigationBarType)type;
-(void)addRightBarButtonItemWithType:(ZXNavigationBarType)type;


- (void)addHeaderAndFooterWithView:(UIScrollView *)view;

-(void)startLoading;
-(void)stopLoading;
@end
