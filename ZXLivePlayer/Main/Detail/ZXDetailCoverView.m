//
//  ZXDetailCoverView.m
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/3/23.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "ZXDetailCoverView.h"
#import "ZXCommon.h"
#import "ZXDetailCoverModel.h"
#import "ZXMediaPlayerModel.h"

@interface ZXDetailCoverView()
@property (strong, nonatomic)  UIImageView *picView;

@property (strong, nonatomic)  UIButton *playBtn;

@property (strong, nonatomic) UIButton *backBtn;

@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) UILabel *detailLab;
@property (strong, nonatomic) UIImageView *m_imgViewLeftLine;
@property (strong, nonatomic) UIImageView *m_imgViewRightLine;

@property (strong, nonatomic) UIButton *continueBtn;
@end

@implementation ZXDetailCoverView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        self.userInteractionEnabled = YES;
        self.picView = [[UIImageView alloc]init];
        self.picView.backgroundColor = HEX_RGB(black);
        self.picView.userInteractionEnabled = YES;
        [self addSubview:self.picView];
        [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.playBtn.alpha = 0;
        [self.playBtn setImage:[UIImage imageNamed:@"MediaPlayer_play_btn"] forState:UIControlStateNormal];
        [self.playBtn addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchDown];
        [self.picView addSubview:self.playBtn];
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(50);
            make.center.equalTo(self.picView);
        }];
        
        [self backBtn];
        
        [self.picView addSubview:self.logoImageView];
        [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.picView);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(55);
        }];
        
        [self.picView addSubview:self.detailLab];
        [self.picView addSubview:self.m_imgViewLeftLine];
        
        [self.picView addSubview:self.m_imgViewRightLine];
        
        [self continueBtn];
    }
    return self;
}

-(void)setModel:(ZXDetailCoverModel *)model
{
    _model = model;
    
    if (self.networkStatus == ZXNetWorkStatus_WWAN) {
        self.picView.hidden = NO;
        self.detailLab.hidden = YES;
        self.continueBtn.hidden = NO;
    }else if (self.networkStatus == ZXNetWorkStatus_Wifi){
        self.picView.hidden = YES;
        self.detailLab.hidden = NO;
        self.continueBtn.hidden = YES;
    }else if(self.networkStatus == ZXNetWorkStatus_Unknown || self.networkStatus == ZXNetWorkStatus_Not_Reachable){
        self.picView.hidden = NO;
        self.detailLab.hidden = YES;
        self.continueBtn.hidden = NO;
    }
    
    if (_model.gameStatus == GameStatus_PLAYING) {
        self.continueBtn.hidden = YES;
        self.picView.hidden = YES;
    }else{
        self.picView.hidden = NO;
        self.continueBtn.hidden = YES;
        
        self.detailLab.hidden = NO;
        self.backBtn.hidden = NO;
        self.detailLab.text = _model.detail;
        
        CGSize detailLabSize = [NSString sizeWithText:self.detailLab.text font:self.detailLab.font maxSize:CGSizeMake(kScreenWidth - 100, 50)];
        [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.logoImageView.mas_bottom).offset(4);
            make.centerX.equalTo(self);
            make.width.mas_equalTo(detailLabSize.width);
            make.height.mas_equalTo(detailLabSize.height);
        }];
        
        [self.m_imgViewLeftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.detailLab.mas_left).offset(-5);
            make.centerY.equalTo(self.detailLab.mas_centerY);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(1);
        }];
        
        [self.m_imgViewRightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.detailLab.mas_right).offset(5);
            make.centerY.equalTo(self.detailLab.mas_centerY);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(1);
        }];
    }
    //    [self.picView sd_setImageWithURL:[NSURL URLWithString:_model.coverForFeed] placeholderImage:[UIImage imageNamed:@"loading_bgView"]];
    
}

-(void)setNetworkStatus:(ZXNetWorkStatus)networkStatus{
    _networkStatus = networkStatus;
    if (networkStatus == ZXNetWorkStatus_WWAN) {
        self.picView.hidden = NO;
        self.detailLab.hidden = YES;
        self.continueBtn.hidden = NO;
        [_continueBtn setTitle:@"4g网络 继续观看？" forState:UIControlStateNormal];
        
    }else if (networkStatus == ZXNetWorkStatus_Wifi){
        self.picView.hidden = YES;
        self.detailLab.hidden = NO;
        self.continueBtn.hidden = YES;
        
    }else if(networkStatus == ZXNetWorkStatus_Unknown || networkStatus == ZXNetWorkStatus_Not_Reachable){
        [_continueBtn setTitle:@"网络不可用 重新播放" forState:UIControlStateNormal];
        
        self.picView.hidden = NO;
        self.detailLab.hidden = YES;
        self.continueBtn.hidden = NO;
    }
}

#pragma -mark Action
- (void)playAction:(UIButton *)sender {
    if (self.playBlock) {
        self.playBlock(sender);
    }
}

-(void)continueAction:(UIButton*)sender{
    if (self.playBlock) {
        self.playBlock(sender);
    }
}

-(void)backAction:(UIButton*)sender{
    if (self.backBlock) {
        self.backBlock(sender);
    }
}

#pragma -mark logoImageView
- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.userInteractionEnabled = YES;
        _logoImageView.image = [UIImage imageNamed:@"match_logo001"];
    }
    return _logoImageView;
}
- (UIImageView *)m_imgViewLeftLine {
    if (!_m_imgViewLeftLine) {
        _m_imgViewLeftLine = [[UIImageView alloc] init];
        _m_imgViewLeftLine.userInteractionEnabled = YES;
        _m_imgViewLeftLine.image = [UIImage imageNamed:@"match_line_left"];
    }
    return _m_imgViewLeftLine;
}

- (UIImageView *)m_imgViewRightLine {
    if (!_m_imgViewRightLine) {
        _m_imgViewRightLine = [[UIImageView alloc] init];
        _m_imgViewRightLine.userInteractionEnabled = YES;
        _m_imgViewRightLine.image = [UIImage imageNamed:@"match_line_right"];
    }
    return _m_imgViewRightLine;
}

#pragma -mark detailLab
- (UILabel *)detailLab {
    if (!_detailLab) {
        _detailLab = [[UILabel alloc] init];
        _detailLab.textColor = [UIColor whiteColor];
        _detailLab.font = [UIFont systemFontOfSize:12];
        _detailLab.textAlignment = NSTextAlignmentCenter;
    }
    return _detailLab;
}

#pragma -mark backBtn
-(UIButton *)backBtn{
    if (_backBtn == nil) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"match_btn_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchDown];
        [self.picView addSubview:_backBtn];
        
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.picView).offset(STATUSBAR_HEIGHT);
            make.leading.equalTo(self.picView).offset(10);
            make.width.height.mas_equalTo(55);
        }];
    }
    return _backBtn;
}

-(UIButton *)continueBtn{
    if (_continueBtn == nil) {
        _continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_continueBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        //        [_continueBtn setTitle:@"4g网络 继续观看？" forState:UIControlStateNormal];
        [_continueBtn setTitleColor:HEX_RGB(white) forState:UIControlStateNormal];
        _continueBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _continueBtn.layer.cornerRadius = 15;
        _continueBtn.layer.borderWidth = 1;
        _continueBtn.layer.borderColor = HEX_RGB(white).CGColor;
        [_continueBtn addTarget:self action:@selector(continueAction:) forControlEvents:UIControlEventTouchDown];
        [self.picView addSubview:_continueBtn];
        
        [_continueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.logoImageView.mas_bottom).offset(5);
            make.centerX.equalTo(self.picView);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(180);
        }];
    }
    return _continueBtn;
}

@end

