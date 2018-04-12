//
//  ZXDetailViewController.m
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/3/23.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "ZXDetailViewController.h"
#import "ZXDetailCoverView.h"
#import "ZXDetailCoverModel.h"
#import "ZXMediaPlayerView.h"

@interface ZXDetailViewController ()<MediaPlayerDelegate>
@property (strong, nonatomic) ZXDetailCoverView *coverView;

@property (strong, nonatomic) ZXDetailCoverModel *coverModel;
@end

@implementation ZXDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pf_prefersNavigationBarHidden = YES;
    self.pf_recognizeSimultaneouslyEnable = YES;
    
    self.view.backgroundColor = HEX_RGB(COLOR_BACKGROUND);

    
    // Do any additional setup after loading the view.
    [self.view addSubview:self.coverView];
    self.coverView.model = self.coverModel;
    __weak typeof(self) weakSelf = self;
    
    self.coverView.playBlock = ^(UIButton *sender) {
        ZXDetailCoverModel *videoModel = weakSelf.coverModel;
        
        ZXMediaPlayerModel *model = [[ZXMediaPlayerModel alloc]init];
        model.playUrl = videoModel.playUrl;
        model.title = videoModel.title;
        model.placeholderImageURLString  = videoModel.coverForFeed;
        model.fatherView = weakSelf.coverView;
        model.mediaPlayerType = weakSelf.mediaPalyerType;
        
        ZXMediaPlayerView *playView = [ZXMediaPlayerView sharedPlayerView];
        playView.rootViewController = weakSelf;
        playView.allowAutoRotate = YES;
        playView.delegate = weakSelf;
        playView.hasPreviewView = YES;
        [playView playerModel:model];
        
        [playView playTheVideo];
    };
    
    ZXNetWorkStatus status = (ZXNetWorkStatus)[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    self.coverView.networkStatus = status;
    if (status == ZXNetWorkStatus_Unknown || status == ZXNetWorkStatus_Not_Reachable) {
        return;
    }
    
    ZXDetailCoverModel *videoModel = weakSelf.coverModel;
    ZXMediaPlayerView *playView = [ZXMediaPlayerView sharedPlayerView];
    if (videoModel.gameStatus == GameStatus_PLAYING) {
        ZXMediaPlayerModel *model = [[ZXMediaPlayerModel alloc]init];
        model.playUrl = videoModel.playUrl;
        model.title = videoModel.title;
        model.placeholderImageURLString  = videoModel.coverForFeed;
        model.fatherView = weakSelf.coverView;
        model.mediaPlayerType = weakSelf.mediaPalyerType;
        
        playView.rootViewController = weakSelf;
        playView.allowAutoRotate = YES;
        playView.delegate = weakSelf;
        playView.hasPreviewView = YES;
        [playView playerModel:model];
        [playView playTheVideo];
    }else{
        [playView removeFromSuperview];
    }
    
}

-(void)onPopViewControllerAnimated:(BOOL)animated{
    [[ZXMediaPlayerView sharedPlayerView]clearPlay];
}

#pragma -mark MediaPlayerDelegate
-(void)mediaPlayerBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)networkChangeTo:(ZXNetWorkStatus)networkStatus{
    self.coverView.networkStatus = networkStatus;
    
}

#pragma -mark ZXDetailCoverModel
-(ZXDetailCoverModel*)coverModel
{
    return [ZXDetailCoverModel testModelWithType:self.mediaPalyerType];
}

#pragma -mark ZXDetailCoverView
-(ZXDetailCoverView*)coverView
{
    if (_coverView == nil) {
        _coverView = [[ZXDetailCoverView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*9/16)];
        [self.view addSubview:_coverView];
        [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.equalTo(self.view);
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(kScreenWidth*9/16);
        }];
        __weak typeof(self) weakSelf = self;
        _coverView.backBlock = ^(UIButton *sender) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        
        _coverView.continueBlock = ^(UIButton *sender) {
            ZXDetailCoverModel *videoModel = weakSelf.coverModel;
            
            ZXMediaPlayerModel *model = [[ZXMediaPlayerModel alloc]init];
            model.playUrl = videoModel.playUrl;
            model.title = videoModel.title;
            model.placeholderImageURLString  = videoModel.coverForFeed;
            model.fatherView = weakSelf.coverView;
            model.mediaPlayerType = MediaPlayerType_VOD;
            
            ZXMediaPlayerView *playView = [ZXMediaPlayerView sharedPlayerView];
            playView.rootViewController = weakSelf;
            playView.allowAutoRotate = YES;
            playView.delegate = weakSelf;
            playView.hasPreviewView = YES;
            [playView playerModel:model];
            
            if (videoModel.gameStatus == GameStatus_PLAYING) {
                [playView playTheVideo];
            }else{
                [playView removeFromSuperview];
            }
        };
    }
    return _coverView;
}

@end
