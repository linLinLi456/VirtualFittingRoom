//
//  ChooesCell.h
//  VirtualFittingRoom
//
//  Created by qianfeng on 15/10/4.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#define typeID @"cellID"
#import "ChooesModel.h"

@protocol ChooesCellDelegate <NSObject>

-(void)clothTypeID:(NSString *)typeId;
@end

@interface ChooesCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooesBtn;


@property(nonatomic)ChooesModel *model;
@property(nonatomic,copy)NSString *sortsIDStr;
@property(nonatomic,weak)id<ChooesCellDelegate>delegate;
@end
