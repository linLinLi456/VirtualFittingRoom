//
//  EditingViewController.m
//  VirtualFittingRoom
//
//  Created by qianfeng on 15/10/4.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import "EditingViewController.h"

@interface EditingViewController ()

@property(nonatomic)UITextField *textfield;
@end

@implementation EditingViewController
-(void)awakeFromNib{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTextfield];
    [self addbutton];
}
-(void)loadData:(NSString *)url{
    
}
-(void)addTextfield{
    _textfield=[[UITextField alloc]initWithFrame:CGRectMake(10, 50, self.view.frame.size.width-20, 100)];
    _textfield.borderStyle=UITextBorderStyleRoundedRect;
    _textfield.placeholder=@"请输入您的评论...";
    
    
    [self.view addSubview:_textfield];
    
}
-(void)addbutton{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeSystem];
    CGRect frame=CGRectMake(10, 160, 50, 25);
    button.frame=frame;
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius=5;
    button.layer.borderColor=[[UIColor orangeColor]CGColor];
    button.layer.borderWidth=0.5;
    [self.view addSubview:button];
    
    
    button=[UIButton buttonWithType:UIButtonTypeSystem];
    frame.origin.x=self.view.frame.size.width-10-50;
    button.frame=frame;
    [button setTitle:@"发送" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius=5;
    button.layer.borderColor=[[UIColor orangeColor]CGColor];
    button.layer.borderWidth=0.5;
    [self.view addSubview:button];

}
-(void)click:(UIButton *)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)clicked{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"请输入您的评价！！！" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    if (_textfield.text.length==0) {
        [alert show];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
