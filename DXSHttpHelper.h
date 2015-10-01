//
//  XLHttpHelper.h
//  iThunder
//
//  Created by xunlei on 14-9-12.
//  Copyright (c) 2014年 xunlei.com. All rights reserved.
//

#import "HttpHelper.h"

#pragma mark - XLHttpHelper

@interface XLHttpHelper : HttpHelper

+ (instancetype)sharedHelper;
+ (instancetype)httpHelper;

@end

@interface XLHttpHelper (extend)

- (NSDictionary *)defaultParams2;

- (void)get:(NSString *)path
     params:(NSDictionary *)params
 usingCache:(BOOL)cached
    success:(HttpRequestSuccessBlock)success
    failure:(HttpRequestFailureBlock)failure;

@end


#pragma mark - XLHttpDownloadHelper

@interface XLHttpDownloadHelper : HttpDownloadHelper

+ (instancetype)sharedHelper;
+ (instancetype)httpDownloadHelper;

@end