//
//  AboutClothViewController.m
//  VirtualFittingRoom
//
//  Created by qianfeng on 15/10/5.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import "AboutClothViewController.h"
#import "AFNetworking.h"
#import "ClothModel.h"
#import "UIImageView+WebCache.h"
#import "TryingViewController.h"


@interface AboutClothViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *tryNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareNumber;
@property (weak, nonatomic) IBOutlet UILabel *sortsLabel;

@property(nonatomic)NSMutableArray *dataArray;
@property(nonatomic,copy)NSString *clothUrl;
@property(nonatomic,copy)NSString *taoBaoUrl;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation AboutClothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationController.toolbarHidden = YES;
}
-(void)loadDataWithUrl:(NSString *)url{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        self.clothUrl = dict[@"PngName"];
        self.titleLabel.text = dict[@"Title"];
        self.sortsLabel.text = dict[@"ClothingSortNames"];
        self.tryNumberLabel.text  = dict[@"ClothingNumber"];
        self.shareNumber.text = dict[@"ShareNumber"];
        self.taoBaoUrl = dict[@"ClickUrl"];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://clothing.yyasp.net/download.aspx?Clothing=%@",dict[@"JpgName"]]];
        [self.imageView sd_setImageWithURL:url];
        if ([self.delegate respondsToSelector:@selector(clothUrl:)]) {
            [self.delegate clothUrl:self.clothUrl];
        }
        
        [self.view addSubview:_webView];
        NSURL *urls = [NSURL URLWithString:dict[@"ClickUrl"]];
        NSURLRequest *urlRequest = [[NSURLRequest alloc]initWithURL:urls];
        
        [_webView loadRequest:urlRequest];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];

}
- (IBAction)back:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        [button setTintColor:[UIColor clearColor]];
        [button setBackgroundImage:[UIImage imageNamed:@"return2.png"] forState:UIControlStateNormal];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)trying:(id)sender {
    TryingViewController *controller = [[TryingViewController alloc]init];
    controller.clothingName =  self.clothUrl;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)toTaoBao:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.taoBaoUrl]];
}

@end
