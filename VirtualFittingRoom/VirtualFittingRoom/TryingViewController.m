//
//  FittingViewController.m
//  VirtualFittingRoom
//
//  Created by qianfeng on 15-10-3.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import "TryingViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "test.h"
#import "AFNetworking.h"
#import "UMSocial.h"
#import "NSString+util.h"
#import "ClothModel.h"
#import "DBManager.h"
#import "UIImageView+WebCache.h"
#import "rightScrollCell.h"

@interface TryingViewController () <UIScrollViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UMSocialUIDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

//右侧滚动视图
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) ClothModel *modelArray;
@property (nonatomic) NSMutableArray *clothesArr;

@property (nonatomic) UIView *buttonView;
@property (nonatomic) UIView *bottomView;               //  底部view，为了放底部的button
@property (nonatomic) UIImage *backgroundImage;
@property (nonatomic, copy) NSString *picturePath;      //  图片所在的本地地址
@property (nonatomic) UIImageView *cameraImageView;     //  设置拍照提示文字视图
@property (nonatomic) UIImageView *clothingImageView;   //
@property (nonatomic) UIImageView *clothImageView;   //
@property (nonatomic) UIImage *clothingImage;
@property (nonatomic) CGRect buttonFrame;               //  设置右侧小按钮的frame
@property (nonatomic) CGRect viewFrame;                 //  设置右侧隐藏view的frame
@property (nonatomic) BOOL isOne;                       //  标记 右侧button
@property (nonatomic) BOOL isTwo;                       //  、、、
@property (nonatomic) BOOL is;                          //  标记返回值 是否返回到衣库
@property (nonatomic) UIScrollView *rightScrollView;    //
@property (nonatomic) UIImageView *backgroundImageView; //
@property (nonatomic) UIView *myView;
@property (nonatomic) UIScrollView *tryToKnowScrollView;
@property (nonatomic, copy) NSString *clothingUrl;      //  衣服的请求地址
//@property (nonatomic, copy) NSString *clothingName;     //  传过来的图片名字
@property (nonatomic) NSTimer *timer;

@end

@implementation TryingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self settingMyView];
    [self initUI];
}

- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.isOne = NO;
    self.isTwo = NO;

    [self returnButton];   // 返回按钮
    [self addRightButton];
    [self addBottomView];
    [self addButtons];
}

- (void)setData {
    self.picturePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"picture.png"];
//    NSLog(@"%@", self.picturePath);
    self.clothingUrl = [NSString stringWithFormat:@"http://clothing.yyasp.net/download.aspx?Clothing=%@", self.clothingName];
    if (self.clothingName) {
        [self fetchImage];
    }
}

- (void)fetchImage {  //  根据地址请求图片资源 然后赋值给self.clothingImage
//    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading.png"]];
    
    [self.clothingImageView sd_setImageWithURL:[NSURL URLWithString:self.clothingUrl] placeholderImage:[UIImage imageNamed:@"load"]];
    self.clothingImage = self.clothingImageView.image;
}

- (void)settingMyView {
    self.myView = [[UIView alloc] initWithFrame:self.view.frame];
    if ([self settingBackgroundImage:@"bg_info_camera.png" text:@"  请点击此处，拍张照片吧！" animated:[[NSFileManager defaultManager] fileExistsAtPath:self.picturePath]]) {
        
        NSData *data = [NSData dataWithContentsOfFile:self.picturePath];
        UIImage *image2 = [UIImage imageWithData:data];
        
        [self setImageView:image2];
    }
    [self.view addSubview:self.myView];

    [self settingClothingView:self.clothingImage];
}

- (UIImageView *)clothingImageView {
    if (_clothingImageView == nil) {
        _clothingImageView = [[UIImageView alloc] init];
        [self addRotationGesture];
        [self addPanGesture];
        _clothingImageView.userInteractionEnabled = YES;
    }
    return _clothingImageView;
}

- (void)pinch:(UIPinchGestureRecognizer *)pinch {
    self.clothingImageView.transform = CGAffineTransformScale(self.clothingImageView.transform, pinch.scale, pinch.scale);
    pinch.scale = 1.0;
}

// 旋转
- (void)addRotationGesture {
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotation:)];
    [self.clothingImageView addGestureRecognizer:rotation];
}

- (void)rotation:(UIRotationGestureRecognizer *)rotation {
//    NSLog(@"弧度：%lf", rotation.rotation);
    self.clothingImageView.transform = CGAffineTransformRotate(self.clothingImageView.transform, rotation.rotation);
    rotation.rotation = 0; // 重置 旋转的弧度 相对于当前的 从0 开始
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint previousPoint = [touch previousLocationInView:self.backgroundImageView];
    CGPoint currenPoint = [touch locationInView:self.backgroundImageView];
    CGPoint offset = CGPointMake(currenPoint.x-previousPoint.x, currenPoint.y-previousPoint.y);

    CGPoint center = self.clothingImageView.center;
    center.x += offset.x;
    center.y += offset.y;
    self.clothingImageView.center = center;
}

- (void)addPanGesture {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.clothingImageView addGestureRecognizer:pan];
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self.view];
    CGPoint center = self.clothingImageView.center;
    center.x += point.x;
    center.y += point.y;
    self.clothingImageView.center = center;
    [pan setTranslation:CGPointZero inView:self.view];
}

- (void)settingClothingView:(UIImage *)image {
    if (image == nil) {
       // [self settingBackgroundImage:@"bg_info_clothing.png" text:@" 请点击此处，选件衣服吧！"];
    } else {
        self.clothingImageView.image = image;
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
        pinch.delegate = self;
        [_clothingImageView addGestureRecognizer:pinch];
        
        CGRect frame = CGRectMake(0, 0, 150, 1.0 * image.size.height / image.size.width * 150);
        self.clothingImageView.frame = frame;

        self.clothingImageView.center = self.backgroundImageView.center;
        [self.backgroundImageView addSubview:self.clothingImageView];
    }
}

- (void)settingBackgroundImage:(NSString *)string text:(NSString *)text{
    if ((string == nil || text == nil) ) {
        return;
    } else if (![[NSFileManager defaultManager] fileExistsAtPath:self.picturePath]) {
        return;
    }
    //        self.clothingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:string]];

    self.clothingImageView.image = [UIImage imageNamed:@"loading.png"];
    self.clothingImageView.frame = CGRectMake(20, self.view.frame.size.height - 125, self.view.frame.size.width - 95, 75);
    CGRect frame = self.clothingImageView.frame;
    frame.size.height -= 20;
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.clothImageView];
    [self.clothImageView addSubview:label];
}

- (BOOL)settingBackgroundImage:(NSString *)string text:(NSString *)text animated:(BOOL)animated{
    if (animated) {
        return animated;
    } else {
        self.cameraImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:string]];
        self.cameraImageView.frame = CGRectMake(40, self.view.frame.size.height - 125, self.view.frame.size.width - 95, 75);
        CGRect frame = self.cameraImageView.frame;
        frame.size.height -= 20;
        UILabel *label = [[UILabel alloc] init];
        label.text = text;
        label.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:self.cameraImageView];
        [self.cameraImageView addSubview:label];
    }
    return NO;
}

- (void)setImageView:(UIImage *)image {
    self.backgroundImageView = [[UIImageView alloc] initWithImage:image];
    self.backgroundImageView.userInteractionEnabled = YES;
    self.backgroundImageView.frame = self.myView.frame;
    [self.myView addSubview:self.backgroundImageView];
    [self settingClothingView:self.clothingImage];
}
//右侧滚动视图
- (void)addScrollView {
    self.viewFrame = CGRectMake(self.view.frame.size.width, 0, 59, self.view.frame.size.height);
    self.rightScrollView = [[UIScrollView alloc] initWithFrame:self.viewFrame];
    self.rightScrollView.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:self.rightScrollView];
}

- (void)addRightButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonFrame = CGRectMake(self.view.frame.size.width - 25, 0, 25, 50);
    button.frame = self.buttonFrame;
    [button setBackgroundImage:[[UIImage imageNamed:@"room_clothing_favor_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    [button setBackgroundImage:[[UIImage imageNamed:@"room_clothing_favor_2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
    
    button.tag = 110;
    [button addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [self addScrollView];
}

- (void)rightButtonClick:(UIButton *)button {
    self.isOne = !self.isOne;
    NSLog(@"%d", self.isOne);
    if (self.isOne) {
        self.buttonFrame = [self returnSubtractFrame:self.buttonFrame];
        button.frame = self.buttonFrame;
        self.viewFrame = [self returnSubtractFrame:self.viewFrame];
        self.rightScrollView.frame = self.viewFrame;
        [self creatCollection];
    } else {
        self.buttonFrame = [self returnAddFrame:button.frame];
        button.frame = self.buttonFrame;
        self.collectionView.hidden = YES;
        self.viewFrame = [self returnAddFrame:self.viewFrame];
        self.rightScrollView.frame = self.viewFrame;
    }
}

- (CGRect)returnAddFrame:(CGRect)frame {
    frame.origin.x += 58;
    return frame;
}

- (CGRect)returnSubtractFrame:(CGRect)frame {
    frame.origin.x -= 58;
    return frame;
}

- (void)addButtons {
    CGRect frame = self.view.frame;
    CGFloat X = 30;
    CGFloat padding = (frame.size.width - 5 * X - 40) / 5.0;
    CGFloat Y = frame.size.height - 49;
    NSArray *array = @[@"room_clothing_", @"room_set_", @"room_camera_", @"room_share_", @"room_save_", ];
    NSArray *titles = @[@"选衣", @"调整", @"拍照", @"分享", @"保存"];
    
    for (int i = 0; i < 5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(padding + (padding + X) * i, 3 + Y, X, 32);
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@1.png", array[i]]] forState:UIControlStateNormal];
        button.tag = 101 + i;
        UILabel *label = [[UILabel alloc] init];
        CGRect labelFrame = CGRectMake(button.frame.origin.x, button.frame.origin.y + button.frame.size.height, button.frame.size.width, 47 - button.frame.size.height);
        label.frame = labelFrame;
        
        label.text = titles[i];
        label.adjustsFontSizeToFitWidth = YES;
        label.font = [UIFont systemFontOfSize:11];
        label.textAlignment = NSTextAlignmentCenter;
        
        [button addTarget:self action:@selector(buttonClicks:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [self.view addSubview:label];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(frame.size.width - 30, 7 + Y, 28, 36);
    [button setImage:[UIImage imageNamed:@"room_more_1.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

/// 小按钮
- (void)buttonClick:(UIButton *)button {

}

- (void)buttonClicks:(UIButton *)button {
    switch (button.tag - 100) {
        case 1: {
            self.is = YES;
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case 2: {
            if (self.clothingImageView.image) {
                [self addTestView:button];
            } else {
                [self setAlertViewWithTitle:@"您未选择衣服" message:@"请选择衣物进行穿戴，然后调整" cancel:@"退出" timer:2.0];
            }
            break;
        }
        case 3: {
            [self cameraView];
            break;
        }
        case 4: {
            //注意：分享到微博、微信朋友圈、Facebook、Twitter、平台需要参考各自的集成方法
            if (self.clothingImageView.image) {
//                NSLog(@"%@", self.backgroundImage);
                [UMSocialSnsService presentSnsIconSheetView:self appKey:@"56121cf767e58e3f350033d9" shareText:@"你们觉得这件衣服怎么样呢，来点建议吧" shareImage:[self getSnapshotImage] shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatTimeline,UMShareToFacebook,UMShareToTwitter,nil] delegate:self];
            } else {
                [self setAlertViewWithTitle:@"您未选择衣服" message:@"请选择衣物进行穿戴,然后再分享。" cancel:@"退出" timer:2.0];
            }
            break;
        }
        case 5: {
            if (self.clothingImageView.image) {
                NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"camera"];
                NSString *picturePath;
                NSFileManager *manger = [NSFileManager defaultManager];
                [manger createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
                while (1) {
                    NSString *string = [[NSString stringWithFormat:@"%u", arc4random()] md5];
                    picturePath = [path stringByAppendingPathComponent:string];
                    [[NSFileManager defaultManager] fileExistsAtPath:picturePath];
                    if (![[NSFileManager defaultManager] fileExistsAtPath:picturePath]) {
                        break;
                    }
                }
                if ([self saveToHome:[self getSnapshotImage] path:[NSString stringWithFormat:@"%@.png", picturePath]]) {
                    [self setAlertViewWithTitle:@"保存试衣记录成功！" message:nil cancel:@"退出" timer:3.0];
                } else {
                    [self setAlertViewWithTitle:@"保存试衣记录失败！" message:nil cancel:@"退出" timer:3.0];
                }
            } else {
                [self setAlertViewWithTitle:@"您未选择衣服" message:@"请选择衣物进行穿戴,然后再保存。" cancel:@"退出" timer:2.0];
            }
            break;
        }
        default:
            break;
    }
}

- (void)setAlertViewWithTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel timer:(CGFloat)num{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancel otherButtonTitles:nil, nil];
    [alertView show];
    _timer = [NSTimer scheduledTimerWithTimeInterval:num target:self selector:@selector(dismissAlertView:) userInfo:alertView repeats:YES];
}

- (void)dismissAlertView:(NSTimer *)sender {
    UIAlertView *alertView = [sender userInfo];
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    [_timer invalidate], _timer = nil;
}

- (void)addTestView:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        [self addViewButton];
    } else {
        [self.buttonView removeFromSuperview];
    }
}

- (void)addViewButton {
    self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 50)];
    self.buttonView.backgroundColor = [UIColor lightTextColor];
    self.buttonView.alpha = 0.5;
    [self addButtonsToView];
    [self.view addSubview:self.buttonView];
}

- (void)addButtonsToView {
    CGFloat width = self.view.frame.size.width / 6.0;
    CGFloat height = 34;
    NSArray *array = @[@"room_change_right_", @"room_change_left_", @"room_change_high_", @"room_change_low_", @"room_change_fat_", @"room_change_thin_"];
    NSArray *strArray = @[@"右旋转", @"左旋转", @"高一点", @"低一点", @"胖一点", @"瘦一点"];
    for (int i = 0; i < 6; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * width, 0, width, height);
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@1", array[i]]];
        UIImageView *view = [[UIImageView alloc] initWithImage:image];
        view.frame = CGRectMake(0, 0, 20, 20);
        view.center = CGPointMake(width / 2.0, height / 2.0);
        [button addSubview:view];
        [button addTarget:self action:@selector(buttonViewClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 400 + i;
        CGRect frame = button.frame;
        frame.origin.y = 36;
        frame.size.height = 10;
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.text = strArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        label.adjustsFontSizeToFitWidth = YES;
        [self.buttonView addSubview:label];
        [self.buttonView addSubview:button];
    }
}

- (void)buttonViewClick:(UIButton *)button {
    switch (button.tag - 400) {
        case 0:
            self.clothingImageView.transform =  CGAffineTransformRotate(self.clothingImageView.transform, M_PI / 360.0 / 4);
            break;
        case 1:
            self.clothingImageView.transform =  CGAffineTransformRotate(self.clothingImageView.transform, -M_PI / 360.0 / 4);
            break;
        case 2: {
            CGPoint center = self.clothingImageView.center;
            CGRect frame = self.clothingImageView.frame;
            frame.size.height +=10;
            self.clothingImageView.frame = frame;
            self.clothingImageView.center = center;
        }
            break;
        case 3: {
            CGPoint center = self.clothingImageView.center;
            CGRect frame = self.clothingImageView.frame;
            frame.size.height -=10;
            self.clothingImageView.frame = frame;
            self.clothingImageView.center = center;
        }
            break;
        case 4: {
            CGPoint center = self.clothingImageView.center;
            CGRect frame = self.clothingImageView.frame;
            frame.size.width += 4;
            self.clothingImageView.frame = frame;
            self.clothingImageView.center = center;
        }
            break;
        case 5:{
            CGPoint center = self.clothingImageView.center;
            CGRect frame = self.clothingImageView.frame;
            frame.size.width -= 4;
            self.clothingImageView.frame = frame;
            self.clothingImageView.center = center;
        }
            break;
        default:
            break;
    }
}

- (void)cameraView {
    CGFloat padding = 6;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(padding * 2 - 5, padding, self.view.frame.size.width - 4 * padding + 10, self.view.frame.size.height - 2 * padding)];
    view.tag = 250;
    view.backgroundColor = [UIColor lightGrayColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    button.frame = CGRectMake(5, 8, 30, 30);
    [button addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];
    view = [self addLabel:view];//  40
    view = [self creatScrollView:view];   //45
    view = [self cameraView2:view];
    [view addSubview:button];

    [self.view addSubview:view];
}

- (void)returnClick {
    UIView *view = [self.view viewWithTag:250];
    [view removeFromSuperview];
}

- (UIView *)addLabel:(UIView *)view {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, view.frame.size.width-2, 40)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"试衣需要这样的图片";
    label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    return  view;
}

- (UIView *)cameraView2:(UIView *)bigView {
    CGRect frame = CGRectMake(0, 43, bigView.frame.size.width, bigView.frame.size.height - 95);
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor lightGrayColor];
    view.delegate = self;
    frame = CGRectMake(0, 0, view.frame.size.width, 60);
    UILabel *textLabel = [[UILabel alloc] initWithFrame:frame];
    textLabel.backgroundColor = [UIColor whiteColor];
    textLabel.textColor = [UIColor blackColor];
    textLabel.font = [UIFont systemFontOfSize:16];
    textLabel.adjustsFontSizeToFitWidth = YES;
    textLabel.numberOfLines = 0;
    NSString *str = @"拍照小提示：穿较贴身的衣服，双手置于后背，两腿并拢身体保持直立，较好的光线，拍摄角度应和被拍摄者保持水平，全身照。这样，您将会享受到真正的试衣乐趣~";
    textLabel.text = [NSString stringWithFormat:@"\t%@", str];
    [view addSubview:textLabel];
    
    frame = CGRectMake(5, CGRectGetMaxY(textLabel.frame)+5 + 1, 10, 10);
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    button.layer.cornerRadius = 5;
    button.backgroundColor = [UIColor blackColor];
    [view addSubview:button];

    frame = CGRectMake(20, CGRectGetMaxY(textLabel.frame) + 1, view.frame.size.width - 20, 20);
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
    
    frame = CGRectMake(0, CGRectGetMaxY(noScrollView.frame), view.frame.size.width, 150);
    textLabel = [[UILabel alloc] initWithFrame:frame];
    textLabel.backgroundColor = [UIColor whiteColor];
    textLabel.textColor = [UIColor blackColor];
    textLabel.font = [UIFont systemFontOfSize:16];
    textLabel.adjustsFontSizeToFitWidth = YES;
    textLabel.numberOfLines = 0;
    str = @"\t我们真心的希望您能从我们虚拟试衣间找到真正合适您的衣服以及搭配，前提是需要您的一张合适的照片，当然这将会耗去您的一点时间和精力，但之后成千上万套的衣服随意真实试穿，并不断发现适合自己的衣服搭配一斤全新形象的展示，我们期待您的加入！（试衣拍照请参考第一段文字~）\n\t当您不方便按要求拍照的时候，您可以从下面的标准试衣照片中选择一张来体验一下试穿的神奇感觉。";
    textLabel.text = [NSString stringWithFormat:@"%@", str];
    [view addSubview:textLabel];

    UIScrollView *smallView = [[UIScrollView alloc] init];
    smallView.frame = CGRectMake(0, CGRectGetMaxY(textLabel.frame), view.frame.size.width, 200);
   
    CGFloat height = 190;
    CGFloat width =  height / (1.0 * self.view.frame.size.height / self.view.frame.size.width);
    CGFloat padding = 5;
    UIView *modelView = [[UIView alloc] initWithFrame:CGRectMake(padding, padding, width + 11 * (width + padding), height)];
    
    for (int i = 0; i < 12; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((padding + width) * i, 0, width, height);
        button.tag   = 150 + i;
        [button addTarget:self action:@selector(pictureButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage  imageNamed:[NSString stringWithFormat:@"%d.jpg", i + 1]] forState:UIControlStateNormal];
        [modelView addSubview:button];
    }
    
    [smallView setContentSize:CGSizeMake(modelView.frame.size.width, 0)];
    [smallView addSubview:modelView];
    smallView.bounces = NO;
    [view addSubview:smallView];
    
    view.bounces = NO;
    [view setContentSize:CGSizeMake(0, CGRectGetMaxY(smallView.frame))];
    [bigView addSubview:view];
    self.tryToKnowScrollView = view;
    return bigView;
}

- (void)pictureButton:(UIButton *)button {
    [self saveToHome:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", (int)button.tag - 149]]];
}

- (UIView *)creatScrollView:(UIView *)view {
    CGFloat height = 45;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - height, view.frame.size.width, height)];
    
    bottomView.backgroundColor = [UIColor blackColor];
    [view addSubview:bottomView];
    
    CGFloat padding = 12;
    CGFloat width = (bottomView.frame.size.width - 4 * padding) / 3;
    CGRect frame = CGRectMake(padding, 5, width, 26);
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = frame;
    button1.backgroundColor = [UIColor whiteColor];
    button1.layer.borderWidth = 1;
    button1.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    button1.layer.cornerRadius = 5;
    button1.titleLabel.font = [UIFont systemFontOfSize:12];
    [button1 setTitle:@"相机拍照" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(button1Click:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:button1];
    
    frame = CGRectMake(padding * 2 + width, 5, width, 26);
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = frame;
    button2.backgroundColor = [UIColor whiteColor];
    button2.titleLabel.font = [UIFont systemFontOfSize:12];
    button2.layer.borderWidth = 1;
    button2.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    button2.layer.cornerRadius = 5;
    [button2 setTitle:@"相册导入" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(button2Click:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:button2];
    
    frame = CGRectMake(padding * 3 + width * 2, 5, width, 26);
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame = frame;
    button3.backgroundColor = [UIColor whiteColor];
    button3.titleLabel.font = [UIFont systemFontOfSize:12];
    button3.layer.borderWidth = 1;
    button3.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    button3.layer.cornerRadius = 5;
    [button3 setTitle:@"标准照片" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(button3Click:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:button3];
    return view;
}

- (void)button1Click:(UIButton *)button {
    [self loadImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (void)button2Click:(UIButton *)button {
    [self loadImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];

}
- (void)loadImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = sourceType;
//        controller.allowsEditing = YES;
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)button3Click:(UIButton *)button {
    CGPoint offset = CGPointMake(0, (self.tryToKnowScrollView.contentSize.height - self.tryToKnowScrollView.bounds.size.height));
    self.tryToKnowScrollView.contentOffset = offset;
//    NSLog(@"%lf, %lf", frame.size.height, frame.size.width);
}

- (void)addBottomView {
    self.bottomView = [[UIView alloc] init];
    self.bottomView.frame = CGRectMake(-2, self.view.frame.size.height - 50, self.view.frame.size.width + 4, 52);
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.alpha = 0.5;
    self.bottomView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.bottomView.layer.borderWidth = 1;
    [self.view addSubview:self.bottomView];
}

- (void)returnButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.is = NO;
    button.frame = CGRectMake(5, 5, 25, 25);
    [button setBackgroundImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(returnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)returnButtonClick:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.is) {
        if (self.myHandler) {
            self.myHandler(1);
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
   // self.isTwo = !self.isTwo;
//    if (self.isTwo) {
//        [self.view bringSubviewToFront:self.myView];
//    } else {
//        [self.view sendSubviewToBack:self.myView];
//    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info { // info存储的就是选中的资源的信息
    NSString *mediaType = info[UIImagePickerControllerMediaType]; // 取选中资源的类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) { // 如果选中的是图片资源
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage]; // 从info中取出图片资源
        [self saveToHome:image];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveToHome:(UIImage *)image {
    if ([self saveToHome:image path:self.picturePath]) {
        self.backgroundImageView.image = image;
    }
    [self returnClick];
}

- (BOOL)saveToHome:(UIImage *)image path:(NSString *)path {
    NSData *data;
    if (UIImagePNGRepresentation(image) == nil) {
        data = UIImageJPEGRepresentation(image, 1);
    } else {
        data = UIImagePNGRepresentation(image);
    }
    return [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
}

// 当点击cancel的时候
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
//    self.tabBarItem.
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(BOOL)isDirectShareInIconActionSheet {
    return YES;
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess) {
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"share"];
        NSString *picturePath;
        NSFileManager *manger = [NSFileManager defaultManager];
        [manger createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        while (1) {
            NSString *string = [[NSString stringWithFormat:@"%u", arc4random()] md5];
            picturePath = [path stringByAppendingPathComponent:string];
            [manger fileExistsAtPath:picturePath];
            if (![manger fileExistsAtPath:picturePath]) {
                [self saveToHome:[self getSnapshotImage] path:[NSString stringWithFormat:@"%@.png", picturePath]];
                break;
            }
        }
        [self setAlertViewWithTitle:@"分享成功！" message:nil cancel:nil timer:(CGFloat)1.0];

        //得到分享到的微博平台名
//        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (UIImage *)getSnapshotImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)), NO, 1);
    [self.backgroundImageView drawViewHierarchyInRect:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) afterScreenUpdates:NO];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshot;
}

#pragma mark - 右侧滚动视图
-(NSMutableArray *)clothesArr{
    if (_clothesArr == nil) {
        _clothesArr = [[NSMutableArray alloc] init];
    }
    return _clothesArr;
}

- (void)creatCollection{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(55, 80);;
    // 行间距（竖直滚动）   列间距（水平滚动）
    layout.minimumLineSpacing = 2;
    // cell(item)之间的最小间距
    layout.minimumInteritemSpacing = 0.0;
    layout.headerReferenceSize = CGSizeMake(0, 0);
    layout.footerReferenceSize = CGSizeMake(0, 0);
    
    // section内边距
    layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
   
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 58, 0, 58, self.view.frame.size.height - 50) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    //注册
    [self.collectionView registerClass:[rightScrollCell class] forCellWithReuseIdentifier:kRightScrollCell];
    NSMutableArray *array = [[DBManager sharedInstance]fetch];
    self.clothesArr = array;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
    [self.collectionView reloadData];
}

////duo少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.clothesArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ClothModel *model = self.clothesArr[indexPath.row];
    rightScrollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRightScrollCell forIndexPath:indexPath];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://clothing.yyasp.net/download.aspx?Clothing=%@", model.image]];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, 53, 76);
    [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"loading.png"]];
    imageView.userInteractionEnabled = 1;
    [cell.contentView addSubview:imageView];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ClothModel *moedl = self.clothesArr[indexPath.row];
    self.clothingName = moedl.cloth;
    [self setData];
    CGRect frame = CGRectMake(0, 0, 200, 200.0 * self.clothingImageView.image.size.height / self.clothingImageView.image.size.width);
    self.clothingImageView.frame = frame;
    self.clothingImageView.center = self.view.center;
    [self.backgroundImageView addSubview:self.clothingImageView];
}

@end
