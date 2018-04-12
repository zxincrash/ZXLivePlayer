//
//  ZXDetailCoverView.h
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/3/23.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXDetailCoverModel.h"
#import "ZXMediaPlayerModel.h"

typedef void(^PlayBtnCallBackBlock)(UIButton *sender);
typedef void(^BackBtnBlock)(UIButton *sender);
typedef void(^ContinueBtnBlock)(UIButton *sender);

@interface ZXDetailCoverView : UIView

-(instancetype)initWithFrame:(CGRect)frame;

/** model */
@property (nonatomic, strong) ZXDetailCoverModel *model;
/** 播放按钮block */
@property (nonatomic, copy) PlayBtnCallBackBlock playBlock;

@property (nonatomic, copy) BackBtnBlock backBlock;

@property (nonatomic, copy) ContinueBtnBlock continueBlock;

@property (nonatomic, assign) ZXNetWorkStatus networkStatus;

@end
