//
//  ShiyiViewController.m
//  Demo
//
//  Created by qianfeng007 on 15-10-3.
//  Copyright (c) 2015年 李娟. All rights reserved.
///Users/qianfeng007/Library/Developer/CoreSimulator/Devices/3BB3450A-1746-49C3-BDA5-A2DAAD38D10E/data/Containers/Data/Application/41F14D04-E8CE-4263-A1B2-50431117B730/camera

#import "ShiyiViewController.h"
#import "ShiYiCell.h"
#import "ShiYiCellViewCollectionViewCell.h"

@interface ShiyiViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic) UICollectionView *collectionViewController;

@property (nonatomic)  UIView *bottomView;
@property (nonatomic) UILabel *clothLabel;

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UIImageView *imageView;
//点击的时候
@property (nonatomic) NSArray *dataArray;
@property (nonatomic) NSMutableArray *mutableArray;
@end

@implementation ShiyiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationBar *bar = self.navigationController.navigationBar;
    bar.translucent = YES; // 不透明
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUp];
    [self creatCollectionView];
    [self creatLabel];
    [self addBottomView];
}

- (void)creatLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49 - 120, self.view.frame.size.width, 120)];
//    label.backgroundColor = [UIColor lightGrayColor];
    label.font = [UIFont boldSystemFontOfSize:13];
    label.numberOfLines = 0;
    label.text = @"小提示:\n  1.点击一张图片可以查看大图,然后再左右滑动试试\n  2.点击右上角的”选择”按钮开始选择图片,选择图片时注意底部操作栏的变化。操作完成后在点击右上角的”完成”按钮回到初始状态\n  3.当选择两张图片分享时，系统自动将两张图片合成在一起，峰适合比较查看，不妨发到朋友圈让大家点评一下吧!";
   [self.view addSubview:label];
}

- (void)addBottomView {

    CGRect frame = self.view.frame;
    CGFloat X = 30;
    CGFloat padding = (frame.size.width - 5 * X - 50 ) / 4.0;
    NSArray *array = @[@"btn_checkbutton_", @"room_clothing_",@"room_share_", @"room_save_", @"btn_delete_"];
    NSArray *titles = @[@"全选", @"选衣", @"分享", @"保存", @"删除"];
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49)];

    for (int i = 0; i < 5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((padding + X) * i + 25, 2 , X, 32- 5);
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@1.png", array[i]]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@2.png", array[i]]] forState:UIControlStateSelected];
        button.tag = 101 + i;
        UILabel *label = [[UILabel alloc] init];
        CGRect labelFrame = CGRectMake(button.frame.origin.x,CGRectGetMaxY(button.frame) +1, button.frame.size.width, 45 - button.frame.size.height );
        label.frame = labelFrame;
        label.tag = 201 + i;
        label.text = titles[i];
        label.adjustsFontSizeToFitWidth = YES;
        label.font = [UIFont systemFontOfSize:11];
        label.textAlignment = NSTextAlignmentCenter;
        
        [button addTarget:self action:@selector(buttonClicks:) forControlEvents:UIControlEventTouchUpInside];
        self.bottomView.backgroundColor = [UIColor cyanColor];
        
        [self.bottomView addSubview:button];
        [self.bottomView addSubview:label];
        self.bottomView.hidden = YES;
    }
    UIButton *button = (UIButton *)[self.bottomView viewWithTag:102];
//    button.hidden = NO;
    UILabel *label = (UILabel *)[self.bottomView viewWithTag:202];
    label.frame  = CGRectZero;
    button.frame = CGRectZero;
    
    [self.view addSubview:self.bottomView];

    
}
- (void)buttonClicks:(UIButton *)button {
    
    button.selected = !button.selected;
    switch (button.tag - 100) {
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        default:
            break;
    }
}

- ( NSArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [[ NSArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)mutableArray {
    if (_mutableArray == nil) {
        _mutableArray = [NSMutableArray array];
    }
    return _mutableArray;
}

- (void)setUp {
    UILabel *label = [UILabel new];
    label.text = @"试衣记录";
    label.textColor = [UIColor orangeColor];
    label.font = [UIFont boldSystemFontOfSize:22];
    label.frame = CGRectMake(0, 0, 30, 30);
    self.navigationItem.titleView = label;
    [self addleftItem];
    //************************************************
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"选择" forState:UIControlStateNormal];
    [button setTitle:@"完成" forState:UIControlStateSelected];
    
    [button setTintColor:[UIColor clearColor]];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    button.frame = CGRectMake(0, 0, 35, 35);
    UIBarButtonItem *item= [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = item
    ;
    
}
-(void)addleftItem{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 30, 30);
    [button setBackgroundImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"return2"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(clickLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
}

-(void)clickLeftButton:(UIButton *)button{
    button.selected=!button.selected;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)buttonClick:(UIButton *)button {
    self.bottomView.hidden = YES;
    button.selected = !button.selected;

    if (button.selected) {
       self.bottomView.hidden = NO;
    }
}

#pragma mark - bottomView
- (IBAction)selectedButton:(UIButton *)sender {
    sender.selected = !sender.selected;
}
- (IBAction)shareButton:(UIButton *)sender {
    sender.selected = !sender.selected;
}
- (IBAction)phototButton:(UIButton *)sender {
    sender.selected = !sender.selected;
}
- (IBAction)delecteButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
}
- (IBAction)clothButton:(UIButton *)sender {
    sender.selected = !sender.selected;
}

//***********************************************
//加载数据

//创建/增添collectionView
- (void)creatCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
      layout.itemSize = CGSizeMake(90, 140);
    // 行间距（竖直滚动）   列间距（水平滚动）
    layout.minimumLineSpacing = 3.0;
    
    // cell(item)之间的最小间距
    layout.minimumInteritemSpacing = 1.0;
    
    layout.headerReferenceSize = CGSizeMake(0, 0);
    layout.footerReferenceSize = CGSizeMake(0, 0);
    
    // section内边距
    layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height  -51 - 115) collectionViewLayout:layout]; // collectionView关联layout, 因为它要用layout对象布局自己
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    _collectionView.allowsSelection  = YES;//允许选择
    _collectionView.allowsMultipleSelection = YES;//选择多个
    //注册
    [_collectionView registerClass:[ShiYiCell  class] forCellWithReuseIdentifier:kShiYiCell];
    //注册section头视图/尾视图 supplementary view
    
    //
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"camera"];
    NSError *error = nil;
    _dataArray = (NSArray *)[fileManager contentsOfDirectoryAtPath:path error:&error];
    for (int i = 1; i < _dataArray.count; i++) {
        [self.mutableArray addObject:_dataArray[i]];
    }
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
   
}

#pragma mark - 88888

//有多少个分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

////duo少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mutableArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ShiYiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kShiYiCell forIndexPath:indexPath];
//    //配置sell
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"camera"];
    
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@",path,_mutableArray[indexPath.row]]];
    
    [cell.contentView addSubview:cell.imageView];
    return cell;;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"camera"];
    
    _imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@",path,_mutableArray[indexPath.row]]];
    _imageView.userInteractionEnabled = YES;
    self.navigationController.navigationBarHidden = YES;
    [self.view addSubview:_imageView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.imageView removeFromSuperview];
    self.navigationController.navigationBarHidden = NO;
}
- (void)deleteItemsAtIndexPaths:(NSArray *)indexPaths {
    NSLog(@"ww");
}

@end
