//
//  NearViewController.m
//  VirtualFittingRoom
//
//  Created by qianfeng on 15/10/7.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import "NearViewController.h"
#import "PhotoViewController.h"
#import "Define.h"
#import "UIImageView+WebCache.h"



@interface NearViewController ()
{
    UIView *_cellview;
}
@end

@implementation NearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
-(void)fetchWebDataWithUrl:(NSString *)url{
    
    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        self.detail=[[DetailModel alloc]initWithDictionary:dict[@"Share"] error:nil];
        self.cloth=[[ClothModel1 alloc]initWithDictionary:dict[@"Clothing"] error:nil];
        
       
        self.num=[self.detail.ReplayNumber integerValue];
       
        [self refreshFavoriteButton];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)refreshFavoriteButton{
    
    
    BOOL flag= [[DataManager sharedManger]isExistClothForclothID:self.cloth.ClothingID];
    self.collectbutton.selected=flag;
}

-(void)loadData:(NSString *)url{
    NSString *str=[NSString stringWithFormat:kPL,self.shareId];
    [self.manager GET:str  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        self.Models=[[JSONModelArray alloc]initWithArray:arr modelClass:[Comment class]];
        
        UILabel *label=(UILabel *)[self.Headview viewWithTag:110];
        if (self.Models.count==0) {
            label.text=@"最新评论";
        }else{
            label.text=[NSString stringWithFormat:@"用户评论(共%ld个)",self.num];
        }
        
        
        
        _cellview=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.Headview.frame), self.view.frame.size.width, 50)];
        [self.scrollview addSubview:_cellview];
        
        if (self.Models.count==0) {
            label=[[UILabel alloc]initWithFrame:CGRectMake(100, 10, self.view.frame.size.width-200, 30)];
            [_cellview addSubview:label];
            label.text=@"求评论！！！";
            label.textAlignment=NSTextAlignmentCenter;
            label.textColor=[UIColor redColor];
        }else if(self.Models.count==1){
            label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 130, 25)];
            UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(10, 25, 300, 25)];
            
            [_cellview addSubview:label];
            [_cellview addSubview:label1];
            Comment *comment=self.Models[0];
            label.text=[NSString stringWithFormat:@"用户:%@",comment.UserName];
            label.lineBreakMode=NSLineBreakByTruncatingMiddle;
            label.textColor=[UIColor blueColor];
            
            label1.text=comment.Content;
        }
        else {
            CGRect frame=_cellview.frame;
            frame.size.height=101;
            _cellview.frame=frame;
            
            
            UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 1)];
            imageview.image=[UIImage imageNamed:@"bg_line_1.png"];
            
            [_cellview addSubview:imageview];
            
            label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 130, 25)];
            UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(10, 25, 300, 25)];
            
            [_cellview addSubview:label];
            [_cellview addSubview:label1];
            Comment *comment=self.Models[0];
            label.text=[NSString stringWithFormat:@"用户: %@",comment.UserName];
            label.lineBreakMode=NSLineBreakByTruncatingMiddle;
            label.textColor=[UIColor blueColor];
            label1.text=comment.Content;
            
            
            label=[[UILabel alloc]initWithFrame:CGRectMake(0, 51, 130, 25)];
            label1=[[UILabel alloc]initWithFrame:CGRectMake(10, 76, 300, 25)];
            comment=self.Models[1];
            label.text=[NSString stringWithFormat:@"用户: %@",comment.UserName];
            label.lineBreakMode=NSLineBreakByTruncatingMiddle;
            label.textColor=[UIColor blueColor];
            
            label1.text=comment.Content;
            [_cellview addSubview:label];
            [_cellview addSubview:label1];
        }
        
        
        self.scrollview.contentSize=CGSizeMake(0, CGRectGetMaxY(_cellview.frame));
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];

}


@end
