//
//  ZXPushControlView.h
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/3/29.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZXPushControlViewDelegate<NSObject>
/** 返回按钮事件 */
-(void)backAction;
/** 推流控制 */
-(void)publishAction:(BOOL)isPublish;
/** 相机前后置 */
-(void)switchCamera:(BOOL)isSwitch;
/** 横竖屏推流设置 */
-(void)directionAction:(BOOL)direction;

@end

@interface ZXPushControlView : UIView
@property (nonatomic, weak) id<ZXPushControlViewDelegate> delegate;

@end
