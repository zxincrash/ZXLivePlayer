//
//  ZXMediaPlayerModel.m
//  MediaPlayer
//
//  Created by zhaoxin on 2017/10/25.
//  Copyright © 2017年 zhaoxin. All rights reserved.
//

#import "ZXMediaPlayerModel.h"

#import "ZXMediaPlayer.h"

@implementation ZXMediaPlayerModel

- (UIImage *)placeholderImage {
    if (!_placeholderImage) {
        _placeholderImage = MediaPlayerImage(@"MediaPlayer_loading_bgView");
    }
    return _placeholderImage;
}


@end
