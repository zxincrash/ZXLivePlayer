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
/** 设置按钮 */
-(void)settingAction:(BOOL)selected;

//美颜配置代理方法
- (void)onSetBeautyStyle:(int)beautyStyle beautyLevel:(float)beautyLevel whitenessLevel:(float)whitenessLevel ruddinessLevel:(float)ruddinessLevel;
- (void)onSetMixLevel:(float)mixLevel;
- (void)onSetEyeScaleLevel:(float)eyeScaleLevel;
- (void)onSetFaceScaleLevel:(float)faceScaleLevel;
- (void)onSetFaceBeautyLevel:(float)beautyLevel;
- (void)onSetFaceVLevel:(float)vLevel;
- (void)onSetChinLevel:(float)chinLevel;
- (void)onSetFaceShortLevel:(float)shortLevel;
- (void)onSetNoseSlimLevel:(float)slimLevel;
- (void)onSetFilter:(UIImage*)filterImage;
- (void)onSetGreenScreenFile:(NSURL *)file;
- (void)onSelectMotionTmpl:(NSString *)tmplName inDir:(NSString *)tmplDir;

@end

@interface ZXPushControlView : UIView
@property (nonatomic, weak) id<ZXPushControlViewDelegate> delegate;

-(void)setPublishButtonState:(BOOL)selected;

@end
