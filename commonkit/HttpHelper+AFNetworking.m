//
//  XLHTTPResponseSerializer.m
//  iThunder
//
//  Created by zzy on 14/12/24.
//  Copyright (c) 2014年 xunlei.com. All rights reserved.
//

#import "HttpHelper+AFNetworking.h"

@implementation XLHTTPResponseSerializer

+ (instancetype)serializer
{
    return [[self alloc] init];
}

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error
{
    return data;
}

@end
