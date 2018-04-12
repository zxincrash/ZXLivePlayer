//
//  NSMutableDictionary+Safe.h
//  ZXLivePlayer
//
//  Created by zhaoxin on 2017/10/27.
//  Copyright © 2017年 zhaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Safe)
- (void)setObjectSafe:(id)anObject forKey:(id<NSCopying>)aKey;

@end
