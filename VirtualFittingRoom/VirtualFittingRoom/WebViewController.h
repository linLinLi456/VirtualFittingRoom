//
//  WebViewController.h
//  VirtualFittingRoom
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController<UIWebViewDelegate>
@property(nonatomic)NSString *url;

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
-(void)webViewDidStartLoad:(UIWebView *)webView;
-(void)webViewDidFinishLoad:(UIWebView *)webView;

@end
