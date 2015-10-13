//
//  DownloadViewController.m
//  Demo
//
//  Created by qianfeng007 on 15-10-3.
//  Copyright (c) 2015年 李娟. All rights reserved.
//

#import "DownloadViewController.h"

@interface DownloadViewController ()

@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.tabBarController.tabBar.hidden = YES;
    [self addView];
    [self setUp];
}
- (void)setUp {
    UILabel *label = [UILabel new];
    label.text = @"扫码下载";
    label.textColor = [UIColor orangeColor];
    label.font = [UIFont boldSystemFontOfSize:22];
    label.frame = CGRectMake(0, 0, 30, 30);
    self.navigationItem.titleView = label;
    
    [self addleftItem];
}

- (void)addView {
    UIView *myView = [[UIView alloc] initWithFrame:self.view.frame];
    myView.backgroundColor = [UIColor grayColor];
    
    //**************************************************
    UIImageView *imageVeiw = [[UIImageView alloc] initWithFrame:CGRectMake(80, 100, 200, 200)];
    imageVeiw.image = [UIImage imageNamed:@"QRCode.png"];
    [myView addSubview:imageVeiw];
    [self.view addSubview:myView];
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
