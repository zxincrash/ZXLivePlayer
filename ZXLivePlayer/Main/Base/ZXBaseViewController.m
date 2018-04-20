//
//  ZXBaseViewController.h
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/3/23.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "ZXBaseViewController.h"

#import "ZXVodListViewController.h"
#import "ZXLiveListViewController.h"
#import "MMMaterialDesignSpinner.h"

@interface ZXBaseViewController ()
@property (strong, nonatomic) MMMaterialDesignSpinner *activity;

@end

@implementation ZXBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = HEX_RGB(COLOR_BACKGROUND);
    
    //设置状态栏
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    //设置导航栏
    self.navigationController.navigationBar.barTintColor = HEX_RGB(COLOR_NAVIGATION);
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:16];
    normalAttrs[NSForegroundColorAttributeName] = HEX_RGB(white);
    self.navigationController.navigationBar.titleTextAttributes = normalAttrs;
    
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];

}
#pragma -mark 导航栏
/** leftBarButtonItem */
-(void)addLeftBarButtonItemWithType:(ZXNavigationBarType)type{
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc]initWithBarButtonItemType:type target:self action:@selector(leftBarButtonItemClick:)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
}

-(void)leftBarButtonItemClick:(id)sender{
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton*)sender;
        if (ZXNavigationBarType_BACK == button.tag) {
            [self.navigationController popViewControllerAnimated:YES];
        }

    }
}

/** rightBarButtonItem */
-(void)addRightBarButtonItemWithType:(ZXNavigationBarType)type{
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithBarButtonItemType:type target:self action:@selector(rightBarButtonItemClick:)];
    
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

-(void)rightBarButtonItemClick:(id)sender{
    
}


#pragma mark -- 刷新相关
- (void)addHeaderAndFooterWithView:(UIScrollView *)view
{

    
}

- (void)headerRefreshing
{
    
}

- (void)footerRefreshing
{
    
}

#pragma -mark 加载
-(MMMaterialDesignSpinner *)activity{
    if(_activity == nil){
        _activity = [[MMMaterialDesignSpinner alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _activity.lineWidth = 2;
        _activity.center = CGPointMake(self.view.centerX, self.view.centerY-60);
        [self.view addSubview:_activity];
    }
    return _activity;
}

-(void)startLoading{
    [self.activity startAnimating];
}

-(void)stopLoading{
    [self.activity stopAnimating];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
