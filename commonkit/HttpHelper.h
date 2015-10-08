//
//  HttpHelper.h
//  iThunder
//
//  Created by Heaven on 14-9-10.
//  Copyright (c) 2014年 xunlei.com. All rights reserved.
//

/*
 说明：这是Http请求的基类，封装了通用的网络请求操作，用的时候请从此类继承使用。
 （1）作为适配器层，完全隔离其下的第三方网路请求库，目前用的是AFNetworking
 （2）对上层提供统一的调用接口，隔离对第三方库的依赖，不可以暴漏出第三方库的任何接口，无论是通过直接还是间接的方法
 */

#import <Foundation/Foundation.h>

typedef void(^HttpRequestSuccessBlock)(id request, NSError *error, id responseObject, BOOL isCache);
typedef void(^HttpRequestFailureBlock)(id request, NSError *error);
typedef void(^HttpRequestProgressBlock)(id request, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile);

@class HttpRequest;
@class HttpHelper;

#pragma mark - HttpHelper
/**
 * @brief 网络请求帮助类
 */
@interface HttpHelper : NSObject

//对每个请求默认添加的路径参数
@property (nonatomic, copy) NSDictionary* defaultParams;
//对每个请求默认添加的HttpHeader
@property (nonatomic, copy) NSDictionary* defaultHttpHeaderFields;

//请求并发数最大值(默认为5)
@property (nonatomic, assign) NSInteger maxRequestCount;

/**
 * @brief 网络请求帮助类
 * @brief 请在子类重写此方法设置请求头等
 * @return 网络请求帮助类
 */
+ (id)httpHelper;

/**
 * @brief 返回缓存的请求结果
 * @param path:请求URL
 * @param params:追加到URL上的参数
 * @return 缓存的请求结果
 */
- (id)loadDataCacheWithPath:(NSString *)path
                     params:(id)params;

/**
 * @brief 返回缓存的请求结果
 * @param request 一个网络请求
 * @return 缓存的请求结果
 */
- (id)loadDataCacheWithRequest:(HttpRequest *)request;

/**
 * @brief 提交一个请求
 * @brief 请在子类重写此方法设置额外请求参数
 * @param request 一个网络请求
 * @return 执行网络请求操作的Operation（可以直接使用它cancel掉操作）
 */
- (NSOperation *)submitRequest:(HttpRequest *)request;

/**
 * @brief 取消请求
 * @param string 需要取消的网络请求的path
 */
- (void)cancelRequestWithString:(NSString*)string;
- (void)cancelAllRequest;

/**
 * @brief 以字符串形式返回request的URL中的路径参数（也就是URL中？以后的部分）
 */
- (NSString *)parameterStringWithRequest:(HttpRequest *)request;

/**
 * @brief 以字典形式返回request的URL中的路径参数（也就是URL中？以后的部分）
 */
- (NSDictionary *)parameterDictionaryWithRequest:(HttpRequest *)request;

@end

#pragma mark - HttpDownloadHelper

@interface HttpDownloadHelper : HttpHelper

/**
 * @brief 网络请求帮助类
 * @brief 请在子类重写此方法设置请求头等
 * @return 网络请求帮助类
 */
+ (id)httpDownloadHelper;

@end

#pragma mark - HttpRequest
/**
 * @brief 单个网络请求
 * @brief 该类根据实际情况:继承或用类别扩展他网络请求的单个操作类
 */
@interface HttpRequest : NSObject

//网络请求的URL路径
@property (nonatomic, copy) NSString* path;
//网络请求的方法：“GET”or“POST”
@property (nonatomic, copy) NSString* method;
//网络请求的URL路径
@property (nonatomic, strong) NSMutableDictionary* params;
//网络请求的HttpHeader
@property (nonatomic, strong) NSMutableDictionary* httpHeaders;
//网络请求的HttpBody
@property (nonatomic, strong) NSMutableData* httpBody;
//网络请求的超时时间
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
//
@property (nonatomic, copy) NSString* savePath;

@property (nonatomic, assign) BOOL usingCache;              // 是否缓存网络请求得到的数据么, 默认为NO
@property (nonatomic, assign) BOOL ignoreCacheIfOnline;     // 如果有网就忽略换成, 默认NO


@property (nonatomic, assign) BOOL discardDuplication;      // 是否自动取消重复的网络请求(默认为NO)。当前的请求不发送
@property (nonatomic, assign) BOOL resend;                  // 是否自动取消重复的请求(默认为NO)然后再次发送.

//执行网络请求的真实的request
@property (nonatomic, strong) NSURLRequest* request;
//执行网络请求返回的response
@property (nonatomic, assign) NSHTTPURLResponse* response;

/**
 * @brief 创建GET请求对象，用于普通Http访问
 * @param path:请求URL
 * @return 请求对象实例
 */
+ (id)requestWithGetPath:(NSString *)path;

/**
 * @brief 创建GET请求对象，用于普通Http访问
 * @param path:请求URL
 * @param params:追加到URL上的参数
 * @return 请求对象实例
 */
+ (id)requestWithGetPath:(NSString *)path
                  params:(id)params;

/**
 * @brief 创建GET请求对象，用于Http下载文件
 * @param path:请求URL
 * @param params:追加到URL上的参数
 * @param savePath:下载文件的保存地址
 * @return 请求对象实例
 */
+ (id)requestWithGetPath:(NSString *)path
                  params:(id)params
                savePath:(NSString *)savePath;

/**
 * @brief 创建POST请求对象
 * @param path:请求URL
 * @param params:追加到URL上的参数
 * @param data:post的数据体（注意：如果是NSData类型，则将直接使用；如果是NSDictionary类型，则将自动转换为JSON数据格式）
 * @return 请求对象实例
 */
+ (id)requestWithPostPath:(NSString *)path
                   params:(id)params
                     data:(id)data;

/**
 * @brief 追加URL路径参数
 * @param params:追加到URL上的参数
 * @return self（为了函数调用的级连）
 */
- (id)addParams:(NSDictionary *)params;

/**
 * @brief 追加URL路径参数
 * @param param:追加到URL上的参数的值
 * @param key:追加到URL上的参数的键
 * @return self（为了函数调用的级连）
 */
- (id)addParam:(NSString *)param
           key:(NSString *)key;

/**
 * @brief 添加File（暂未实现）
 */
- (id)addFile:(NSString*)filePath
          key:(NSString *)key;

/**
 * @brief 添加Data（暂未实现）
 */
- (id)addData:(NSData *)data
          key:(NSString *)key;

/**
 * @brief 请求返回后的处理block
 * @param success:请求成功时的处理block
 * @param failure:请求失败时的处理block
 * @return self（为了函数调用的级连）
 */
- (id)success:(HttpRequestSuccessBlock)success
      failure:(HttpRequestFailureBlock)failure;

/**
 * @brief 请求返回后的处理block
 * @param progress:处理Http文件下载进度的block
 * @return self（为了函数调用的级连）
 */
- (id)progress:(HttpRequestProgressBlock)progress;

/**
 * @brief 发送请求
 * @param httpHelper:该请求通过哪一个HttpHelper实例进行发送
 * @return 执行网络请求操作的Operation（可以直接使用它cancel掉操作）
 */
- (NSOperation *)submitToHttpHelper:(HttpHelper *)httpHelper;

@end
