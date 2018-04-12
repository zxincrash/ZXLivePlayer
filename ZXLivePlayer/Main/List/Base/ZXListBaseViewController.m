//
//  ZXListBaseViewController.m
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/3/26.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "ZXListBaseViewController.h"
#import "ZXDetailViewController.h"

@interface ZXListBaseViewController ()
@property (strong, nonatomic) UITableView *vodTable;

@end

@implementation ZXListBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self vodTable];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ZXVodListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        
    }
    cell.textLabel.text = @"直播测试";
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZXDetailViewController *detailVC = [ZXDetailViewController new];
    detailVC.mediaPalyerType = self.mediaPalyerType;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(UITableView *)vodTable{
    if (_vodTable == nil) {
        _vodTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _vodTable.dataSource = self;
        _vodTable.delegate = self;
        [self.view addSubview:_vodTable];
        [_vodTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _vodTable;
}

@end
