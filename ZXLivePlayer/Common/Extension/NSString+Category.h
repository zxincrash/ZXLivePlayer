//
//  NSString+Category.h
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/1/4.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Category)
+ (NSMutableAttributedString*)getBlackAttributedString:(NSString*)text rangStrings:(NSArray *)rangStrings;
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

+(NSString *)randomString;
@end
