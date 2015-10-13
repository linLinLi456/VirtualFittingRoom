//
//  WWFileDownload.m
//  多媒体
//
//  Created by qianfeng007 on 15-9-19.
//  Copyright (c) 2015年 1512. All rights reserved.
//

#import "WWFileDownload.h"
#import "NSString+util.h"

@interface WWFileDownload()

@property (nonatomic, copy) NSString *downloadDirPath;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic) NSFileHandle *writehandle;//文件句柄，用他写服务器传过来的数据
@property (nonatomic) long long totalFileSize;//文件大小
@property (nonatomic) long long downloadFileSize;//当前已经下载的大小
//
@property (nonatomic) NSURLConnection *connection;

@end

@implementation WWFileDownload

- (NSString *)downloadDirPath {
    //文件夹路径是死的
    if (_downloadDirPath == nil) {
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, 1) lastObject];
    //NSString *docPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents"];
        NSLog(@"%@",docPath);
        NSString *dirPath = [docPath stringByAppendingPathComponent:@"WWfileDownload"];//方便管理
        BOOL flag = [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:1 attributes:nil error:nil];//creat
        if (flag) {
            _downloadDirPath = dirPath;
        }
    }
    return _downloadDirPath;
}
//开始下载
- (void)start {
    if ([self prepareDownload]) {//
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
        //重点：设置请求的renge头域，
        [request addValue:[NSString stringWithFormat:@"bytes=%llu-",_downloadFileSize] forHTTPHeaderField:@"range"];
        self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    }
}

- (BOOL)prepareDownload {
    //1. 确保文件存在(urlStr),mei创建
    if (self.urlStr == nil || self.urlStr.length == 0) {
        return NO;
    }
    //md5 加密 算是
   // NSString *fileName = self.urlStr.md5;
    NSString *filePath  = [self.downloadDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", [NSString stringWithFormat:@"VirtualFitting"]]];//路径
    NSLog(@"//路径  %@",filePath);
    BOOL fileExists =  [[NSFileManager defaultManager] fileExistsAtPath:filePath];//文件是不是存在
    if (!fileExists) {
        BOOL creatSuccess = [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
        if (!creatSuccess) {
            return NO;
        }
    }
    
    //2.根据文件路径获取他的大小
    _downloadFileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
    //3.设置写入
    self.writehandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    return YES;
}

- (void)stop {
    [self.connection cancel],self.connection = nil;
    [self.writehandle closeFile];//关闭文件句柄
}
#define mark - <NSURLConnectionDataDelegate>
//失败
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (_failHandler) {
        _failHandler(error);
    }
}

//收到服务器返回来的数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //把数据写入文件
    [self.writehandle seekToEndOfFile];//文件末尾追加
    [self.writehandle writeData:data];
    
    self.downloadFileSize += data.length;
    
    if (_downloadSize) {
        _downloadSize(_downloadFileSize,_totalFileSize);
    }
}

//接收到服务器的响应//connection 只会调用一次
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //bytes=%llu-
    self.totalFileSize = response.expectedContentLength + self.downloadFileSize;
    
    //说明已经下载完了
    if (self.totalFileSize == self.downloadFileSize) {
        [self stop];
        if (_success) {
            _success();
        }
    }
}

//完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (_success) {
        _success();
    }
}


@end
