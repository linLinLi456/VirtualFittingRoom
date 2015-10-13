//
//  UniqloViewController.h
//  VirtualFittingRoom
//
//  Created by qianfeng on 15-10-3.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClothModel.h"




@interface ClothesViewController : UIViewController

@property(nonatomic)NSInteger pageIndex;
@property(nonatomic)BOOL isLoading;
@property(nonatomic)UICollectionView *collectionView;
@property(nonatomic)NSMutableArray *dataArray;
-(void)endRefresh;
@property(nonatomic,copy)NSString *isexist;
@property(nonatomic,copy)NSString *yikuTitle;
@end
