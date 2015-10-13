//
//  UIViewController+util.h
//  VirtualFittingRoom
//
//  Created by qianfeng on 15-10-3.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIViewController (util)

+ (instancetype)viewControllerWithTabTitle:(NSString*)title image:(UIImage*)image selectedImage:(UIImage *)selectedImage;
- (void)setTitleView:(NSString *)title frame:(CGRect)frame;

@end
