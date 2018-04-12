//
//  NSMutableArray+Safe.m
//  ZXLivePlayer
//
//  Created by zhaoxin on 2017/10/27.
//  Copyright © 2017年 zhaoxin. All rights reserved.
//

#import "NSMutableArray+Safe.h"

@implementation NSMutableArray (Safe)

- (void)addObjectSafe:(id)anObject
{
    if (anObject != nil)
    {
        [self addObject:anObject];
    }
}

@end

@implementation NSArray (Safe)

- (id)objectAtIndexSafe:(NSUInteger)index
{
    return index < self.count ? self[index] : nil;
}

@end
