//
//  SearchViewController.m
//  VirtualFittingRoom
//
//  Created by qianfeng on 15/10/3.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import "SearchViewController.h"
#import "ChooesCell.h"
#import "AFNetworking.h"
#import "ClothesViewController.h"
#define TypeUrl @"http://clothing.yyasp.net/Json.aspx?clothingsort=yes"

@interface SearchViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic)UICollectionView *collectionView;
@property(nonatomic)NSMutableArray *dataArray;
@property(nonatomic)NSMutableArray *groupNameArray;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 30, 30);
    btn.tintColor = [UIColor clearColor];
    [btn setBackgroundImage:[UIImage imageNamed:@"return.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"return2.png"] forState:UIControlStateSelected];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
    [self creatView];
    [self loadData];
}
-(void)back:(UIButton *)button{
    button.selected = !button.selected;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(void)creatView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(150, 80);
    layout.minimumLineSpacing = 10;
    CGFloat width;
    
    if (375 == self.view.frame.size.width) {
        width = (self.view.frame.size.width - 2 * 150) / 3.0;
    } else {
        width = (self.view.frame.size.width - 2 * 150) / 3.0;
    }
    layout.minimumInteritemSpacing = width;
    layout.sectionInset = UIEdgeInsetsMake(10, width, 10, width);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-80) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    self.groupNameArray = [NSMutableArray array];
    [_collectionView registerNib:[UINib nibWithNibName:@"ChooesCell" bundle:nil] forCellWithReuseIdentifier:@"ChooesCellID"];
    [self.view addSubview:_collectionView];
}
-(void)loadData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:TypeUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary *dict in array) {
            ChooesModel *model = [[ChooesModel alloc]init];
            model.ClothingSortID = dict[@"ClothingSortID"];
            model.Name = dict[@"Name"];
            model.ParentID = dict[@"ParentID"];
            [self.dataArray addObject:model];
        }
        [_collectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
}
#pragma mark - collectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ChooesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChooesCellID" forIndexPath:indexPath];
    ChooesModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ChooesModel *model = self.dataArray[indexPath.row];
    ChooesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChooesCellID" forIndexPath:indexPath];
    [cell.chooesBtn setBackgroundImage:[UIImage imageNamed:@"btn_checkbutton_2"] forState:UIControlStateNormal];
    if (self.clothSortIDBlock) {
        self.clothSortIDBlock(model.ClothingSortID,model.Name);
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

@end
