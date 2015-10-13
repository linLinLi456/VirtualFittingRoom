//
//  MyViewController.m
//  VirtualFittingRoom
//
//  Created by qianfeng on 15-10-3.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import "MyViewController.h"
#import "UIViewController+util.h"
#import "UIImage+util.h"

#import "FirstViewController.h"
#import "ClothesViewController.h"
#import "TryingViewController.h"
#import "ShareViewController.h"
#import "MySettingController.h"

@interface MyViewController ()

@property (nonatomic) BOOL isPresen;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewController];
}

- (void)setViewController {
    self.tabBar.TintColor = [UIColor orangeColor];
    FirstViewController *homeController = (FirstViewController *)[FirstViewController viewControllerWithTabTitle:@"首页" image:[UIImage imageNamed:@"btn_bottom_default_1.png"] selectedImage:[UIImage imageNamed:@"btn_bottom_default_2.png"]];
    [homeController setTitleView:@"虚拟试衣间" frame:CGRectMake(6, (self.view.frame.size.width - 80) / 2.0, 80, 32)];
    UINavigationController *homeNivController = [[UINavigationController alloc] initWithRootViewController:homeController];
    
    //衣库
    ClothesViewController *clothesViewController = (ClothesViewController *)[ClothesViewController viewControllerWithTabTitle:@"衣库" image:[UIImage imageNamed:@"btn_bottom_clothing_1.png"] selectedImage:[UIImage imageNamed:@"btn_bottom_clothing_2.png"]];
//    [clothesViewController setTitleView:@"所有类型的衣服" frame:CGRectMake(6, 15, 80, 20)];
    UINavigationController *clothesNivController = [[UINavigationController alloc] initWithRootViewController:clothesViewController];
    
    TryingViewController *tryingViewController = [[TryingViewController alloc] init];
    UITabBarItem *item = [[UITabBarItem alloc] init];
    tryingViewController.tabBarItem = item;
    
    
    ShareViewController *shareController = (ShareViewController *)[ShareViewController viewControllerWithTabTitle:@"分享" image:[UIImage imageNamed:@"btn_bottom_share_1.png"] selectedImage:[UIImage imageNamed:@"btn_bottom_share_2.png"] ];
    
    UINavigationController *shareNivController = [[UINavigationController alloc] initWithRootViewController:shareController];

    MySettingController *settingController = (MySettingController *)[MySettingController viewControllerWithTabTitle:@"个人" image:[UIImage imageNamed:@"btn_bottom_me_1.png"] selectedImage:[UIImage imageNamed:@"btn_bottom_me_2.png"]];
    [settingController setTitleView:@"个人中心" frame:CGRectMake(6, (self.view.frame.size.width - 80) / 2.0, 80, 32)];
    UINavigationController *settingNivController = [[UINavigationController alloc] initWithRootViewController:settingController];

    self.viewControllers = @[homeNivController, clothesNivController, tryingViewController, shareNivController, settingNivController];
    [self addCenterButton];
}


- (void)addCenterButton {
    UIImage *bgImage = [UIImage imageNamed:@"bg_bottom_center.png"];
    UIImage *image = [UIImage imageNamed:@"btn_bottom_room_1.png"];
    UIImage *highlitedImage = [UIImage imageNamed:@"btn_bottom_room_2.png"];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[bgImage scaleToSize:bgImage size:CGSizeMake(49, 60)] forState:UIControlStateNormal];
    
    button.frame = CGRectMake(0.0, 0.0, bgImage.size.width, bgImage.size.height);
    UIView *smallView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 5.0 + 10, bgImage.size.height)];
    button.center = smallView.center;
    [smallView addSubview:button];
    smallView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    [button setBackgroundImage:[bgImage scaleToSize:bgImage size:CGSizeMake(49, 60)] forState:UIControlStateNormal];
    [button setBackgroundImage:[bgImage scaleToSize:bgImage size:CGSizeMake(49, 60)] forState:UIControlStateHighlighted];
    
    [button setImage: [highlitedImage scaleToSize:highlitedImage size:CGSizeMake(25, 25)] forState:UIControlStateHighlighted];
    [button setImage:[image scaleToSize:image size:CGSizeMake(25, 25)] forState:UIControlStateNormal];
    CGFloat heightDifference = bgImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        smallView.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        smallView.center = center;
    }
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.tabBar addSubview:button];
    [self.view addSubview:smallView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 30) / 2.0 ,self.view.frame.size.height - 12, 30, 8)];
    label.text = @"试衣间";
    label.adjustsFontSizeToFitWidth = YES;
    label.textColor = [UIColor blackColor];
    [self.view addSubview:label];
    
}

- (void)buttonClick:(UIButton *)button {
    
    TryingViewController *controller = [[TryingViewController alloc] init];
    
    __weak typeof(self) mySelf = self;
    
    controller.myHandler = ^(BOOL isPresen) {
        mySelf.isPresen = isPresen;
    };
    [self presentViewController:controller animated:YES completion:^{
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.isPresen) {
        self.selectedIndex = 1;
    }
    self.isPresen = NO;
    
}


@end
