//
//  TextCell.h
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/4/16.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface  TextCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *label;
- (void)setSelected:(BOOL)selected;
+ (NSString *)reuseIdentifier;
@end

