//
//  ShareTwoViewController.m
//  VirtualFittingRoom
//
//  Created by qianfeng on 15-10-10.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import "ShareViewController1.h"
#import "ShareCell1.h"

@interface ShareViewController1 () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>


@property (nonatomic) UIView *bottomView;
@property (nonatomic) UIButton *selectedButton;
@property (nonatomic) UIButton *clothButton;
@property (nonatomic) UIButton *deleteButton;
@property (nonatomic) UILabel *selectedLabel;
@property (nonatomic) UILabel *clothLabel;
@property (nonatomic) UILabel *deletedLabel;

/**
 @property (weak, nonatomic) IBOutlet UIView *bottomView;
 @property (weak, nonatomic) IBOutlet UIButton *selectedButton;
 @property (weak, nonatomic) IBOutlet UIButton *clothButton;
 @property (weak, nonatomic) IBOutlet UIButton *deleteButton;
 @property (weak, nonatomic) IBOutlet UILabel *selectedLabel;
 @property (weak, nonatomic) IBOutlet UILabel *clothLabel;
 @property (weak, nonatomic) IBOutlet UILabel *deletedLabel;
 */

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) NSArray *dataArray;
@property (nonatomic) NSMutableArray *mutableArray;

@end

@implementation ShareViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUp];
    [self settingBottom];
    [self creatLabel];
    [self creatCollectionView];
}

- (void)creatLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49 - 120, self.view.frame.size.width, 120)];
    //    label.backgroundColor = [UIColor lightGrayColor];
    label.font = [UIFont boldSystemFontOfSize:13];
    label.numberOfLines = 0;
    label.text = @"小提示:\n  1.点击一张图片可以查看大图,然后再左右滑动试试\n  2.点击右上角的”选择”按钮开始选择图片,选择图片时注意底部操作栏的变化。操作完成后在点击右上角的”完成”按钮回到初始状态\n  3.当选择两张图片分享时，系统自动将两张图片合成在一起，峰适合比较查看，不妨发到朋友圈让大家点评一下吧!";
    [self.view addSubview:label];
}


- (void)settingBottom {
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49)];
    [self addBottomView];
    
}

- (void)addBottomView {
    
    
    CGRect frame = self.view.frame;
    CGFloat X = 30;
    CGFloat padding = (frame.size.width - 3 * X - 50 ) / 2.0;
    NSArray *array = @[@"btn_checkbutton_", @"room_clothing_", @"btn_delete_"];
    NSArray *titles = @[@"全选", @"选衣", @"删除"];
    
    for (int i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((padding + X) * i + 25, 2 , X, 32);
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@1.png", array[i]]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@2.png", array[i]]] forState:UIControlStateSelected];
        button.tag = 101 + i;
        UILabel *label = [[UILabel alloc] init];
        CGRect labelFrame = CGRectMake(button.frame.origin.x,CGRectGetMaxY(button.frame) +1, button.frame.size.width, 45 - button.frame.size.height);
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
    }
    self.bottomView.hidden = YES;
    
    [self.view addSubview:self.bottomView];
}

- (void)buttonClicks:(UIButton *)button {
    
}

- (void)setUp {
    UILabel *label = [UILabel new];
    label.text = @"我的分享";
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
    UIBarButtonItem *item2= [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = item2
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
- (void)selectedButton:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)clothButton:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)delectedButton:(UIButton *)sender {
    sender.selected = !sender.selected;
}
#pragma mark - <>
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
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 49 - 64 - 118) collectionViewLayout:layout]; // collectionView关联layout, 因为它要用layout对象布局自己
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    _collectionView.allowsSelection  = YES;//允许选择
    _collectionView.allowsMultipleSelection = YES;//选择多个
    //注册
    [_collectionView registerClass:[ShareCell1 class] forCellWithReuseIdentifier:kCellID];
    //注册section头视图/尾视图 supplementary view
    
    //
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"share"];
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

//有多少个分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

////duo少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mutableArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ShareCell1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    //    //配置sell
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"share"];
    NSLog(@"%@",path);
    
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@",path,_mutableArray[indexPath.row]]];
    
    [cell.contentView addSubview:cell.imageView];
    return cell;;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"share"];
    
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
