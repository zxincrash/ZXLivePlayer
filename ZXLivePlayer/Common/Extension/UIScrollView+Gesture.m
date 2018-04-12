//
//  UIScrollView+Gesture.m
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/1/5.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "UIScrollView+Gesture.h"
#import "ZXCommon.h"

@implementation UIScrollView (Gesture)
//返回YES时，手势事件会一直往下传递，无论当前层次是否对该事件进行响应。
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([self panBack:gestureRecognizer]) {
        return YES;
    }
    return NO;
    
}

- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer {
    
    //滑动返回距左边的有效长度
    int location_X =0.15*kScreenWidth;
    
    if (gestureRecognizer ==self.panGestureRecognizer) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [pan translationInView:self];
        UIGestureRecognizerState state = gestureRecognizer.state;
        if (UIGestureRecognizerStateBegan == state ||UIGestureRecognizerStatePossible == state) {
            CGPoint location = [gestureRecognizer locationInView:self];
            
            //允许每张图片都可实现滑动返回
            int temp1 = location.x;
            int temp2 = kScreenWidth;
            NSInteger XX = temp1 % temp2;
            if (point.x >0 && XX < location_X) {
                return YES;
            }
        }
    }
    return NO;
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if ([self panBack:gestureRecognizer]) {
        return NO;
    }
    return YES;
    
}

@end
