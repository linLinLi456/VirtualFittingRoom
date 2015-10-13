//
//  ChooesCell.m
//  VirtualFittingRoom
//
//  Created by qianfeng on 15/10/4.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import "ChooesCell.h"
@implementation ChooesCell
- (void)awakeFromNib {
    // Initialization code
}
-(void)setModel:(ChooesModel *)model{
    if (_model != model) {
        _model = model;
        self.typeNameLabel.text = model.Name;
    }
}


@end
