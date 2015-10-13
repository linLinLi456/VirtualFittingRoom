//
//  MyFootView.m
//  Demo
//
//  Created by qianfeng007 on 15-10-4.
//  Copyright (c) 2015年 李娟. All rights reserved.
//

#import "MyFootView.h"

@implementation MyFootView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    UILabel *label = [UILabel new];
    label.text = @"上拉换一组...";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:18];
    label.frame = CGRectMake(20, 0, self.frame.size.width - 40, 30);
    [self addSubview:label];
}
@end
