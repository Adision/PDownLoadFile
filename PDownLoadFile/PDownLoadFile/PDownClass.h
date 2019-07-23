//
//  PDownClass.h
//  PDownLoadFile
//
//  Created by Apple on 2017/1/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PNetworkReachabilityStatus) {
    PNetworkReachabilityStatusUnknown          = -1,
    PNetworkReachabilityStatusNotReachable     = 0,
    PNetworkReachabilityStatusReachableViaWWAN = 1,
    PNetworkReachabilityStatusReachableViaWiFi = 2,
};

@interface PDownClass : NSObject

+(void)judgeNetwork:(void(^)(PNetworkReachabilityStatus status))block;
+(void)downFileWitchUrl:(NSString*)url progress:(void (^)(NSProgress *downloadProgress))progress completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

@end
