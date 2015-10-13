//
//  rightScrollCell.m
//  VirtualFittingRoom
//
//  Created by qianfeng007 on 15-10-7.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import "rightScrollCell.h"
#import "DBManager.h"
#import "UIImageView+WebCache.h"

@implementation rightScrollCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-20)]; // 让imageView和当前item一样大
       // NSMutableArray *array = [[DBManager sharedInstance]fetch];
      //  NSLog(@"%@",array);
      //   ClothModel *model = [ClothModel new];
//        for (int i = 0; i < array.count; i++) {
//
            // 设置边框
            self.imageView.layer.borderColor = [[UIColor grayColor] CGColor];
            self.imageView.layer.borderWidth = 1.0;
            self.imageView.layer.cornerRadius = 5.0;
       //下载图片
        
        NSString *str = @"http://clothing.yyasp.net/Upload/Clothing/0/2334.jpg";
        NSURL *url = [NSURL URLWithString:str];
            [self.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"loading.png"]];
        self.imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}


@end
