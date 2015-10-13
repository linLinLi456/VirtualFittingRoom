//
//  ClothDetailViewController.m
//  VirtualFittingRoom
//
//  Created by qianfeng007 on 15-10-5.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import "ClothDetailViewController.h"

@interface ClothDetailViewController ()

@end

@implementation ClothDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test];
}

- (void)test {
    [self addleftItem];
}

-(void)addleftItem{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 30, 30);
    [button setBackgroundImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"return2"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(clickLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
}

-(void)clickLeftButton:(UIButton *)button{
    button.selected=!button.selected;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
