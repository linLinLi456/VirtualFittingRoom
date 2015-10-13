//
//  FeedbackViewController.m
//  Demo
//
//  Created by qianfeng007 on 15-10-4.
//  Copyright (c) 2015年 李娟. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()
@property (weak, nonatomic) IBOutlet UIView *senderView;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (weak, nonatomic) IBOutlet UIButton *senderButton;
@property (weak, nonatomic) IBOutlet UITextView *textFielView;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.tabBarController.tabBar.hidden = YES;
    [self setUp];
    [self setSenderView];
}

- (void)setSenderView {
    [self.senderView addSubview:_textFielView];
    [self.senderView addSubview:_dismissButton];
    [self.senderView addSubview:_textFielView];
    self.senderView.hidden = YES;
}

- (void)setUp {
    UILabel *label = [UILabel new];
    label.text = @"留言反馈";
    label.textColor = [UIColor orangeColor];
    label.font = [UIFont boldSystemFontOfSize:22];
    label.frame = CGRectMake(0, 0, 30, 30);
    self.navigationItem.titleView = label;
    
    [self addleftItem];
    //****************************************************
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
   
    [button setImage:[[UIImage imageNamed:@"btn_write_1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [button setImage:[[UIImage imageNamed:@"btn_write_2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateSelected];
   
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 35, 35);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = item;
    
}
#pragma mark - navigation
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

- (void)clickButton:(UIButton*)button {
    self.senderView.hidden = YES;
    button.selected = !button.selected;
    if(button.selected) {
        self.senderView.hidden = NO;
        button.tintColor = [UIColor clearColor];
    }
}

#pragma mark - 右面按钮的事件

@end