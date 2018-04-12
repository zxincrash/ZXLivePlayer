//
//  ZXLiveListViewController.m
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/3/23.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "ZXLiveListViewController.h"

@interface ZXLiveListViewController ()

@end

@implementation ZXLiveListViewController

- (void)viewDidLoad {
    self.mediaPalyerType = MediaPlayerType_LIVE;

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    self.mediaPalyerType = MediaPlayerType_LIVE;

    [super viewWillAppear:animated];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ZXLiveListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        
    }
    cell.textLabel.text = @"直播测试";
    
    return cell;
}

@end
