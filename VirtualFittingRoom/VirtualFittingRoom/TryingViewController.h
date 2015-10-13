//
//  FittingViewController.h
//  VirtualFittingRoom
//
//  Created by qianfeng on 15-10-3.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooesModel.h"
#import "ClothModel.h"

@interface TryingViewController : UIViewController

@property (nonatomic, copy) void (^myHandler)(BOOL isPresen);

@property (nonatomic) ClothModel *clothModel;
@property (nonatomic) ChooesModel *chooesModel;
@property (nonatomic, copy) NSString *clothingName;
//- (void)initWithModel:(id)model;

@end
