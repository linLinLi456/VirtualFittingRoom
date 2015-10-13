//
//  UIViewController+util.m
//  VirtualFittingRoom
//
//  Created by qianfeng on 15-10-3.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//


#import "UIViewController+util.h"
#import "UIImage+util.h"

@implementation UIViewController (util)

+ (instancetype) viewControllerWithTabTitle:(NSString*)title image:(UIImage*)image selectedImage:(UIImage *)selectedImage {
    CGSize size = CGSizeMake(25, 25);
    UIImage *newImage = [image scaleToSize:image size:size];
    UIImage *newSelectedImage = [selectedImage scaleToSize:selectedImage size:size];
    UIViewController *controller = [[[self class] alloc] init];
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:newImage selectedImage:[newSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    controller.tabBarItem = item;
    return controller;
}

- (void)setTitleView:(NSString *)title frame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    label.text = title;
    label.textColor = [UIColor orangeColor];
    self.navigationItem.titleView = label;
}
@end
