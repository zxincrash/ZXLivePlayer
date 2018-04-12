//
//  DQChangeAngleModel.h
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/2/3.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DQChangeAngleModel : NSObject
@property (copy, nonatomic) NSString *Live_ID;
@property (copy, nonatomic) NSString *Live_Guid;
@property (copy, nonatomic) NSString *Live_URL;//播放地址
@property (copy, nonatomic) NSString *Live_File_Type;//地址类型
@property (copy, nonatomic) NSString *Live_Home_Name;//房间名称
@property (copy, nonatomic) NSString *Live_PassWord;//房间号密码
@property (copy, nonatomic) NSString *Live_Remarks_Right;//右下角备注
@property (copy, nonatomic) NSString *Live_Type;//固定还是直播
@property (copy, nonatomic) NSString *Live_OrderNo;//序号
@property (copy, nonatomic) NSString *Live_Time;//开播时间
@property (copy, nonatomic) NSString *Live_Start_Time;//开始时间

@property (copy, nonatomic) NSString *Live_Match_Guid;//场次guid
@property (copy, nonatomic) NSString *Live_Data_Stream1;
@property (copy, nonatomic) NSString *Live_Data_Stream2;
@property (copy, nonatomic) NSString *Live_Data_Stream3;
@property (copy, nonatomic) NSString *Live_Data_Stream4;
@property (copy, nonatomic) NSString *Live_Data_Stream5;

@property (copy, nonatomic) NSString *Live_Reserve1;
@property (copy, nonatomic) NSString *Live_Reserve2;
@property (copy, nonatomic) NSString *Live_Reserve3;
@property (copy, nonatomic) NSString *Live_Reserve4;
@property (copy, nonatomic) NSString *Live_Reserve5;

@end
