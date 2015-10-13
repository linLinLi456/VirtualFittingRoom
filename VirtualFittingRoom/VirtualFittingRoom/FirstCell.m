//
//  FirstCell.m
//  Demo
//
//  Created by qianfeng007 on 15-10-4.
//  Copyright (c) 2015年 李娟. All rights reserved.
//

#import "FirstCell.h"
#import "UIImageView+AFNetworking.h"
#import "test.h"

@implementation FirstCell
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-20)]; // 让imageView和当前item一样大
        // 设置边框
        self.imageView.layer.borderColor = [[UIColor grayColor] CGColor];
        self.imageView.layer.borderWidth = 1.0;
        self.imageView.layer.cornerRadius = 5.0;
    
        [self.contentView addSubview:self.imageView];
        //label
        self.lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height +130)];
        self.lable.textAlignment = NSTextAlignmentCenter;
        self.lable.font = [UIFont boldSystemFontOfSize:13];
        [self.contentView addSubview:self.lable];
    }
    return self;
}

- (void)setModel:(FirstModel *)model {
    if (_model != model) {
        _model = model;
        self.lable.text = model.Remark;
        NSString *str = [NSString stringWithFormat:@"%@%@",kDownload,model.SmallPath];
        NSURL *url = [NSURL URLWithString:str];
        [self.imageView setImageWithURL:url];//下载图片
        self.imageView.userInteractionEnabled = 1;
    }
}



@end
