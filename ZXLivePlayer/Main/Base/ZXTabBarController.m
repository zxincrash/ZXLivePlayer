//
//  ZXTabBarController
//  ZXLivePlayer
//
//  Created by zhaoxin on 2017/12/18.
//  Copyright © 2017年 zhaoxin. All rights reserved.
//

#import "ZXTabBarController.h"
#import "ZXNavigationController.h"

#import "ZXVodListViewController.h"
#import "ZXLiveListViewController.h"
#import "ZXPublishListViewController.h"

#import "ZXCommon.h"

@interface ZXTabBarController ()<UITabBarControllerDelegate>
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation ZXTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.translucent = NO;
    self.tabBar.tintColor = HEX_RGB(white);
    
    ZXNavigationController *vodNav = [self createNavigationControllerWithClass:[ZXVodListViewController class] imageName:@"nav_match" seletedImageName:@"nav_match_s" title:@"点播"];
    ZXNavigationController *liveNav = [self createNavigationControllerWithClass:[ZXLiveListViewController class] imageName:@"nav_personal" seletedImageName:@"nav_personal_s" title:@"直播"];
    ZXNavigationController *publishNav = [self createNavigationControllerWithClass:[ZXPublishListViewController class] imageName:@"nav_personal" seletedImageName:@"nav_personal_s" title:@"推流"];

    
    self.viewControllers = @[vodNav,liveNav,publishNav];
    
    self.delegate = self;
    
    
    NSDictionary  *attributes_normal = @{
                                      NSFontAttributeName:[UIFont systemFontOfSize:10],
                                      NSForegroundColorAttributeName:
                                          HEX_RGBA(0xA6A6A6, 1),
                                      NSBackgroundColorAttributeName:
                                          [UIColor clearColor],
                                      };
    NSDictionary  *attributes_select = @{
                                  NSFontAttributeName:[UIFont systemFontOfSize:10],
                                  NSForegroundColorAttributeName:
                                      HEX_RGBA(0xF05858, 1),
                                  NSBackgroundColorAttributeName:
                                      [UIColor clearColor],
                                  };
    [[UITabBarItem appearance] setTitleTextAttributes:attributes_normal forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:                                                         attributes_select forState:UIControlStateSelected];
    
    //改变tabbar 线条颜色
    CGRect rect = CGRectMake(0, 0, kScreenWidth, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   HEX_RGB(COLOR_BACKGROUND).CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.tabBar setShadowImage:img];
    
    [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
    
    self.currentIndex = 0;
}


- (ZXNavigationController *)createNavigationControllerWithClass:(Class)class imageName:(NSString *)imageName seletedImageName:(NSString *)seletedImageName title:(NSString *)title
{
    UIViewController *vc = [[class alloc] init];
    vc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:seletedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.title = title;
    ZXNavigationController *nav = [[ZXNavigationController alloc] initWithRootViewController:vc];
    return nav;
}

#pragma mark - UITabBarControllerDelegate
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSInteger selectedIndex = tabBarController.selectedIndex;
    if (self.currentIndex == selectedIndex) {
        //选中当前选中的tabbar
        if ([viewController.childViewControllers.firstObject isKindOfClass:[ZXVodListViewController class]]) {
            ZXVodListViewController *gameVC = viewController.childViewControllers.firstObject;
            
        }
    }else{
        
        self.currentIndex = selectedIndex;
    }
    
}
@end


