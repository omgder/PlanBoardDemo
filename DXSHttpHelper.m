//
//  XLHttpHelper.m
//  iThunder
//
//  Created by xunlei on 14-9-12.
//  Copyright (c) 2014年 xunlei.com. All rights reserved.
//

#import "XLHttpHelper.h"

#pragma mark - Class HttpHelper

@implementation XLHttpHelper

- (id)init
{
    if(self = [super init])
    {
    }
    return self;
}

- (NSDictionary *)defaultParams
{
    return [AppServerConfig defaultParams];
}

- (NSDictionary *)defaultHttpHeaderFields
{
    return [AppServerConfig defaultParams];
}

+ (instancetype)sharedHelper
{
    static XLHttpHelper* helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[XLHttpHelper alloc] init];
    });
    return helper;
}


+ (instancetype)httpHelper
{
    XLHttpHelper* helper = [[XLHttpHelper alloc] init];
    return helper;
}

@end


@implementation XLHttpHelper (extend)

- (NSDictionary *)defaultParams2
{
    return [AppServerConfig defaultParams2];
}

- (void)get:(NSString *)path
     params:(NSDictionary *)params
 usingCache:(BOOL)cached
    success:(HttpRequestSuccessBlock)success
    failure:(HttpRequestFailureBlock)failure
{
    HttpRequest *request = [HttpRequest requestWithGetPath:path params:params];
    request.usingCache   = cached;
    [[request success:success failure:failure] submitToHttpHelper:self];
}

@end


#pragma mark - Class XLHttpDownloadHelper

@implementation XLHttpDownloadHelper

+ (instancetype)sharedHelper
{
    static XLHttpDownloadHelper* helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[XLHttpDownloadHelper alloc] init];
    });
    return helper;
}


+ (instancetype)httpDownloadHelper
{
    XLHttpDownloadHelper* helper = [[XLHttpDownloadHelper alloc] init];
    return helper;
}

@end