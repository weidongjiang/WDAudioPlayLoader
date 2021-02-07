//
//  WDAudioPlayRequestTask.m
//  WDAudioPlayCacheLoader
//
//  Created by 伟东 on 2021/2/7.
//
#import <UIKit/UIKit.h>
#import "WDAudioPlayRequestTask.h"
#import "WDAudioPlayCacheTools.h"


static const CGFloat WDAudioPlayRequestTaskTimeout = 10.0;


@interface WDAudioPlayRequestTask ()<NSURLConnectionDataDelegate,NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;// 回话对象
@property (nonatomic, strong) NSURLSessionDataTask *task;// 任务

@end


@implementation WDAudioPlayRequestTask
- (instancetype)init {
    if (self = [super init]) {
        [WDAudioPlayCacheTools tempFilePathFileName:@"MusicTemp.mp4"];
    }
    return self;
}


/// 开始请求
- (void)requestStart {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[WDAudioPlayCacheTools originalSchemeURL:self.requestUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:WDAudioPlayRequestTaskTimeout];
    
    if (self.requestOffset > 0) {
        NSString *value = [NSString stringWithFormat:@"bytes=%ld-%ld",self.requestOffset,self.fileLength-1];
        [request addValue:value forHTTPHeaderField:@"Range"];
    }
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    self.task = [self.session dataTaskWithRequest:request];
    [self.task resume];
}

- (void)setIsCancel:(BOOL)isCancel {
    _isCancel = isCancel;
    [self.task cancel];
    [self.session invalidateAndCancel];
}





@end
