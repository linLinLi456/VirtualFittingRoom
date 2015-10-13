//
//  SharedCell.h
//  SharedView
//
//  Created by qianfeng on 15/10/3.
//  Copyright (c) 2015年 李娟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellModel.h"


@interface SharedCell : UICollectionViewCell

@property(nonatomic)CellModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *textlabel;

@end
