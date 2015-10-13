//
//  shoucangViewController.m
//  Demo
//
//  Created by qianfeng007 on 15-10-3.
//  Copyright (c) 2015年 李娟. All rights reserved.
//

#import "shoucangViewController.h"
#import "ClothModel.h"
#import "DBManager.h"
#import "UIImageView+WebCache.h"
#import "AboutClothViewController.h"
#import "test.h"

@interface shoucangViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSMutableArray *clothesArr;
@property (nonatomic) ClothModel *selectedModel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet UIButton *delectedButton;
@property (weak, nonatomic) IBOutlet UILabel *selecedLabel;
@property (weak, nonatomic) IBOutlet UILabel *deleteLabel;
@property (nonatomic) NSMutableArray *deleteArray; // 存放要删除的对象
@property (nonatomic) NSMutableArray *quanXuanArray;
@end

@implementation shoucangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationBar *bar = self.navigationController.navigationBar;
    bar.translucent = YES; // 不透明
    [self test];
}

- (void)test {
    [self addleftItem];
    [self setUp];
    [self addEditButton];
    [self setBottom];
}
- (void)setBottom {
    [self.bottomView addSubview:self.selecedLabel];
    [self.bottomView addSubview:self.deleteLabel];
    [self.bottomView addSubview:self.selectedButton];
    [self.bottomView addSubview:self.delectedButton];
    self.bottomView.hidden = YES;
    [self.delectedButton setImage:[UIImage imageNamed:@"btn_delete_2.png"] forState:UIControlStateHighlighted];
}

- (void)setUp {
   [self creatTableView];
    
    UILabel *label = [UILabel new];
    label.text = @"我的收藏";
    label.textColor = [UIColor orangeColor];
    label.font = [UIFont boldSystemFontOfSize:22];
    label.frame = CGRectMake(0, 0, 30, 30);
    self.navigationItem.titleView = label;
}

-(void)creatTableView{
    NSMutableArray *array = [[DBManager sharedInstance]fetch];
    self.clothesArr = array;
    self.tableView.delegate =self;
    self.tableView.dataSource =self;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView reloadData];
}

-(NSMutableArray *)clothesArr{
    if (_clothesArr == nil) {
        _clothesArr = [[NSMutableArray alloc]init];
    }
    return _clothesArr;
}

-(void)addleftItem{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 30, 30);
    [button setBackgroundImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"return2"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(clickLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:button];
}

- (void)addEditButton {
    //************************************************
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"选择" forState:UIControlStateNormal];
    [button setTitle:@"完成" forState:UIControlStateSelected];
    
    [button setTintColor:[UIColor clearColor]];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    
    button.frame = CGRectMake(0, 0, 35, 35);
      //放在导航栏左测
    UIBarButtonItem *item= [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item
    ;
}

- (void)edit:(UIButton *)button {
    self.bottomView.hidden = YES;
    button.selected = !button.selected;
    if (button.selected) {
        [self.tableView setEditing:YES animated:YES];
    } else {
        [self.tableView setEditing:NO animated:YES];
    }
    //隐藏下面视图
    if (button.selected) {
        self.bottomView.hidden = NO;
    }
}

-(void)clickLeftButton:(UIButton *)button{
    button.selected=!button.selected;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSMutableArray *)deleteArray {
    if (_deleteArray == nil) {
         _deleteArray = [[NSMutableArray alloc] init];
    }
    return _deleteArray;
}

- (NSMutableArray *)quanXuanArray {
    if(_quanXuanArray == nil) {
        _quanXuanArray = [[NSMutableArray alloc] init];
    }
    return _quanXuanArray;
}

#pragma mark - <uitableviewdelegate>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.clothesArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    ClothModel *model = self.clothesArr[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
    cell.detailTextLabel.text = model.name;
    NSString *string = [NSString stringWithFormat:imageUrl,model.image];
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:string];
    [cell.imageView  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"loading.png"]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.editing == NO) {
        ClothModel *model = self.clothesArr[indexPath.row];
        AboutClothViewController *controller = [[AboutClothViewController alloc]init];
        [controller loadDataWithUrl:[NSString stringWithFormat:@"http://clothing.yyasp.net/Json.aspx?ClothingID=%@",model.clothingID]];
        [self presentViewController:controller animated:YES completion:nil];
    }
   
    ClothModel *model = self.clothesArr[indexPath.row];
    
    [self.deleteArray addObject:model];
}
// 取消选中某行时，把这行所对应的数据从原来的_deleteArray中删除掉
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    ClothModel *model = self.clothesArr[indexPath.row];
    [self.deleteArray removeObject:model];
}
// 设置编辑风格
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert; // 多选模式
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.view.frame.size.width >= 375) {
        return 80;
    } else {
        return 60;
    }
}
//
- (IBAction)delecte:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if (self.deleteArray.count == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"你是不是傻？没有选衣服就删除！" message:nil delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否将它从收藏中删除" message:nil
        delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"OK", nil];
        [alertView show];
    }
  
}
//警告框代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self deleteDataSourse];
    }else{
        return;
    }
}

- (void)deleteDataSourse {
    if (self.clothesArr.count == self.deleteArray.count) {
        [self.clothesArr removeAllObjects];
        [self.tableView reloadData];
    }
    for (int i = 0; i < self.deleteArray.count; i++) {
        [[DBManager sharedInstance]deleteModel:self.deleteArray[i]];
        [self.clothesArr removeObject:self.deleteArray[i]];
    }
    [UIView animateWithDuration:0.25 animations:^{
        [self.tableView reloadData];
    }];
    [self.deleteArray removeAllObjects];
}
//全选事件
- (IBAction)selected:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    NSMutableArray *array = [[DBManager sharedInstance]fetch];
    if (button.selected) {
       [self.deleteArray addObjectsFromArray:array];
         NSLog(@"%@",self.deleteArray);
    } else {
        [self.deleteArray removeAllObjects];
        NSLog(@"%@",self.deleteArray);
    }
}

@end
