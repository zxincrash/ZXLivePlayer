//
//  NSMutableArray+Safe.h
//  ZXLivePlayer
//
//  Created by zhaoxin on 2017/10/27.
//  Copyright © 2017年 zhaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Safe)

- (void)addObjectSafe:(id)anObject;

@end

@interface NSArray (Safe)

- (id)objectAtIndexSafe:(NSUInteger)index;

@end
