//
//  WWFileDownload.h
//  多媒体
//
//  Created by qianfeng007 on 15-9-19.
//  Copyright (c) 2015年 1512. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WWDownloaderFailType)(NSError *error);
typedef void (^WWDownloaderType)(long long downloadSize,long long totalSize);
typedef void (^WWSuccessType)();

@interface WWFileDownload : NSObject

@property (nonatomic, copy) NSString *urlStr;

@property (nonatomic, copy) WWDownloaderFailType failHandler;
@property (nonatomic, copy) WWDownloaderType downloadSize;
@property (nonatomic, copy) WWSuccessType success;
//为了提示
- (void)setFailHandler:(WWDownloaderFailType)failHandler;
- (void)setDownloadSize:(WWDownloaderType)downloadSize;
- (void)setSuccess:(WWSuccessType)success;

- (void)start;//开始下载
- (void)stop;//停止下载

@end
