//
//  AboutClothViewController.h
//  VirtualFittingRoom
//
//  Created by qianfeng on 15/10/5.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AboutClothViewControllerDelegate <NSObject>

-(void)clothUrl:(NSString *)string;

@end

@interface AboutClothViewController : UIViewController
-(void)loadDataWithUrl:(NSString *)url;
@property(nonatomic,copy)void(^clothHandler)(NSString *clothtring);
@property(nonatomic,weak)id<AboutClothViewControllerDelegate>delegate;
@end
