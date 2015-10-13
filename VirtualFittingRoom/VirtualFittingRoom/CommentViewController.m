//
//  CommentViewController.m
//  VirtualFittingRoom
//
//  Created by qianfeng on 15/10/7.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import "CommentViewController.h"
#import "AFNetworking.h"
#import "Comment.h"
#import "Define.h"


@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic)UITableView *tableview;
@property(nonatomic)NSInteger page;
@property(nonatomic)NSMutableArray *array;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableview=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    [self.view addSubview:_tableview];
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableview.frame.size.width, 40)];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"更多" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    button.frame=CGRectMake(0, 0, 30, 30);
    button.center=view.center;
    
    [view addSubview:button];
    self.tableview.tableFooterView=view;
    
}

-(NSInteger)page{
    if (_page==0) {
        _page=1;
    }
    return _page;
}
-(NSMutableArray *)array{
    if (_array==nil) {
        _array=[NSMutableArray array];
    }
    return _array;
}
-(void)more:(UIButton *)button{
    
    if (self.page*20<self.num) {
        
        self.page++;
        
//        NSString *str=[NSString stringWithFormat:kMore,self.Id,self.page];
        [self loadData:nil];
        
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"加载完成" message:@"没有更多评论了" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}
-(void)loadData:(NSString *)url{
   // NSString *str=self.url;
    NSString *str=[NSString stringWithFormat:kMore,self.Id,self.page];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        self.Models=[[JSONModelArray alloc]initWithArray:arr modelClass:[Comment class]];
        for (Comment *model in self.Models) {
            [self.array addObject:model];
        }
        
        [self.tableview reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellid"];
    }
    Comment *comment=self.array[indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"用户:  %@",comment.UserName];
    cell.textLabel.lineBreakMode=NSLineBreakByTruncatingMiddle;
    cell.textLabel.font=[UIFont systemFontOfSize:12];
    cell.textLabel.textColor=[UIColor blueColor];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ [%@]",comment.Content,comment.PubTime];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:12];
    
    return cell;
}



@end
