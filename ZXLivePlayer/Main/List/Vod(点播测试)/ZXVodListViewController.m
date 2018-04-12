//
//  ZXVodListViewController.m
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/3/23.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "ZXVodListViewController.h"
#import "ZXDetailViewController.h"

@interface ZXVodListViewController ()

@end

@implementation ZXVodListViewController

- (void)viewDidLoad {
    self.mediaPalyerType = MediaPlayerType_VOD;

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    self.mediaPalyerType = MediaPlayerType_VOD;
    
    [super viewWillAppear:animated];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ZXVodListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];

    }
    cell.textLabel.text = @"点播测试";

    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
