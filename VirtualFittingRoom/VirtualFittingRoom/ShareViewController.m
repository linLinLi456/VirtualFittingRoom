//
//  ShareViewController.m
//  VirtualFittingRoom
//
//  Created by qianfeng on 15-10-3.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import "ShareViewController.h"
#import "SharedCell.h"
#import "JHRefresh.h"
#import "AFNetworking.h"
#import "Define.h"
#import "DetailViewController.h"

@interface ShareViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic)NSMutableArray *modelArray;
@property(nonatomic)UIButton *lastselectedbutton;
@property(nonatomic)UICollectionView *collectionview;
@property(nonatomic)BOOL isloading;

@end

@implementation ShareViewController
-(NSMutableArray *)modelArray{
    if (_modelArray==nil) {
        _modelArray=[[NSMutableArray alloc]init];
    }
    return _modelArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 64)];
    label.text=@"分享";
    label.textColor=[UIColor orangeColor];
    label.font=[UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    //label.textAlignment=NSTextAlignmentLeft;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:label];
    
    [self creatCollectionView];
    [self addScrollview];
}
-(void)addScrollview{
    UIScrollView *scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(65, 7, self.view.frame.size.width - 75, 30)];
    NSArray *titles=@[@"全部",@"精华",@"美女",@"萌翻天",@"帅哥",@"卧槽"];
    for (int i=0; i<6; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeSystem];
        button.frame=CGRectMake(i*60, 0, 60, 30);
        button.layer.borderColor=[[UIColor orangeColor]CGColor];
        button.layer.borderWidth=1;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.tintColor=[UIColor clearColor];
        button.tag=100+i;
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [scrollview addSubview:button];
        
        if (i==1) {
            button.selected=YES;
            button.backgroundColor=[UIColor orangeColor];
            _lastselectedbutton=button;
        }
    }
    [scrollview setContentSize:CGSizeMake(360, 0)];
    [self.navigationController.navigationBar addSubview:scrollview];
    scrollview.showsHorizontalScrollIndicator=NO;
    
    self.pageIndex=1;
    self.isbest=1;
    [self fetchWebData];
}
-(void)fetchWebData{
    [self fetchWebDataWithUrl:[NSString stringWithFormat:kBest,self.pageIndex,self.isbest]];
}
-(void)fetchWebDataWithUrl:(NSString *)url{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
  
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self endRefresh];
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (arr.count != 19) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"没有更多数据了..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return ;
        }

        for (int i=0; i< 18; i++) {
            NSDictionary *dict=arr[i];
            CellModel *model=[[CellModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.modelArray addObject:model];
        }
        
        [_collectionview reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请求数据失败" message:@"可能由于网络问题..." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
    }];
}
-(void)click:(UIButton *)button{
    [self.modelArray removeAllObjects];
    if (_lastselectedbutton!=button) {
        _lastselectedbutton.selected=NO;
        _lastselectedbutton.backgroundColor=[UIColor clearColor];
        
        button.selected=YES;
        button.backgroundColor=[UIColor orangeColor];
        
        switch (button.tag) {
            case 100:{
                self.pageIndex=1;
                self.isbest=0;
          
                
                  [self fetchWebData];
            }
                break;
            case 101:{
                self.pageIndex=1;
                self.isbest=1;
                [self fetchWebData];
            }
                
                break;
            case 102:{
                
                /// @"http://clothing.yyasp.net/SharePicture_Phone.aspx?type=picture2&pageSize=15&pageIndex=%ld&isbest=%ld&sn=&recordCount=0"
                self.pageIndex=1;
                self.isbest=12;
                [self fetchWebData];
            }
                break;
            case 103:{
                self.pageIndex=1;
                self.isbest=14;
                
                [self fetchWebData];}
                break;
            case 104:{
                self.pageIndex=1;
                self.isbest=11;
                
                [self fetchWebData];}
                break;
            case 105:{
                self.pageIndex=1;
                self.isbest=13;
                
                [self fetchWebData];}
                break;
                
            default:
                break;
        }

        
        _lastselectedbutton=button;

    }else{
        _lastselectedbutton.selected=YES;
        _lastselectedbutton.backgroundColor=[UIColor orangeColor];
    }
    
    }
-(void)creatCollectionView{
    
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing=10;
    layout.minimumInteritemSpacing=10;

    CGFloat width = self.view.frame.size.width;
    
    if (width > 360) {
        width = (width - 110 * 3) / 4;
    } else {
        width = (width - 110 * 2) / 3;    }
    
    layout.itemSize=CGSizeMake(110, 180);
    layout.sectionInset=UIEdgeInsetsMake(10, width, 10, width);
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    
    _collectionview=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49) collectionViewLayout:layout];
    _collectionview.backgroundColor=[UIColor whiteColor];
    _collectionview.delegate=self;
    _collectionview.dataSource=self;
    [self.view addSubview:_collectionview];
    
    [_collectionview registerNib:[UINib nibWithNibName:@"SharedCell" bundle:nil] forCellWithReuseIdentifier:@"cellid"];
    __weak typeof(self)weakself=self;
    [_collectionview addRefreshFooterViewWithAniViewClass:[JHRefreshAniBaseView class] beginRefresh:^{
        if (weakself.isloading) {
            return ;
        }
        weakself.pageIndex++;
        weakself.isloading=YES;
        [weakself fetchWebData];
    }];
}
-(void)endRefresh{
    if (self.isloading) {
        [_collectionview footerEndRefreshing];
    }
    _isloading=NO;
}
#pragma mark-<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
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
    
    DetailViewController *controller=[[DetailViewController alloc]init];
    UINavigationController *nvc=[[UINavigationController alloc]initWithRootViewController:controller];
    
    [controller fetchWebDataWithUrl:[NSString stringWithFormat:kpicture,model.ShareID]];
    
    controller.urlPath = [NSString stringWithFormat:kPL,model.ShareID];
    controller.shareId=model.ShareID;
    
    
    [self presentViewController:nvc animated:YES completion:nil];
    //[self.navigationController pushViewController:nvc animated:YES];
}
@end
