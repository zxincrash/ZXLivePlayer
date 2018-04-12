//
//  DQChangeAngleView.m
//  ZXLivePlayer
//
//  Created by zhaoxin on 2017/12/31.
//  Copyright © 2017年 zhaoxin. All rights reserved.
//

#import "DQChangeAngleView.h"
#import "ZXMediaPlayer.h"
#import "ZXCommon.h"

@interface DQChangeAngleView()
@property (strong, nonatomic) UIButton *closeBtn;
@property (strong, nonatomic) UIButton *slowActionBtn;
@property (strong, nonatomic) UIButton *sureBtn;
@property (strong, nonatomic) NSMutableArray *angleArray;

@property (strong, nonatomic) NSMutableArray *buttonArray;
@end

@implementation DQChangeAngleView

+ (instancetype)shared{
    static DQChangeAngleView *changeAngleView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        changeAngleView = [[DQChangeAngleView alloc] init];
        
    });
    return changeAngleView;
}

-(NSMutableArray *)angleArray{
    if (_angleArray == nil) {
        _angleArray = [NSMutableArray arrayWithObjects:@"主视角1",@"主视角2",@"东南角",@"东北角",@"西南角",@"西北角", nil];
    }
    return _angleArray;
}

-(NSMutableArray *)buttonArray{
    if (_buttonArray == nil) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEX_RGBA(0x312828, 0.7523);
        
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_closeBtn setTitle:@"" forState:UIControlStateNormal];
        [_closeBtn setImage:MediaPlayerImage(@"MediaPlayer_close") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-18);
            make.top.equalTo(self).offset(18);
            make.width.height.mas_equalTo(40);
        }];
        
        UIImageView *topLineView = [[UIImageView alloc]init];
        topLineView.image = [UIImage imageNamed:@"match_pop_line"];
        [self addSubview:topLineView];
        [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(18);
            make.trailing.equalTo(self).offset(-18);
            make.top.equalTo(_closeBtn.mas_bottom).offset(20);
            make.height.mas_equalTo(1);
        }];
        
        
        CGFloat CenterX_margin = kMediaPlayerScreenWidth*0.22;
        for (int i = 0; i<self.angleArray.count; i++) {
            UIButton *angleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            angleBtn.tag = i+100;
            NSString *title = [self.angleArray objectAtIndexSafe:i];
            [angleBtn setTitle:title forState:UIControlStateNormal];
            if (angleBtn.tag == AngleType_MAIN1) {
                [angleBtn setTitleColor:HEX_RGB(0xF05858) forState:UIControlStateNormal];
                angleBtn.layer.cornerRadius = 18;
                angleBtn.layer.borderWidth = 1;
                angleBtn.layer.borderColor = HEX_RGB(0xF05858).CGColor;
            }else{
                [angleBtn setTitleColor:HEX_RGB(0xFFFFFF) forState:UIControlStateNormal];
                angleBtn.layer.cornerRadius = 0;
                angleBtn.layer.borderWidth = 0;
                angleBtn.layer.borderColor = angleBtn.backgroundColor.CGColor;
            }
            
            [angleBtn addTarget:self action:@selector(changeAngleAction:) forControlEvents:UIControlEventTouchUpInside];
            angleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            angleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:angleBtn];
            [self.buttonArray addObjectSafe:angleBtn];
            
            CGFloat angleBtnH = 36;
            CGFloat verticalMargin = 15;
            if (i%2 == 0) {
                [angleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(self).offset(-CenterX_margin);
                    make.width.mas_equalTo(85);
                    make.height.mas_equalTo(angleBtnH);
                make.top.equalTo(self).offset(100+i*(angleBtnH+verticalMargin));
                }];
            }else{
                [angleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(self).offset(CenterX_margin);
                    make.width.mas_equalTo(85);
                    make.height.mas_equalTo(angleBtnH);
                    make.top.equalTo(self).offset(100+(i-1)*(angleBtnH+verticalMargin));
                }];
            }
            
            if (i == self.angleArray.count - 1) {
                UIImageView *topLineView = [[UIImageView alloc]init];
                topLineView.image = [UIImage imageNamed:@"match_pop_line"];
                [self addSubview:topLineView];
                [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(self).offset(18);
                    make.trailing.equalTo(self).offset(-18);
                    make.top.equalTo(angleBtn.mas_bottom).offset(20);
                    make.height.mas_equalTo(1);
                }];
            }

        }
        
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        _sureBtn.backgroundColor = HEX_RGB(0xFFFFFF);
        _sureBtn.layer.cornerRadius = 22.5;
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _sureBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_sureBtn setTitleColor:HEX_RGB(0xE73D42) forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sureBtn];
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self).offset(0);
            make.bottom.equalTo(self).offset(-46);
            make.width.mas_equalTo(173);
            make.height.mas_equalTo(45);
        }];
        
        _slowActionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_slowActionBtn setTitleColor:HEX_RGB(0xFFFFFF) forState:UIControlStateNormal];
        [_slowActionBtn setTitle:@"慢动作回放" forState:UIControlStateNormal];
        _slowActionBtn.titleLabel.font = [UIFont systemFontOfSize:14];;
        [_slowActionBtn setImage:[UIImage imageNamed:@"pop_btn_playback"] forState:UIControlStateNormal];
        [_slowActionBtn addTarget:self action:@selector(slowAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_slowActionBtn];
        [_slowActionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self).offset(0);
            make.bottom.equalTo(_sureBtn).offset(-50);
            make.width.height.mas_equalTo(173);
        }];

    }
    return self;
}

-(void)setAngleType:(AngleType)angleType{
    _angleType = angleType;
    for (int i = 0; i<self.buttonArray.count; i++) {
        if ([self.buttonArray[i] isKindOfClass:[UIButton class]]) {
            UIButton *angleBtn = self.buttonArray[i];
            if (angleBtn.tag == _angleType) {
                [angleBtn setTitleColor:HEX_RGB(0xF05858) forState:UIControlStateNormal];
                angleBtn.layer.cornerRadius = 18;
                angleBtn.layer.borderWidth = 1;
                angleBtn.layer.borderColor = HEX_RGB(0xF05858).CGColor;
            }else{
                [angleBtn setTitleColor:HEX_RGB(0xFFFFFF) forState:UIControlStateNormal];
                angleBtn.layer.cornerRadius = 0;
                angleBtn.layer.borderWidth = 0;
                angleBtn.layer.borderColor = angleBtn.backgroundColor.CGColor;
            }
        }
    }
}

-(void)showInView:(UIView*)view mediaPlayView:(ZXMediaPlayerView*)playView angleType:(AngleType)angleType{
    DQChangeAngleView *changeAngleView = [DQChangeAngleView shared];
    changeAngleView.angleType = angleType;
    changeAngleView.frame = view.frame;
    changeAngleView.frame = CGRectMake(0, kMediaPlayerScreenHeight, kMediaPlayerScreenWidth, kMediaPlayerScreenHeight);
    [view addSubview: changeAngleView];
    
    [UIView animateWithDuration:0.3 animations:^{
        changeAngleView.frame = CGRectMake(0, 0, kMediaPlayerScreenWidth, kMediaPlayerScreenHeight);
    } completion:^(BOOL finished) {

    }];
    
}


#pragma -mark Action
-(void)backAction:(UIButton*)sender{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, kMediaPlayerScreenHeight, kMediaPlayerScreenWidth, kMediaPlayerScreenHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if ([weakSelf.delegate respondsToSelector:@selector(closeChangeAngleView:)]) {
            [weakSelf.delegate closeChangeAngleView:weakSelf.state];
        }
    }];

}

-(void)changeAngleAction:(UIButton*)sender{
    self.angleType = (AngleType)sender.tag;
}

-(void)slowAction:(UIButton*)sender{
    
}

-(void)sureAction:(UIButton*)sender{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, kMediaPlayerScreenHeight, kMediaPlayerScreenWidth, kMediaPlayerScreenHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if ([weakSelf.delegate respondsToSelector:@selector(changeAngle:angleType:)]) {
            [weakSelf.delegate changeAngle:sender angleType:weakSelf.angleType];
        }
    }];
}

@end
