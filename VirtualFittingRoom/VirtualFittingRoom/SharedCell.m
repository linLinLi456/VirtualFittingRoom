//
//  SharedCell.m
//  SharedView
//
//  Created by qianfeng on 15/10/3.
//  Copyright (c) 2015年 李娟. All rights reserved.
//

#import "SharedCell.h"
#import "UIImageView+WebCache.h"
#import "Define.h"


@implementation SharedCell
-(void)awakeFromNib{
    self.layer.cornerRadius=5;
    self.backgroundColor=[UIColor whiteColor];
    self.layer.borderWidth=0.5;
    self.layer.borderColor=[[UIColor grayColor]CGColor];
}
-(void)setModel:(CellModel *)model{
    if (_model!=model) {
        _model=model;
        
        [self.imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:kImage,model.SmallPath]] placeholderImage:[UIImage imageNamed:@"loading.png"]];
        self.textlabel.text=model.Remark;
    }
}
@end
