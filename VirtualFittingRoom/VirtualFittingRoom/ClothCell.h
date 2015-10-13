//
//  ClothCell.h
//  ClothStore
//
//  Created by qianfeng on 15/10/3.
//  Copyright (c) 2015年 朱明科. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClothModel.h"

@protocol ClothCellDelegate <NSObject>

-(void)toTryingView:(UIButton *)button clothName:(NSString *)name;

@end

@interface ClothCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *clothImageView;
@property (weak, nonatomic) IBOutlet UILabel *clothNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttoncollection;
@property(nonatomic)ClothModel *model;

@property(nonatomic,copy)void(^tryClothModelBlock)(ClothModel *tryModel);
@property(nonatomic,weak)id<ClothCellDelegate>delegate;
@end
