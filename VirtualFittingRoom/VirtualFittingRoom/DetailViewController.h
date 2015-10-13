//
//  DetailViewController.h
//  VirtualFittingRoom
//
//  Created by qianfeng on 15/10/4.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"
#import "ClothModel1.h"
#import "AFNetworking.h"
#import "Comment.h"
#import "DataManager.h"
#import "Define.h"


@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *originalimage;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UILabel *Seelabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *Yeslabel;
@property (weak, nonatomic) IBOutlet UILabel *Nolabel;
@property (weak, nonatomic) IBOutlet UILabel *clothInfo;
@property (weak, nonatomic) IBOutlet UILabel *OtherInfo;
@property (weak, nonatomic) IBOutlet UIView *Headview;

@property(nonatomic)UICollectionView *collectionview;
@property (weak, nonatomic) IBOutlet UIButton *ZanButton;
@property (weak, nonatomic) IBOutlet UIButton *CaiButton;
@property (weak, nonatomic) IBOutlet UIButton *collectbutton;
@property (weak, nonatomic) IBOutlet UIButton *buy;
@property (weak, nonatomic) IBOutlet UIButton *share;
@property(nonatomic)DetailModel *detail;
@property(nonatomic)ClothModel1 *cloth;

@property(nonatomic)AFHTTPRequestOperationManager *manager;

@property(nonatomic)JSONModelArray *Models;
@property (nonatomic, copy) NSString *urlPath;
@property(nonatomic)NSNumber *shareId;
@property(nonatomic)NSInteger num;


-(void)fetchWebDataWithUrl:(NSString *)url;
-(void)loadData:(NSString *)url ;

@end
