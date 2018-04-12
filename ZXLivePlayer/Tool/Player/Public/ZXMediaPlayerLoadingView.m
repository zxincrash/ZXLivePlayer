//
//  ZXMediaPlayerLoadingView.m
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/1/7.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "ZXMediaPlayerLoadingView.h"
#import "ZXCommon.h"
#include <ifaddrs.h>

#include <arpa/inet.h>

#include <net/if.h>

@interface ZXMediaPlayerLoadingView()
@property (strong, nonatomic)  UIImageView *picView;

@property (strong, nonatomic) UIImageView *m_imgViewLeftLine;
@property (strong, nonatomic) UIImageView *m_imgViewRightLine;

@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) UILabel *detailLab;

@end

@implementation ZXMediaPlayerLoadingView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.userInteractionEnabled = YES;
        self.picView = [[UIImageView alloc]init];
        self.picView.backgroundColor = [UIColor clearColor];
        self.picView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapBG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackGroundImageViewAction:)];
        [self.picView addGestureRecognizer:tapBG];
        
        [self addSubview:self.picView];
        [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.width.height.equalTo(self);
        }];
        
        [self.picView addSubview:self.logoImageView];
        [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.centerX.equalTo(self);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(55);
        }];
        
        [self.picView addSubview:self.detailLab];
        
        [self.picView addSubview:self.m_imgViewLeftLine];
        
        [self.picView addSubview:self.m_imgViewRightLine];
        
    }
    return self;
}

-(void)setStatus:(BOOL)status{
    _status = status;
    if (status) {
        self.detailLab.text = @"精彩即将开始";

    }else{
        self.detailLab.text = @"精彩即将开始";

    }
    self.detailLab.text = [self getInternetface];
    
    CGSize detailLabSize = [NSString sizeWithText:self.detailLab.text font:self.detailLab.font maxSize:CGSizeMake(kScreenWidth, 50)];
    [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.mas_bottom).offset(4);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(kScreenWidth);
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

-(void)startLoading{
    self.alpha = 1;

}

-(void)stopLoading{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:ctx];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.2];
    self.alpha = 0;
    [UIView commitAnimations];
}

-(void)tapBackGroundImageViewAction:(UITapGestureRecognizer*)sender{
    
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
        _detailLab.numberOfLines = 0;
        _detailLab.textColor = [UIColor whiteColor];
        _detailLab.font = [UIFont systemFontOfSize:12];
        _detailLab.textAlignment = NSTextAlignmentCenter;
        _detailLab.text = @"精彩即将开始";
    }
    return _detailLab;
}

- (NSString*)getInternetface {
    
    long long hehe = [self getInterfaceBytes];
    NSLog(@"hehe:%lld",hehe);
    NSString *bytes = [NSString stringWithFormat:@"%lld kb/s",hehe/1024/1000];
    
    return bytes;
}

/*获取网络流量信息*/
- (long long) getInterfaceBytes
{
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1)
    {
        return 0;
    }
    
    uint32_t iBytes = 0;
    uint32_t oBytes = 0;
    
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next)
    {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        
        if (ifa->ifa_data == 0)
            continue;
        
        /* Not a loopback device. */
        if (strncmp(ifa->ifa_name, "lo", 2))
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            
            iBytes += if_data->ifi_ibytes;
            
            oBytes += if_data->ifi_obytes;
        }
        
    }
    
    freeifaddrs(ifa_list);
    NSLog(@"\n[getInterfaceBytes-Total]%d,%d",iBytes,oBytes);
    return iBytes + oBytes;
}

@end
