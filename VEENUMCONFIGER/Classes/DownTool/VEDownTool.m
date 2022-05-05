//
//  VEDownTool.m
//  VE
//
//  Created by iOS VESDK Team on 2017/3/22.
//  Copyright © 2017年 iOS VESDK Team. All rights reserved.
//


#import "VEDownTool.h"
@interface VEDownTool()<NSURLSessionDownloadDelegate>
{
    NSString* _savePath;
}
@property (nonatomic,strong) NSURLSession* session;
@property (nonatomic,strong) NSURLSessionDownloadTask* task;

@end
@implementation VEDownTool
- (instancetype)initWithURLPath:(NSString*)path savePath:(NSString*)savePath
{
    if (self = [super init]) {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        NSURL* taskURL = [[NSURL URLWithString:path] copy];
        //20170412 用下面这种方式可以设置请求方式 get 还是 post
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:taskURL];
        request.HTTPMethod = @"GET";
        self.task = [self.session downloadTaskWithRequest:request];
        _savePath = nil;
        _savePath = [savePath copy];

        
        return self;
    }
    return nil;
}


- (void) start;
{
    [self.task resume];
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if ([downloadTask.response.suggestedFilename.pathExtension isEqualToString:@"zip"]) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:_savePath]) {
            unlink(_savePath.UTF8String);
        }else {
            [[NSFileManager defaultManager] createDirectoryAtPath:_savePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        _savePath = [_savePath stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    }
    [fileManager moveItemAtPath:location.path toPath:_savePath error:&error];
    
    if (_Finish) {
        _Finish(_savePath);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    [_session finishTasksAndInvalidate];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    float value = (float)totalBytesWritten/totalBytesExpectedToWrite;
    NSLog(@"%f",value);
    if ([self Progress]) {
        _Progress(value);
    }
}
@end
