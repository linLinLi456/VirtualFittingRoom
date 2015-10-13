//
//  SearchViewController.h
//  VirtualFittingRoom
//
//  Created by qianfeng on 15/10/3.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooesModel.h"
@interface SearchViewController : UIViewController
@property(nonatomic,copy)void (^clothSortIDBlock)(NSString *sortID,NSString *titleName);
@end
