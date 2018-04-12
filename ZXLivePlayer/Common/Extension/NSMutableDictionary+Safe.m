//
//  NSMutableDictionary+Safe.m
//  ZXLivePlayer
//
//  Created by zhaoxin on 2017/10/27.
//  Copyright © 2017年 zhaoxin. All rights reserved.
//

#import "NSMutableDictionary+Safe.h"

@implementation NSMutableDictionary (Safe)
- (void)setObjectSafe:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (aKey != nil && anObject != nil)
    {
        [self setObject:anObject forKey:aKey];
    }
}

@end
