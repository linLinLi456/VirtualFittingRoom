//
//  ShiYiCell.m
//  VirtualFittingRoom
//
//  Created by qianfeng007 on 15-10-7.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import "ShiYiCell.h"

@implementation ShiYiCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-5)]; // 让imageView和当前item一样大
        // 设置边框
        self.imageView.layer.borderColor = [[UIColor grayColor] CGColor];
        self.imageView.layer.borderWidth = 1.0;
        self.imageView.layer.cornerRadius = 5.0;
    }
    return self;
}

@end
