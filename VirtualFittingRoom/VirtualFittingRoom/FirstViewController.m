//
//  FirstViewViewController.m
//  Demo
//
//  Created by qianfeng007 on 15-10-4.
//  Copyright (c) 2015年 李娟. All rights reserved.
//

#import "FirstViewController.h"
#import "AFNetworking.h"
#import "FirstModel.h"
#import "FirstCell.h"
#import "MyFootView.h"
#import "JHRefresh.h"
#import "test.h"
#import "DetailViewController.h"
#import "WWScrollView.h"
#import "TryingViewController.h"
#import "Define.h"
#import "VideoDownLoad.h"

@interface FirstViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) JSONModelArray *modelArray;

@property (nonatomic) WWScrollView *scrollView;
@property (nonatomic) BOOL isLoading;
@property (nonatomic) UILabel *label;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    
    [self creat];
}

- (void)creat {
    [self addHelp];
    [self loadDataSource];
    [self creatCollectionView];
    [self creatScroll];
    [self addMidView];
    [self addTap];
}

- (void)addMidView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 170, self.view.frame.size.width, 100-64)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(13 , (view.frame.size.height - 10) / 2.0, 10, 10);
    button.layer.cornerRadius = 5;
    button.userInteractionEnabled = NO;
    [view addSubview:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10 + CGRectGetMaxX(button.frame), 5, self.view.frame.size.width - CGRectGetMaxX(button.frame) - 40, view.frame.size.height - 10)];
    label.text = @"规范的试衣展示";
    label.font = [UIFont systemFontOfSize:15];
    [view addSubview:label];

    UIButton * refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshButton.frame = CGRectMake(CGRectGetMaxX(label.frame), 6, 20, 20);
    
    [refreshButton setImage:[[UIImage imageNamed:@"btn_refersh_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [refreshButton setImage:[UIImage imageNamed:@"btn_refersh_2"] forState:UIControlStateHighlighted];
    [refreshButton addTarget:self action:@selector(refershButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:refreshButton];
    
    [self.view addSubview:view];
}

- (void)addHelp {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"btn_video_1"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"btn_video_2"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    //************************************************************
    button.frame = CGRectMake(0, 0, 35, 35);
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

- (void)clickButton:(UIButton *)button {
    VideoDownLoad *helpController = [[VideoDownLoad alloc] init];
    helpController.modalPresentationStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:helpController animated:YES completion:nil];
}

- (void)creatScroll {
    self.scrollView = [[WWScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 170)];
    NSMutableArray *imagearr = [NSMutableArray array];
    for (NSInteger i = 1; i <= 3; i++) {
        [imagearr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%ld.png",i]]];
    }
    
    self.scrollView.imageArray = imagearr;
    [self.view addSubview:self.scrollView];
}

- (void)addTap {
    //9.png   707.png
    //加手势点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap:)];
    [self.scrollView addGestureRecognizer:tap];
}

- (void)clickTap:(UITapGestureRecognizer *)tap {
    TryingViewController *controller = [TryingViewController new];
    controller.clothingName = @"9.png";
    [self presentViewController:controller animated:YES completion:nil];
}

//创建/增添collectionView
- (void)creatCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat padding = 3.0f;
    if (self.view.frame.size.width > 360) {
         layout.itemSize = CGSizeMake(self.view.frame.size.width / 4 - 5*padding, 150); // 定义item(cell)的宽高
    } else {
         layout.itemSize = CGSizeMake(self.view.frame.size.width / 3 - 4*padding, 150); // 定义item(cell)的宽高
    }
    
    // 行间距（竖直滚动）   列间距（水平滚动）
    layout.minimumLineSpacing = 10;
 
    // cell(item)之间的最小间距
    layout.minimumInteritemSpacing = 3.0;
  
    layout.headerReferenceSize = CGSizeMake(0, 0);
    layout.footerReferenceSize = CGSizeMake(0, 80);
    
    // section内边距
    layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 270 - 64, self.view.frame.size.width, self.view.frame.size.height - 270 - 30) collectionViewLayout:layout]; // collectionView关联layout, 因为它要用layout对象布局自己
    //[_collectionView add];
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    //注册
    [_collectionView registerClass:[FirstCell class] forCellWithReuseIdentifier:kFirstCell];
    //注册section头视图/尾视图 supplementary view
    [_collectionView registerClass:[MyFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kMyFootView];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    [self refersh];
}

- (void)refersh {
    //上啦加载
    __weak typeof(self) mySelf = self;
    [self.collectionView addRefreshFooterViewWithAniViewClass:[JHRefreshAmazingAniView class] beginRefresh:^{
        if (mySelf.isLoading) {
            return ;
        }
        mySelf.isLoading = YES;
        //上拉加载更多
        [mySelf loadDataSource];
    }];
}
- (void)endRefresh {
    if (self.isLoading) {
        [self.collectionView footerEndRefreshing];
    }
    self.isLoading = NO;
}


- (void)loadDataSource {
    if (self.view.frame.size.width >= 375) {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:kFirstView12 parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self endRefresh];
        NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        self.modelArray = [[JSONModelArray alloc] initWithArray:array modelClass:[FirstModel class]];
        
        [self.collectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefresh];
        NSLog(@"%@",error);
    }];
    } else {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:kFirstView9 parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self endRefresh];
            NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            self.modelArray = [[JSONModelArray alloc] initWithArray:array modelClass:[FirstModel class]];
            
            [self.collectionView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self endRefresh];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请求数据失败" message:@"可能由于网络问题..." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
        }];
    }
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status ==AFNetworkReachabilityStatusNotReachable) {
            _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
            _label.text = @"当前无网络状态";
            _label.font = [UIFont boldSystemFontOfSize:13];
            _label.textColor = [UIColor redColor];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.label];
            
        } else {
            self.label.hidden = YES;
        }
    }];
}

#pragma mark - <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

//有多少个分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

////duo少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        return self.modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FirstCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFirstCell forIndexPath:indexPath];
    //配置sell
    FirstModel *model = [self.modelArray objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

//
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
        MyFootView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kMyFootView forIndexPath:indexPath];
        return view;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *controller = [DetailViewController new];
    controller.modalPresentationStyle = UIModalTransitionStylePartialCurl;
    FirstModel *model = [self.modelArray objectAtIndex:indexPath.row];

    [controller fetchWebDataWithUrl:[NSString stringWithFormat:kpicture,model.ShareID]];
    
    controller.urlPath = [NSString stringWithFormat:kPL,model.ShareID];
    controller.shareId = (NSNumber *)model.ShareID;
    UINavigationController *niv = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:niv animated:YES completion:nil];
}

- (void)refershButton:(UIButton *)sender {
    [self loadDataSource];
}

@end
