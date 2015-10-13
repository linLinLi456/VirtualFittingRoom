//
//  StoreViewController.m
//  Demo
//
//  Created by qianfeng007 on 15-10-4.
//  Copyright (c) 2015年 李娟. All rights reserved.
//

#import "StoreViewController.h"

@interface StoreViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *dataArray;
@end

@implementation StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.tabBarController.tabBar.hidden = YES;
    [self setUp];
    [self addTableView];
}

- (void)setUp {
    UILabel *label = [UILabel new];
    label.text = @"商店介绍";
    label.textColor = [UIColor orangeColor];
    label.font = [UIFont boldSystemFontOfSize:22];
    label.frame = CGRectMake(0, 0, 30, 30);
    self.navigationItem.titleView = label;
    
    [self addleftItem];
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

- (void)addTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 160, self.view.frame.size.width, 500)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:_tableView];
    self.dataArray = @[@"艾莱依天猫店",@"唐力天猫店",@"OECE天猫专卖",@"MIKIBNA天猫",@"潮流前线天猫店",@"笛莎淘宝童装",@"波司登羽绒服",@"淘宝潮流一店",@"华丰店",@"潮流在线",@"无限魅力"];
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

@end
