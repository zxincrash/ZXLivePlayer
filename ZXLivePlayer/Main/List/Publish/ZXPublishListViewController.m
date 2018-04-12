//
//  ZXPublishListViewController.m
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/3/29.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "ZXPublishListViewController.h"
#import "ZXPublishDetailViewController.h"

@interface ZXPublishListViewController ()

@end

@implementation ZXPublishListViewController

- (void)viewDidLoad {
    self.mediaPalyerType = MediaPlayerType_PUSH;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    self.mediaPalyerType = MediaPlayerType_PUSH;
    
    [super viewWillAppear:animated];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ZXPublishListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        
    }
    cell.textLabel.text = @"推流测试";
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZXPublishDetailViewController *publishDetailVC = [ZXPublishDetailViewController new];
    [self.navigationController pushViewController:publishDetailVC animated:YES];
}
@end
