//
//  DetailViewController.m
//  VirtualFittingRoom
//
//  Created by qianfeng on 15/10/4.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import "DetailViewController.h"

#import "UIImageView+WebCache.h"
#import "PhotoViewController.h"
#import "EditingViewController.h"
#import "UIImage+util.h"
#import "SharedCell.h"
#import "TryingViewController.h"

#import "CommentViewController.h"
#import "NearViewController.h"
#import "NearByViewController.h"
#import "WebViewController.h"




@interface DetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UIView *_cellview;
     NSString *_clickurl;
}
@property(nonatomic)NSMutableArray *array;
@property(nonatomic,copy)NSString *url;
@property(nonatomic)NSInteger tag;

@property(nonatomic)int m;


@end

@implementation DetailViewController
- (IBAction)tapOnOriginal:(id)sender {
    PhotoViewController *controller=[[PhotoViewController alloc]init];
    
    [self presentViewController:controller animated:YES completion:nil];
    [controller.imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:kImage,_detail.OldPath]]];
}
- (IBAction)tapOn:(id)sender {
    PhotoViewController *controller=[[PhotoViewController alloc]init];
    
    [self presentViewController:controller animated:YES completion:nil];
    [controller.imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:kImage,_detail.NewPath]]];

}
- (IBAction)clickYes:(UIButton *)sender {//
//    static int m=0;
    if(!self.CaiButton.selected){
    NSInteger n=[_detail.Flowers integerValue];
    n++;
    self.Yeslabel.text=[NSString stringWithFormat:@"赞: %ld",n];
        
        sender.selected=YES;
        _m++;
       

        if (_m>1) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"您已评价过了@_@" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];

        }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"评价成功^_^" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        }
    }else {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"您已评价过了^-^" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    }

}
- (IBAction)clickNo:(UIButton *)sender {
    
    if (!self.ZanButton.selected) {
        NSInteger n=[_detail.Eggs integerValue];
        n++;
        self.Nolabel.text=[NSString stringWithFormat:@"踩: %ld",n];
        sender.selected=YES;
        _m++;
        
        if (_m>1) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"您已评价过了@_@" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"评价成功^-^" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
        }

    }else{
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"您已评价过了^_^" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    }

    
    
}
- (IBAction)collect:(UIButton *)sender {
    sender.selected=!sender.selected;
    if (sender.selected) {
        [[DataManager sharedManger]insertModel:self.cloth ];
    }else{
        [[DataManager sharedManger]deleteModel:self.cloth.ClothingID];
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"取消收藏成功%_%" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        [sheet showInView:self.scrollview];
        
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(cancel:) userInfo:sheet repeats:NO];
    }
    
    
}
-(void)cancel:(NSTimer *)timer{
    UIActionSheet *sheet=timer.userInfo;
    [sheet dismissWithClickedButtonIndex:0 animated:YES];
    [timer invalidate];
}

-(void)refreshFavoriteButton{
    
    
    BOOL flag= [[DataManager sharedManger]isExistClothForclothID:self.cloth.ClothingID];
    self.collectbutton.selected=flag;
}

- (IBAction)buy:(UIButton *)sender {
    WebViewController *web = [[WebViewController alloc]init];
    
    web.url = _clickurl;
    
    [self.navigationController pushViewController:web animated:YES];
}


- (IBAction)share:(UIButton *)sender {
    TryingViewController *controller=[[TryingViewController alloc]init];
    controller.clothingName=self.cloth.PngName;
    
    [self presentViewController:controller animated:YES completion:nil];
}
-(NSMutableArray *)array{
    if (_array==nil) {
        _array=[[NSMutableArray alloc]init];
    }
    return _array;
}

-(void)setDetail:(DetailModel *)detail{
    _detail=detail;
    [self.originalimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:kImage,detail.OldPath]] placeholderImage:[UIImage imageNamed:@"loading"]];
    [self.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:kImage,detail.NewPath]] placeholderImage:[UIImage imageNamed:@"loading"]];
    self.Seelabel.text=[NSString stringWithFormat:@"查看次数: %@",detail.Hits];
    self.remarkLabel.text=[NSString stringWithFormat:@"分享说明: %@",detail.Remark];
    self.Yeslabel.text=[NSString stringWithFormat:@"赞: %@",detail.Flowers];
    self.Nolabel.text=[NSString stringWithFormat:@"踩: %@",detail.Eggs];
    
}
-(void)setCloth:(ClothModel1 *)cloth{
    _cloth=cloth;
    self.clothInfo.text=[NSString stringWithFormat:@"衣服信息: %@ (￥%@)",cloth.Title,cloth.Price];
    self.OtherInfo.text=[NSString stringWithFormat:@"试穿: %@次  分享: %@次",cloth.ClothingNumber,cloth.ShareNumber];
}
///

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData:self.urlPath];
    
    [self setHeadview];
    
    [self addleftItem];
    
    self.m=0;
  
    
    
   self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:[self addrightItem]];
    
    self.title=@"分享";
    self.navigationController.navigationBar.titleTextAttributes=@{NSFontAttributeName:[UIFont fontWithName:@"Arial Rounded MT Bold" size:20],NSForegroundColorAttributeName:[UIColor orangeColor]};
    
    
    
    
    
}
-(void)setTag:(NSInteger)tag{
    _tag=tag;
}
-(AFHTTPRequestOperationManager *)manager{
    if (_manager==nil) {
        self.manager=[AFHTTPRequestOperationManager manager];
        self.manager.responseSerializer=[AFHTTPResponseSerializer serializer];

    }
    return _manager;
}
-(void)fetchWebDataWithUrl:(NSString *)url{
    self.tag=110;
        [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        self.detail=[[DetailModel alloc]initWithDictionary:dict[@"Share"] error:nil];
        self.cloth=[[ClothModel1 alloc]initWithDictionary:dict[@"Clothing"] error:nil];
            
            self.url=[NSString stringWithFormat:@"%@",self.cloth.ClothingID];
            self.num=[self.detail.ReplayNumber integerValue];
            
            _clickurl = self.cloth.ClickUrl;
            
            [self refreshFavoriteButton];
            [self FecthData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)addleftItem{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 30, 30);
    [button setBackgroundImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"return2"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
}
-(void)click:(UIButton *)button{
    button.selected=!button.selected;
    if (_tag==110) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
   
    [self.navigationController popViewControllerAnimated:YES];
    }
}

-(UIButton *)addrightItem{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 30, 30);
    [button setBackgroundImage:[UIImage imageNamed:@"btn_write_1"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_write_2"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
-(void)clicked:(UIButton *)buton{
    EditingViewController *controller=[[EditingViewController alloc]init];
    [self presentViewController:controller animated:YES completion:nil];
}

-(void)loadData:(NSString *)url {
//    NSLog(@"%@",url);
    //self.manager = [AFHTTPRequestOperationManager manager];
//    url = @"http://clothing.yyasp.net/Json.aspx?ShareReplayShow=yes&ShareID=107008";
    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        self.Models=[[JSONModelArray alloc]initWithArray:arr modelClass:[Comment class]];
        
        UILabel *label=(UILabel *)[_Headview viewWithTag:110];
        if (self.Models.count==0) {
            label.text=@"最新评论";
        }else{
            label.text=[NSString stringWithFormat:@"用户评论(共%ld个)",_num];
        }
        
        
        
        _cellview=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_Headview.frame), self.view.frame.size.width, 50)];
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
        
        
        
        [self setfooterview];



    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

-(void)setHeadview{


    
    UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 40)];
    UIImage *image=[UIImage imageNamed:@"redpoint"];
    image=[image scaleToSize:image size:CGSizeMake(10, 40)];
    imageview.image=image;
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 120, 20)];
    label.tag=110;
    label.font=[UIFont systemFontOfSize:12];
    [_Headview addSubview:imageview];
    [_Headview addSubview:label];
    
    CGRect frame = CGRectMake(230, 7.5, 25, 25);
    CGRect bouns = [UIScreen mainScreen].bounds;
    if (bouns.size.width < 360) {
        frame = frame;
    }
    
    else{
        frame.origin.x = 280;
    }
    UIButton *button=[self addrightItem];
    button.frame=frame;
    [_Headview addSubview:button];
    
    frame.origin.x += 50;
    CGFloat x = frame.origin.x;
    button=[UIButton buttonWithType:UIButtonTypeSystem];
    button.frame=CGRectMake(x, 7.5, 40, 25);
    [button setTitle:@"更多" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(fetchdata) forControlEvents:UIControlEventTouchUpInside];
    [_Headview addSubview:button];

    
}
    

-(void)setfooterview{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_cellview.frame), self.view.frame.size.width, 40)];
    view.backgroundColor=[UIColor grayColor];
    
    UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 40)];
    UIImage *image=[UIImage imageNamed:@"redpoint"];
    image=[image scaleToSize:image size:CGSizeMake(10, 40)];
    imageview.image=image;
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 120, 20)];
    label.text=@"大伙都在试穿";
    label.font=[UIFont systemFontOfSize:12];
    [view addSubview:imageview];
    [view addSubview:label];
    
    
    CGRect frame=CGRectMake(330, 7.5, 40, 25);
    
    if (self.view.frame.size.width < 360) {
        frame.origin.x = 280;
        
    }else{
        frame = frame;
    }
    UIButton *button=[UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    [button setTitle:@"更多" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [self.scrollview addSubview:view];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    if (self.view.frame.size.width < 360) {
        CGFloat width = (self.view.frame.size.width-5*4)/3.0;
        layout.itemSize = CGSizeMake(width, 180);
        layout.sectionInset = UIEdgeInsetsMake(5, 2, 5,2);
        layout.minimumInteritemSpacing=1;
    }else{
        layout.itemSize=CGSizeMake(110, 180);
        layout.sectionInset=UIEdgeInsetsMake(5, 10, 5, 10);
        layout.minimumInteritemSpacing=10;
    }
    layout.minimumLineSpacing=5;
    
    
    self.collectionview=[[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), self.view.frame.size.width, 190) collectionViewLayout:layout];
    self.collectionview.backgroundColor=[UIColor whiteColor];
    [_collectionview registerNib:[UINib nibWithNibName:@"SharedCell" bundle:nil] forCellWithReuseIdentifier:@"cellid"];
    
    [self.scrollview addSubview:_collectionview];
    
    _collectionview.delegate=self;
    _collectionview.dataSource=self;
    self.scrollview.contentSize=CGSizeMake(0, CGRectGetMaxY(self.collectionview.frame));
}



//buton
-(void)fetchdata{
    CommentViewController *comment=[[CommentViewController alloc]init];
    comment.url=self.urlPath;
    comment.Id=self.shareId;
    comment.num=self.num;
    [self.navigationController pushViewController:comment animated:YES];
}
-(void)showMore{
    NearByViewController *nearby = [[NearByViewController alloc]init];
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:nearby];
    nearby.title=self.cloth.Title;
    
    nearby.navigationController.navigationBar.titleTextAttributes=@{NSFontAttributeName:[UIFont fontWithName:@"Arial Rounded MT Bold" size:20],NSForegroundColorAttributeName:[UIColor orangeColor]};
    
    nearby.clothid=self.cloth.ClothingID;
    [self presentViewController:nvc animated:YES completion:nil];
}

-(void)FecthData{
    NSString *url=self.url;
    [_manager GET:[NSString stringWithFormat:kNear,url] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        for (int i=0; i<arr.count; i++) {
            NSDictionary *dict=arr[i];
            CellModel *model=[[CellModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.array addObject:model];
        }
        
        [_collectionview reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark-
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SharedCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    CellModel *model=self.array[indexPath.row];
    cell.model=model;
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CellModel *model=self.array[indexPath.row];
    NearViewController *near=[[NearViewController alloc]init];
    near.shareId=model.ShareID;
    [near fetchWebDataWithUrl:[NSString stringWithFormat:kpicture,near.shareId]];
    //[near loadData:[NSString stringWithFormat:kPL,near.shareId]];
    [self.navigationController pushViewController:near animated:YES];
}

@end
