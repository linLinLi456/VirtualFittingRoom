//
//  HelpTwoViewController.m
//  VirtualFittingRoom
//
//  Created by qianfeng on 15-10-10.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import "HelpViewController.h"
#import "VideoDownLoad.h"

@interface HelpViewController ()
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIScrollView *photoScroll;
@property (nonatomic) UIImageView *image1;
@property (nonatomic) UIImageView *image2;
@property (nonatomic) UIScrollView *photoScroll2;
@property (nonatomic) CGFloat contentSize;
@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    [self setUp];
//    [self addScrollView];
}

- (void)addScrollView {
    self.photoScroll.contentSize = CGSizeMake(600, 0);
    self.photoScroll.showsHorizontalScrollIndicator = NO;
    self.photoScroll2.contentSize = CGSizeMake(600, 0);
    self.photoScroll2.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(0, 1000);
    self.scrollView.showsVerticalScrollIndicator= NO;
}

- (void)setUp {
    self.scrollView  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self addleftItem];
    [self addRightItem];
    [self addTitleLabel];
    [self initView];
//    self.scrollView.contentSize = CGSizeMake(0, 1000);
//    self.scrollView.contentSize = CGSizeMake(0, self.scrollView.contentSize.height);
    self.scrollView.contentSize = CGSizeMake(0, self.contentSize);

    [self.view addSubview:self.scrollView];
}

- (void)initView {
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.scrollView.frame.size.width - 20, 120)];
    textLabel.text = @"\t我们真心的希望您能从我们虚拟试衣间找到真正合适您的衣服以及搭配，前提是需要您的一张合适的照片，当然这将会耗去您的一点时间和精力，但之后成千上万套的衣服随意真实试穿，并不断发现适合自己的衣服搭配一斤全新形象的展示，我们期待您的加入！（试衣拍照请参考第一段文字~）当您不方便按要求拍照的时候，您可以从下面的标准试衣照片中选择一张来体验一下试穿的神奇感觉";
    textLabel.numberOfLines = 0;
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.adjustsFontSizeToFitWidth = YES;
    [self.scrollView addSubview:textLabel];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    UIImage *image = [UIImage imageNamed:@"help_step.png"];
    imageView.frame = CGRectMake(0, CGRectGetMaxY(textLabel.frame), self.view.frame.size.width, image.size.height / image.size.width * self.view.frame.size.width);
    imageView.image = image;
    [self.scrollView addSubview:imageView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), self.view.frame.size.width, 500)];
    CGRect frame = CGRectMake(5, 6, 10, 10);
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    button.layer.cornerRadius = 5;
    button.backgroundColor = [UIColor blackColor];
    [view addSubview:button];
    
    frame = CGRectMake(20, 1, view.frame.size.width - 20, 20);
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"以下是合格的照片";
    [view addSubview:label];
    
    UIImage *goodImage = [UIImage imageNamed:@"bg_help_good.jpg"];
    UIImageView *goodImageView = [[UIImageView alloc] initWithImage:goodImage];
    frame = CGRectMake(0, 1, view.frame.size.width / 0.6, 0);
    frame.size.height = 1.0 * (goodImage.size.height * frame.size.width) / goodImage.size.width;
    UIScrollView *goodScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame) + 1, view.frame.size.width, frame.size.height + 1)];
    
    goodImageView.frame = frame;
    [goodScrollView addSubview:goodImageView];
    goodScrollView.bounces = NO;
    [goodScrollView setContentSize:CGSizeMake(view.frame.size.width /0.6,0)];
    [view addSubview:goodScrollView];
    
    frame = CGRectMake(20, CGRectGetMaxY(goodScrollView.frame) + 1, view.frame.size.width - 20, 20);
    label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"以下是不合格的照片";
    [view addSubview:label];
    frame = CGRectMake(5, CGRectGetMaxY(goodScrollView.frame)+5 + 1, 10, 10);
    button =  [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    button.layer.cornerRadius = 5;
    button.backgroundColor = [UIColor blackColor];
    [view addSubview:button];
    
    UIImage *noImage = [UIImage imageNamed:@"bg_help_no.jpg"];
    UIImageView *noImageView = [[UIImageView alloc] initWithImage:noImage];
    frame = CGRectMake(0, 1, view.frame.size.width / 0.6, 0);
    frame.size.height = 1.0 * (noImage.size.height * frame.size.width) / noImage.size.width;
    noImageView.frame = frame;
    
    UIScrollView *noScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame) + 1, view.frame.size.width, frame.size.height)];
    noScrollView.bounces = NO;
    [noScrollView setContentSize:CGSizeMake(view.frame.size.width /0.6,0)];
    [noScrollView addSubview:noImageView];
    [view addSubview:noScrollView];
    frame = view.frame;
    frame.size.height = CGRectGetMaxY(noScrollView.frame);
    view.frame = frame;
    [self.scrollView addSubview:view];

    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), self.view.frame.size.width, 500)];
    bottomLabel.text = @"";
    bottomLabel.numberOfLines = YES;
    
    [self.scrollView addSubview:bottomLabel];
    
    self.contentSize = CGRectGetMaxY(view.frame);
}

- (void)addRightItem {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"btn_video_1"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 35, 35);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = item;
}

- (void)addTitleLabel {
    UILabel *label = [UILabel new];
    label.text = @"使用帮助";
    label.textColor = [UIColor orangeColor];
    label.font = [UIFont boldSystemFontOfSize:22];
    label.frame = CGRectMake(0, 0, 30, 30);
    self.navigationItem.titleView = label;
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

- (void)clickButton:(UIButton *)button {
    VideoDownLoad *controller  = [VideoDownLoad new];
    controller.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentViewController:controller animated:YES completion:nil];
}
@end