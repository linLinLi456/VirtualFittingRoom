//
//  FirstCell.h
//  Demo
//
//  Created by qianfeng007 on 15-10-4.
//  Copyright (c) 2015年 李娟. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kFirstCell @"cellID"
#import "FirstModel.h"

@interface FirstCell : UICollectionViewCell
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UILabel *lable;

@property (nonatomic) FirstModel *model;
@end
