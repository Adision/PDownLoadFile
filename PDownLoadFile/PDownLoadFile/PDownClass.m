//
//  PDownClass.m
//  PDownLoadFile
//
//  Created by Apple on 2017/1/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "PDownClass.h"
#import "AFNetworking.h"
@implementation PDownClass

+(void)downFileWitchUrl:(NSString*)url progress:(void (^)(NSProgress *downloadProgress))progress completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler
{
    NSURL*URL=[NSURL URLWithString:url];
    NSURLSessionConfiguration*configuration=[NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager*manager=[[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest*request=[NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask=[manager downloadTaskWithRequest:request progress:progress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fullpath = [caches stringByAppendingPathComponent:response.suggestedFilename];
        NSURL *filePathUrl = [NSURL fileURLWithPath:fullpath];
        return filePathUrl;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        completionHandler(response,filePath,error);
    }];
    [downloadTask resume];
}

+(void)judgeNetwork:(void(^)(PNetworkReachabilityStatus status))block
{
    AFNetworkReachabilityManager*networkManager=[AFNetworkReachabilityManager sharedManager];
    //监控网络状态，先调用单例
    [networkManager startMonitoring];
    [networkManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        block((PNetworkReachabilityStatus)status);
    }];
}

//-(void)downLoadFile
//{
//    
//}
@end
