//
//  WebViewController.m
//  VirtualFittingRoom
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
{
    UIWebView *_webview;
    UIActivityIndicatorView *_activityIndicator;
    UIView *_view;
}
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addleftItem];
    
    self.navigationController.toolbar.hidden = YES;
    
    self.title = @"购买";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20],NSForegroundColorAttributeName:[UIColor orangeColor]}];
    
    
    _webview = [[UIWebView alloc]initWithFrame:self.view.bounds];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    _webview.delegate = self;
    
    [self.view addSubview:_webview];
    
    [_webview loadRequest:request];
    
}

-(void)addleftItem{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 30, 30);
    [button setBackgroundImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"return2"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
}
-(void)click:(UIButton *)button{
    button.selected = !button.selected;
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error);
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"正在加载");
    
    _view = [[UIView alloc] initWithFrame:self.view.bounds];
    [_view setTag:108];
    [_view setBackgroundColor:[UIColor grayColor]];
    [_view setAlpha:0.5];
    
    [self.view addSubview:_view];
    
  _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    
    [_activityIndicator setCenter:_view.center];
    
    [_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    
    [_view addSubview:_activityIndicator];
    
    
    [_activityIndicator startAnimating];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"加载完成");
    [_activityIndicator stopAnimating];
    
    [_view removeFromSuperview];
}


@end
