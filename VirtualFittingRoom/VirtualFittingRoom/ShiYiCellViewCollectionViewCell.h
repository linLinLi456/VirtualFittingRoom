//
//  ShiYiCellViewCollectionViewCell.h
//  VirtualFittingRoom
//
//  Created by qianfeng007 on 15-10-10.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kShiYiCell @"ShiYiCell"

@interface ShiYiCellViewCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *deletedButton;

@end
