//
//  VideoDownLoad.m
//  VirtualFittingRoom
//
//  Created by qianfeng007 on 15-10-5.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import "VideoDownLoad.h"
#import "WWFileDownload.h"

#define URL @"http://clothing.yyasp.net/Download.aspx?HelpVideo=1.mp4"

@interface VideoDownLoad ()

@property (weak, nonatomic) IBOutlet UIButton *downLoadButton;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@property (nonatomic)WWFileDownload *downloader;
@end

@implementation VideoDownLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//播放视频
- (void)loadMoviePlayerWithUrl:(NSString *)url {
    if (self.progressView.progress == 1.0) {
        NSURL *movieUrl = nil;
        if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
            movieUrl = [NSURL URLWithString:url];
        } else {
            movieUrl = [NSURL fileURLWithPath:url];
        }
        MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:movieUrl];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
        player.moviePlayer.shouldAutoplay = 1;//自动播放
        [self presentViewController:player animated:1 completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请先下载完视频在播放" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
    }
 
}

//懒加载，确保——downloader不为空
- (WWFileDownload *)downloader {
    if (_downloader == nil) {
        _downloader = [WWFileDownload new];
        _downloader.urlStr = URL;
        [self test];
    }
    return _downloader;
}

- (IBAction)return:(UIButton *)sender {
    sender.selected = !sender.selected;
     [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)playEnd:(NSNotification *)notification {

}

//下载
- (IBAction)downLoadButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if (button.selected) {
        [self.downloader start];
    } else {
        [self.downloader stop];
    }
}

//播放下载的视频
- (IBAction)playVideo:(id)sender {
    //第一个Documents
     //NSString *docPath1 = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/WWfileDownload"];
     NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, 1) lastObject];
    NSLog(@"%@",docPath);
    NSString *filePath = [NSString stringWithFormat:@"%@/WWfileDownload/VirtualFitting.mp4",docPath];
    [self loadMoviePlayerWithUrl:filePath];
    if (self.progressView.progress == 1.0) {
        UIButton *button = (UIButton *)sender;
        [button setTitle:@"视频已经下载完毕，点击播放" forState:UIControlStateNormal];
        
    } else {
        return;
    }
}

- (void)test {
    //错误
    [_downloader setFailHandler:^(NSError *error){
        NSLog(@"出现错误:%@",error);
    }];
    //下载
    __weak typeof(self) mySelf = self;
    [_downloader setDownloadSize:^(long long downloadSize, long long totalSize) {
        float progress = 1.0*downloadSize/totalSize;//0.0-1.0
        mySelf.progressView.progress = progress;
        //0.5->>50%
        NSString *str = [NSString stringWithFormat:@"%0.2f%%",progress*100];
        mySelf.progressLabel.text = str;
    }];
    //完成
    [_downloader setSuccess:^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"虚拟试衣间" message:@"已经下载完毕" delegate:mySelf cancelButtonTitle:@"cencal" otherButtonTitles:@"OK", nil];
        [alertView show];
        
        mySelf.progressView.progress = 1.0;
        mySelf.progressLabel.text  = @"100%";
    }];
    
}

@end
