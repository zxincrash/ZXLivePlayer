//
//  NSString+Category.m
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/1/4.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "NSString+Category.h"
#import <UIKit/UIKit.h>
#import <YYKit/YYkit.h>

@implementation NSString (Category)
+ (NSMutableAttributedString*)getBlackAttributedString:(NSString*)text rangStrings:(NSArray *)rangStrings{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    NSString *nStr = text;
    NSInteger beginLoc = 0;
    
    for (int i=0; i<rangStrings.count; i++) {
        NSRange range = [nStr rangeOfString:rangStrings[i]];
        range.location += beginLoc;
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#424242"] range:range];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range];
        if ((range.location+range.length) >= text.length) {
            continue;
        }
        nStr = [text substringFromIndex:range.location+range.length];
        beginLoc = text.length - nStr.length;
    }
    
    return str;
}

+(NSString *)randomString{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: 20];
    
    int len = arc4random() % 10 + 11;
    for (NSInteger i = 0; i < len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
//    [randomString replaceCharactersInRange:NSMakeRange(1, 1) withString:@"5"];
//    [randomString replaceCharactersInRange:NSMakeRange(3, 1) withString:@"G"];
    return randomString;
}

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
