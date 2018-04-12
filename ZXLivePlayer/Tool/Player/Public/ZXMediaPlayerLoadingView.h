//
//  ZXMediaPlayerLoadingView.h
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/1/7.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXMediaPlayerLoadingView : UIView

@property (assign, nonatomic) BOOL status;
-(void)startLoading;
-(void)stopLoading;

@end
