//
//  NearByViewController.m
//  VirtualFittingRoom
//
//  Created by qianfeng on 15/10/7.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import "NearByViewController.h"
#import "SharedCell.h"
#import "UIImage+util.h"
#import "Define.h"
#import "AFNetworking.h"
#import "JHRefresh.h"
#import "CellModel.h"
#import "JSONModel.h"
#import "NearViewController.h"



@interface NearByViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic)UICollectionView *collectionview;
@property(nonatomic)NSMutableArray *modelArray;
@property(nonatomic)BOOL isload;
@end

@implementation NearByViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addleftItem];
    [self addCollectionview];
    [self loaddata];
}
-(void)addleftItem{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 30, 30);
    [button setBackgroundImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"return2"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
}
-(void)click:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addCollectionview{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,64 , self.view.frame.size.width, 50)];
    view.backgroundColor=[UIColor greenColor];
    
    UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 50)];
    UIImage *image=[UIImage imageNamed:@"redpoint"];
    image=[image scaleToSize:image size:CGSizeMake(20, 50)];
    imageview.image=image;
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 120, 30)];
    label.text=@"大伙都在试穿";
    label.font=[UIFont boldSystemFontOfSize:20];
    
    label.textColor=[UIColor whiteColor];
    [view addSubview:imageview];
    [view addSubview:label];
    
    [self.view addSubview:view];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.itemSize=CGSizeMake(110, 180);
    layout.minimumInteritemSpacing=10;
    layout.minimumLineSpacing=5;
    layout.sectionInset=UIEdgeInsetsMake(5, 10, 5, 10);
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    
    CGRect frame=self.view.frame;
    frame.origin.y=CGRectGetMaxY(view.frame);
    frame.size.height=frame.size.height-50-64;
    
    self.collectionview=[[UICollectionView alloc]initWithFrame:frame collectionViewLayout:layout];
    _collectionview.backgroundColor=[UIColor whiteColor];
    
    _collectionview.delegate=self;
    _collectionview.dataSource=self;
    _collectionview.scrollEnabled=YES;
    [_collectionview registerNib:[UINib nibWithNibName:@"SharedCell" bundle:nil] forCellWithReuseIdentifier:@"cellid"];
    
    __weak typeof(self) weakself = self;
    [_collectionview addRefreshFooterViewWithAniViewClass:[JHRefreshAmazingAniView class] beginRefresh:^{
        if(weakself.isload) return ;
        weakself.page++;
        [weakself loaddata];
        weakself.isload=YES;
    }];
    
    [self.view addSubview:_collectionview];
    
}


-(NSInteger)page{
    if (_page==0) {
        _page=1;
    }
    return _page;
}
-(NSMutableArray *)modelArray{
    if (_modelArray==nil) {
        _modelArray=[NSMutableArray array];
        
    }
    return _modelArray;
}


-(void)endrefresh{
    if (self.isload) {
        [_collectionview footerEndRefreshing];
    }
    _isload=NO;
}
-(void)loaddata{
    AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:kMuch,self.clothid,self.page] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self endrefresh];
        
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        JSONModelArray *models=[[JSONModelArray alloc]initWithArray:arr modelClass:[CellModel class]];
        for (CellModel *model in models) {
            [self.modelArray addObject:model];
        }
        
      //  self.collectionview.contentSize=CGSizeMake(0, self.modelArray.count*190);

        [_collectionview reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark-<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.modelArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SharedCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    CellModel *model=self.modelArray[indexPath.row];
    cell.model=model;
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CellModel *model=self.modelArray[indexPath.row];
    
    NearViewController *controller=[[NearViewController alloc]init];
    
    [controller fetchWebDataWithUrl:[NSString stringWithFormat:kpicture,model.ShareID]];
    
    controller.urlPath = [NSString stringWithFormat:kPL,model.ShareID];
    controller.shareId=model.ShareID;
    
    
   // [self presentViewController:nvc animated:YES completion:nil];
    [self.navigationController pushViewController:controller animated:YES];
}


@end
