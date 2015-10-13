//
//  PhotoViewController.m
//  VirtualFittingRoom
//
//  Created by qianfeng on 15/10/4.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import "PhotoViewController.h"


@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageview=[[UIImageView alloc]initWithFrame:self.view.bounds];
    self.imageview.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.imageview addGestureRecognizer:tap];
    [self.view addSubview:_imageview];
}
-(void)tap:(UIGestureRecognizer *)tap{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
