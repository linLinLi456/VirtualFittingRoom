//
//  MySettingController.m
//  Demo
//
//  Created by qianfeng on 15/9/29.
//  Copyright (c) 2015年 李娟. All rights reserved.
//

#import "MySettingController.h"
#import "shoucangViewController.h"
#import "ShareViewController1.h"
#import "FeedbackViewController.h"
#import "StoreViewController.h"
#import "VersionsViewController.h"
#import "DelectedViewController.h"
#import "HelpViewController.h"
#import "DownloadViewController.h"
#import "ShareSoftViewController.h"
#import "ShiyiViewController.h"
#import "SDImageCache.h"
#import "UMSocial.h"
//#import "ExternFile.h"

@interface MySettingController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UMSocialUIDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *array1;
@property (nonatomic) NSArray *array2;
@property (nonatomic) NSMutableArray *dataArray;
@property (nonatomic) NSString *version;
@property (nonatomic) double MBsize;

@end

@implementation MySettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTableview];
    [self setUp];
}

- (void)setUp {
    _array1 = [NSArray arrayWithObjects:@"衣库收藏",@"试衣记录",@"我的分享",@"意见反馈",@"关注商店",nil];
    _array2 = [NSArray arrayWithObjects:[NSString stringWithFormat:@"当前版本:V1.1.0"], @"清除缓存",@"使用帮助",@"扫码下载",@"分享软件",nil];
    _dataArray = [NSMutableArray array];
    [_dataArray addObject:_array1];
    [_dataArray addObject:_array2];
}

-(void)addTableview{
    self.navigationItem.title=@"个人中心";
    UINavigationBar *bar = self.navigationController.navigationBar;
    bar.translucent = YES; // 不透明
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 15, self.view.frame.size.width, self.view.frame.size.height - 64- 49) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.tableHeaderView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_tableView];
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.dataArray[section];
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellId"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
       cell.textLabel.text = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.section][indexPath.row]];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 0 ? @"个人" : @"系统";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
//selected

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                shoucangViewController *controller = [[shoucangViewController alloc] init];
             UINavigationController *niv=[[UINavigationController alloc]initWithRootViewController:controller];
               
                [self presentViewController:niv animated:YES completion:nil];
                break;
            }
            case 1:{
                ShiyiViewController *controller = [[ShiyiViewController alloc] init];
                UINavigationController *niv=[[UINavigationController alloc]initWithRootViewController:controller];

                [self presentViewController:niv animated:YES completion:nil];
                break;
            }
            case 2:{
                ShareViewController1 *controller = [[ShareViewController1 alloc] init];
                UINavigationController *niv=[[UINavigationController alloc]initWithRootViewController:controller];
             
                [self presentViewController:niv animated:YES completion:nil];
                break;
            }
            case 3: {
                FeedbackViewController *controller = [FeedbackViewController new];
                UINavigationController *niv=[[UINavigationController alloc]initWithRootViewController:controller];
              
                [self presentViewController:niv animated:YES completion:nil];
                break;
            }
            case 4:{
                StoreViewController *controller = [StoreViewController new];
                UINavigationController *niv=[[UINavigationController alloc]initWithRootViewController:controller];
           
                [self presentViewController:niv animated:YES completion:nil];
                break;
            }
            default:
                break;
           
        }
    } else {
        switch (indexPath.row) {
            case 0: {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"当前版本" message:@"已经是最新版本，谢谢支持！" delegate:nil cancelButtonTitle:@"cancel"otherButtonTitles:@"ok", nil];
                [alertView show];
                break;
            }
            case 1: {
                NSString *str = [NSString stringWithFormat:@"您有%lfMB缓存垃圾",[self getCacheSize]];
                UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"清除缓存" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                [alerView show];
                break;
            }
            case 2:{
                HelpViewController *controller = [HelpViewController new];
                UINavigationController *niv=[[UINavigationController alloc]initWithRootViewController:controller];
                // controller.modalPresentationStyle = UIModalTransitionStylePartialCurl;
                [self presentViewController:niv animated:YES completion:nil];
                break;
            }
            case 3:{
                DownloadViewController *controller = [DownloadViewController new];
                UINavigationController *niv = [[UINavigationController alloc] initWithRootViewController:controller];
                [self presentViewController:niv animated:YES completion:nil];
                break;
            }
            case 4:{
                [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
                
                //注意：分享到微信好友、微信朋友圈、微信收藏、QQ空间、QQ好友、来往好友、来往朋友圈、易信好友、易信朋友圈、Facebook、Twitter、Instagram等平台需要参考各自的集成方法
                NSString *str = [[NSBundle mainBundle] pathForResource:@"AppIcon29x29@2x" ofType:@"png"];
                [UMSocialSnsService presentSnsIconSheetView:self
                    appKey:@"56121cf767e58e3f350033d9"
                    shareText:@"我在搞友盟之1512之iOS"
                    shareImage:[UIImage imageNamed:str]
                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQQ,nil]
                     delegate:self];
            }
                break;
                
            default:
                break;
        }
    }
}

- (double)getCacheSize {
        // 获取缓存
        // SDWebImage自身下载图片有缓存
        SDImageCache *imageCache = [SDImageCache sharedImageCache];
        NSUInteger fileSize = [imageCache getSize]; // 以字节为单位
        
        // 本地下载的缓存（我们自己搞的缓存）
        NSString *myCachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/com.hackemist.SDWebImageCache.default"];
        // 获取指定文件信息
        NSFileManager *fm = [NSFileManager defaultManager];
        NSDictionary *fileInfo = [fm attributesOfItemAtPath:myCachePath error:nil];
    
        // SD图片缓存加上我们自己的缓存
        fileSize += fileInfo.fileSize;
        
        // 以兆为单位返回
    self.MBsize = fileSize/1024.0/1024.0;
        return fileSize/1024.0/1024.0;
    }

#pragma mark - 清除缓存

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) { // 确定清除
        [self removeCacheData];
    } else {
    }
}

- (void)removeCacheData {
    // SD清空缓存（实际上就是把缓存在本地的图片删除掉）
    [[SDImageCache sharedImageCache] clearDisk];
}

@end
