//
//  ZXNavigationController
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/3/23.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "ZXNavigationController.h"
#import "ZXBaseViewController.h"
#import "UINavigationController+FullscreenPopGesture.h"
#import "ZXMediaPlayerView.h"
#import "ZXBaseViewController.h"

@interface ZXNavigationController ()

@end

@implementation ZXNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.popGestureStyle = FullscreenPopGestureGradientStyle;

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    if ([viewController isKindOfClass:[ZXBaseViewController class]]) {
        ZXBaseViewController *vc = (ZXBaseViewController*)viewController;
        self.popDelegate = vc;
    }
    
    [super pushViewController:viewController animated:animated];
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    ZXBaseViewController *vc = (ZXBaseViewController*)[super popViewControllerAnimated:animated];
    if ([vc respondsToSelector:@selector(onPopViewControllerAnimated:)]) {
        [vc onPopViewControllerAnimated:animated];
    }
    return vc;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
    
}

@end
