//
//  TextCell.m
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/4/16.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "TextCell.h"
#import "ZXMediaPlayer.h"

@implementation TextCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        self.label.textColor = [UIColor whiteColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label];
    }
    return self;
}

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

- (void)setSelected:(BOOL)selected
{
    if(selected){
        self.label.textColor = UIColorFromRGB(0x0ACCAC);
    }
    else{
        self.label.textColor = [UIColor whiteColor];
    }
}



@end

