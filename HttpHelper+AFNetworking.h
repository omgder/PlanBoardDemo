//
//  XLHTTPResponseSerializer.h
//  iThunder
//
//  Created by zzy on 14/12/24.
//  Copyright (c) 2014年 xunlei.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface XLHTTPResponseSerializer : AFHTTPResponseSerializer
+ (instancetype)serializer;
@end
