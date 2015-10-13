//
//  ClothCell.m
//  ClothStore
//
//  Created by qianfeng on 15/10/3.
//  Copyright (c) 2015年 朱明科. All rights reserved.
//

#import "ClothCell.h"
#import "UIImageView+AFNetworking.h"
#import "DBManager.h"
#import "TryingViewController.h"
#define imageUrl @"http://clothing.yyasp.net/download.aspx?Clothing=%@"

@implementation ClothCell

- (void)awakeFromNib {
    //[self checkIsExist];
}
-(void)checkIsExist{
    BOOL flag = [[DBManager sharedInstance]isExistClothForImage:self.model.image];
    if (flag) {
        [self.buttoncollection setTitle:@"已收藏" forState:UIControlStateNormal];
        [self.buttoncollection setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.buttoncollection setBackgroundImage:[UIImage imageNamed:@"bg_btn_button_2.png"] forState:UIControlStateNormal];
    }
}
-(void)setModel:(ClothModel *)model{
    if (_model != model) {
        _model = model;
        self.clothNameLabel.text = model.name;
        NSString *string = [NSString stringWithFormat:imageUrl,model.image];
        string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:string];
        [self.clothImageView setImageWithURL:url];
        
        if (self.tryClothModelBlock) {
            self.tryClothModelBlock(model);
        }
    }
}
//收藏
- (IBAction)colletBtn:(UIButton *)button {
//    button.enabled = NO;
//    [[DBManager sharedInstance]insertModel:self.model];
     button.selected = !button.selected;

   
    if (button.selected) {
        [[DBManager sharedInstance]insertModel:self.model];
        [button setTitle:@"已收藏" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"bg_btn_button_2.png"] forState:UIControlStateNormal];
    }else{
        [[DBManager sharedInstance]deleteModel:self.model];
        [button setTitle:@"收藏" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"bg_btn_button_1.png"] forState:UIControlStateNormal];
        
    }
}
- (IBAction)tryClothBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(toTryingView: clothName:)]) {
        [self.delegate toTryingView:sender clothName:self.model.cloth];
    }
}

@end
