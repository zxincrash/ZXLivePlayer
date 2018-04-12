//
//  ZXListBaseViewController.h
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/3/26.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "ZXBaseViewController.h"

@interface ZXListBaseViewController : ZXBaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (assign, nonatomic) MediaPlayerType mediaPalyerType;

@end
