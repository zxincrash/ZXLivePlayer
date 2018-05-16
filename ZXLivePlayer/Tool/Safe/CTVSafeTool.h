//
//  CTVSafeTool.h
//  LHChinaTV
//
//  Created by zhaoxin on 2018/5/15.
//  Copyright © 2018年 Lehoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTVSafeTool : NSObject
+ (instancetype)sharedManager;

-(void)AppSafeDetection;

@end
