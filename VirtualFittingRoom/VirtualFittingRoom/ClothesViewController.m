//
//  UniqloViewController.m
//  VirtualFittingRoom
//
//  Created by qianfeng on 15-10-3.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import "ClothesViewController.h"
#import "ClothCell.h"

#import "AFNetworking.h"
#import "JHRefresh.h"
#import "SearchViewController.h"
#import "DBManager.h"
#import "TryingViewController.h"
#import "AboutClothViewController.h"

#define Kurl(page,sortID) [NSString stringWithFormat:@"http://clothing.yyasp.net/json.aspx?clothing=yes&VarietyID=0&pageSize=18&pageIndex=%ld&ClothingSortIDs=%@",page,sortID]

@interface ClothesViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ClothCellDelegate>
@property(nonatomic)NSMutableArray *identifierArray;
@property (nonatomic) UILabel *label;
@end

@implementation ClothesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageIndex = 1;
    [self setUI];
    [self creatCollectionView];
    [self loadData];
}
-(void)setUI{
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor orangeColor]}];
    
    if (self.yikuTitle) {
        self.navigationItem.title = self.yikuTitle;
    }else{
        self.navigationItem.title = @"所有类型的衣服";
    }
    /**
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.text = @"衣库";
    label.textColor = [UIColor orangeColor];
     */
    UIButton *clothYiKU = [UIButton buttonWithType:UIButtonTypeSystem];
    clothYiKU.frame = CGRectMake(0, 0, 50, 30);
    [clothYiKU setTitle:@"衣库" forState:UIControlStateNormal];
    [clothYiKU setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [clothYiKU addTarget:self action:@selector(clothClick:) forControlEvents:UIControlEventTouchUpInside];
    [clothYiKU.titleLabel setFont:[UIFont systemFontOfSize:18]];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:clothYiKU];
    self.navigationItem.leftBarButtonItem = item;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 30, 30);
    button.tintColor = [UIColor clearColor];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_clothing_search_1.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_clothing_search_2.png"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item2;
}
-(void)clothClick:(UIButton *)button{
    button.tintColor = [UIColor clearColor];
    self.isexist = nil;
    self.yikuTitle = @"所有类型的衣服";
    self.pageIndex = 1;
    [self setUI];
    [self creatCollectionView];
    [self loadData];
}
//搜索
-(void)buttonClick:(UIButton *)button{
    SearchViewController *controller = [[SearchViewController alloc]init];
    [controller setClothSortIDBlock:^(NSString *sortID, NSString *titleName) {
        self.isexist = sortID;
        self.yikuTitle = titleName;
        self.pageIndex = 1;
        [self setUI];
        [self creatCollectionView];
        [self loadData];
    }];
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)endRefresh{
    if (self.isLoading) {
        [_collectionView headerEndRefreshingWithResult:JHRefreshResultNone];
        [_collectionView footerEndRefreshing];
    }
    self.isLoading = NO;
    
}
-(void)creatCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(112, 210);
    layout.minimumLineSpacing = 15;
    CGFloat width;

    if (3 * 112 > self.view.frame.size.width) {
        width = (self.view.frame.size.width - 2 * 112) / 3.0;
    } else {
        width = (self.view.frame.size.width - 3 * 112) / 4.0;
    }
    layout.minimumInteritemSpacing = width;
    layout.sectionInset = UIEdgeInsetsMake(10, width, 10, width);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.identifierArray = [NSMutableArray array];

    for (int i=0; i<2000; i++) {
        NSString *string = [NSString stringWithFormat:@"ClothCellID%d",i];
        [_collectionView registerNib:[UINib nibWithNibName:@"ClothCell" bundle:nil] forCellWithReuseIdentifier:string];
        [self.identifierArray addObject:string];
    }
    //[_collectionView registerNib:[UINib nibWithNibName:@"ClothCell" bundle:nil] forCellWithReuseIdentifier:@"ClothCellID"];
    
    [self.view addSubview:_collectionView];
    
    //下拉刷新
    __weak typeof(self)weakself = self;
    [_collectionView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakself.isLoading) {
            return ;
        }
        weakself.pageIndex = 1;
        weakself.isLoading = YES;
        [weakself loadData];
    }];
    //上拉加载
    [_collectionView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakself.isLoading) {
            return ;
        }
        weakself.isLoading = YES;
        ++weakself.pageIndex;
        [weakself loadData];
    }];
    
}
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
//请求数据
-(void)loadData{
    
    if (self.isexist) {
        [self loadDataWithUrl:Kurl(self.pageIndex, self.isexist)];
    }else{
        [self loadDataWithUrl:Kurl((long)self.pageIndex,@"")];
    }
}
-(void)loadDataWithUrl:(NSString *)url{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self endRefresh];
        
        if (self.pageIndex == 1) {
            [self.dataArray removeAllObjects];
        }
        
        NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary *dict in array) {
            ClothModel *model = [[ClothModel alloc]init];
            model.name = dict[@"Name"];
            model.image = dict[@"JpgName"];
            model.ClickUrl = dict[@"ClickUrl"];
            model.price = dict[@"Price"];
            model.cloth = dict[@"PngName"];
            model.clothingID = dict[@"ClothingID"];
            [self.dataArray addObject:model];
        }
        [_collectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefresh];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请求数据失败" message:@"可能由于网络问题..." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
    }];
}
-(NSInteger)pageIndex{
    if (_pageIndex == 0) {
        _pageIndex = 1;
    }
    return _pageIndex;
}
#pragma mark - <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ClothCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.identifierArray[indexPath.row] forIndexPath:indexPath];
    /**
    if (cell.buttoncollection.selected) {
        [cell.buttoncollection setTitle:@"已收藏" forState:UIControlStateNormal];
        [cell.buttoncollection setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cell.buttoncollection setBackgroundImage:[UIImage imageNamed:@"bg_btn_button_2.png"] forState:UIControlStateNormal];
    }else{
        [cell.buttoncollection setTitle:@"收藏" forState:UIControlStateNormal];
        [cell.buttoncollection setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell.buttoncollection setBackgroundImage:[UIImage imageNamed:@"bg_btn_button_1.png"] forState:UIControlStateNormal];
    }
     */
    ClothModel *model = [_dataArray objectAtIndex:indexPath.row];
    cell.model = model;
    cell.delegate =self;
    return cell;
   
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ClothModel *model = self.dataArray[indexPath.row];
    AboutClothViewController *controller = [[AboutClothViewController alloc]init];
    [controller loadDataWithUrl:[NSString stringWithFormat:@"http://clothing.yyasp.net/Json.aspx?ClothingID=%@",model.clothingID]];
    [self presentViewController:controller animated:YES completion:nil];
}


-(void)toTryingView:(UIButton *)button clothName:(NSString *)name{
    TryingViewController *controller = [[TryingViewController alloc]init];
    controller.clothingName = name;
    [self presentViewController:controller animated:YES completion:nil];
}
@end
