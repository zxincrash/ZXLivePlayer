//
//  ZXPushControlView.m
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/3/29.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "ZXPushControlView.h"
#import "ZXMediaPlayer.h"

@interface ZXPushControlView()
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *cameraButton;//照相机

@property (strong, nonatomic) UILabel *titleLab;//标题

@property (strong, nonatomic) UIButton *pushButton;
@property (strong, nonatomic) UIButton *directionButton;
@property (strong, nonatomic) UIButton *settingButton;

@end

@implementation ZXPushControlView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.backButton];
        [self addSubview:self.cameraButton];
        [self addSubview:self.pushButton];
        [self addSubview:self.titleLab];
        [self addSubview:self.directionButton];
        [self addSubview:self.settingButton];
        
        //设置控件约束
        [self makeSubViewsConstraints];
    }
    return self;
}

-(void)makeSubViewsConstraints{
    CGFloat buttonWH = 40;
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(10);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.pushButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.width.height.mas_equalTo(buttonWH);
    }];
    
    [self.cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.pushButton);
        make.leading.equalTo(self.pushButton.mas_trailing).offset(5);
        make.width.height.mas_equalTo(buttonWH);
    }];
    
    [self.directionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.pushButton);
        make.leading.equalTo(self.cameraButton.mas_trailing).offset(5);
        make.width.height.mas_equalTo(buttonWH);
    }];
    
    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.pushButton);
        make.leading.equalTo(self.directionButton.mas_trailing).offset(5);
        make.width.height.mas_equalTo(buttonWH);
    }];
}

-(void)setPushButtonState:(BOOL)selected{
    
}

#pragma -mark - 控件点击事件
-(void)backBtnClick:(UIButton*)button{
    if ([self.delegate respondsToSelector:@selector(backAction)]) {
        [self.delegate backAction];
    }
}

-(void)clickPushButton:(UIButton*)button{
    if ([self.delegate respondsToSelector:@selector(publishAction:)]) {

        [self.delegate publishAction:button.selected];
        button.selected = !button.selected;

    }
}

-(void)clickCameraButton:(UIButton*)button{
    if ([self.delegate respondsToSelector:@selector(switchCamera:)]) {
        [self.delegate switchCamera:button.selected];
        
        button.selected = !button.selected;
    }
}

-(void)clickDirectionButton:(UIButton*)button{
    if ([self.delegate respondsToSelector:@selector(directionAction:)]) {
        [self.delegate directionAction:button.selected];
        
        button.selected = !button.selected;
    }
}
#pragma -mark - 懒加载控件
-(UIButton *)backButton{
    if (_backButton == nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:MediaPlayerImage(@"MediaPlayer_back_full") forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
-(UIButton*)cameraButton{
    if (_cameraButton == nil) {
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraButton setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
        [_cameraButton setImage:[UIImage imageNamed:@"camera2"] forState:UIControlStateSelected];
        
        [_cameraButton addTarget:self action:@selector(clickCameraButton:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _cameraButton;
}
-(UIButton*)pushButton{
    if (_pushButton == nil) {
        _pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pushButton setImage:MediaPlayerImage(@"MediaPlayer_play") forState:UIControlStateNormal];
        [_pushButton setImage:MediaPlayerImage(@"MediaPlayer_pause") forState:UIControlStateSelected];
        [_pushButton addTarget:self action:@selector(clickPushButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pushButton;
}

-(UILabel*)titleLab{
    if (_titleLab == nil) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:15];
    }
    return _titleLab;
}
-(UIButton*)directionButton{
    if (_directionButton == nil) {
        _directionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_directionButton setImage:[UIImage imageNamed:@"landscape"] forState:UIControlStateNormal];
        [_directionButton setImage:[UIImage imageNamed:@"portrait"] forState:UIControlStateSelected];
        [_directionButton addTarget:self action:@selector(clickDirectionButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _directionButton;
}

-(UIButton*)settingButton{
    if (_settingButton == nil) {
        _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingButton setImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
    }
    return _settingButton;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
