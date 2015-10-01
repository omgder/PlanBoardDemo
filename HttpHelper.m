//
//  HttpHelper.m
//  iThunder
//
//  Created by Heaven on 14-9-10.
//  Copyright (c) 2014年 xunlei.com. All rights reserved.
//

#import "HttpHelper.h"
#import "AFNetworking.h"
#import "XYQuick.h"
#import "HttpHelper+AFNetworking.h"
#import "AFDownloadRequestOperation.h"
#import <XLReachabilityHelper.h>

#define HttpRequestDefaultTimeOutForGet 15.0
#define HttpRequestDefaultTimeOutForPost 30.0
#define HttpHelperDefaultMaxRequestCountWiFi 5
#define HttpHelperDefaultMaxRequestCountWWAN 2

@class XLHTTPResponseSerializer;

#pragma mark - Class HttpRequest

@interface HttpRequest ()

@property (nonatomic, copy) HttpRequestSuccessBlock success;
@property (nonatomic, copy) HttpRequestFailureBlock failure;
@property (nonatomic, copy) HttpRequestProgressBlock progress;

- (void)cleanup;
- (NSURL *)urlWithPath:(NSString *)path params:(NSDictionary *)params;

@end


@implementation HttpRequest

#pragma mark - Private Function

- (NSDictionary *)dictionaryWithObject:(id)object
{
    //集中在此处理数据类型转换的问题
    if(object != nil)
    {
        if([object isKindOfClass:[NSDictionary class]])
        {
            return object;
        }
    }
    return @{};
}


- (NSData *)dataWithObject:(id)object
{
    //集中在此处理数据类型转换的问题
    if(object != nil)
    {
        if([object isKindOfClass:[NSData class]])
        {
            return object;
        }
        if([object isKindOfClass:[NSDictionary class]])
        {
            NSError* error;
            return [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
        }
    }
    return [NSData data];
}


- (NSURL *)urlWithPath:(NSString *)path params:(NSDictionary *)params
{
    if((path == nil) || (path.length == 0))
    {
        return nil;
    }
    
    //借用一下AFNetworking里现成的方法
    NSString* urlString = ((params.count == 0) ? path : ([path stringByAppendingFormat:[path rangeOfString:@"?"].location == NSNotFound ? @"?%@" : @"&%@", AFQueryStringFromParametersWithEncoding(params, NSUTF8StringEncoding)]));
    
    //检查一下URL是否符合规范，不合要求的要进行URL编码
    NSURL* url = [NSURL URLWithString:urlString];
    if(url == nil)
    {
        url = [NSURL URLWithString:[urlString URLEncodedString]];
    }
    
    return url;
}


- (void)cleanup
{
    //此函数中清理必要的强持有对象，打破引用循环
    self.success = nil;
    self.failure = nil;
    self.request = nil;
    self.response = nil;
    self.progress = nil;
}


+ (id)requestWithPath:(NSString *)path params:(id)params
{
    HttpRequest* request = [[HttpRequest alloc] init];
    request.path = path;
    request.params = [NSMutableDictionary dictionaryWithDictionary:[request dictionaryWithObject:params]];
    request.httpHeaders = [NSMutableDictionary dictionaryWithCapacity:3];
    return request;
}

#pragma mark - Public Function

+ (id)requestWithGetPath:(NSString *)path
{
    HttpRequest* request = [HttpRequest requestWithPath:path params:nil];
    request.method = @"GET";
    request.timeoutInterval = HttpRequestDefaultTimeOutForGet;
    return request;
}


+ (id)requestWithGetPath:(NSString *)path params:(id)params
{
    HttpRequest* request = [HttpRequest requestWithPath:path params:params];
    request.method = @"GET";
    request.timeoutInterval = HttpRequestDefaultTimeOutForGet;
    return request;
}


+ (id)requestWithGetPath:(NSString *)path params:(id)params savePath:(NSString *)savePath
{
    HttpRequest* request = [HttpRequest requestWithPath:path params:params];
    request.method = @"GET";
    request.savePath = savePath;
    request.timeoutInterval = HttpRequestDefaultTimeOutForGet;
    return request;
}


+ (id)requestWithPostPath:(NSString *)path params:(id)params data:(id)data
{
    HttpRequest* request = [HttpRequest requestWithPath:path params:params];
    request.method = @"POST";
    request.httpBody = [NSMutableData dataWithData:[request dataWithObject:data]];
    request.timeoutInterval = HttpRequestDefaultTimeOutForPost;
    return request;
}


- (id)addParams:(NSDictionary *)params
{
    if((params != nil) && (params.count > 0))
    {
        [self.params addEntriesFromDictionary:params];
        //[self setURL:[self urlWithPath:self.path params:self.params]];
    }
    return self;
}


- (id)addParam:(NSString *)param key:(NSString *)key
{
    if((key != nil) && (param != nil))
    {
        [self.params setObject:param forKey:key];
        //[self setURL:[self urlWithPath:self.path params:self.params]];
    }
    return self;
}


- (id)addData:(NSData *)data key:(NSString *)key
{
    //TODO:addDate:key:
    return self;
}


- (id)addFile:(NSString*)filePath key:(NSString *)key
{
    //TODO:addFile:key:
    return self;
}


- (id)success:(HttpRequestSuccessBlock)success failure:(HttpRequestFailureBlock)failure
{
    self.success = success;
    self.failure = failure;
    return self;
}


- (id)progress:(HttpRequestProgressBlock)progress
{
    self.progress = progress;
    return self;
}


- (NSOperation *)submitToHttpHelper:(HttpHelper *)httpHelper
{
    if(httpHelper != nil)
    {
        return [httpHelper submitRequest:self];
    }
    return nil;
}

@end


#pragma mark - Class HttpHelper

@interface HttpHelper ()

@property (nonatomic, strong) AFHTTPRequestOperationManager* httpManager;
@property (nonatomic, strong) XYFileCache* fileCache;
@property (nonatomic, strong) NSMutableDictionary* queryingRequests;

@end


@implementation HttpHelper

#pragma mark - Private Function

- (id)init
{
    if(self = [super init])
    {
        //(1)首先初始化AFNetworking
        self.httpManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        //AF2.x版本全面重构了以前的代码，Http请求完成后，会自动使用ResponseSerializer将原始的NSData类型的responseObject解析成其它的对象，然而我们不希望AF替我们多做这一步多余的工作，于是就写了一个空的ResponseSerializer
        self.httpManager.responseSerializer = [XLHTTPResponseSerializer serializer];
        //下面的设置是为了能正常发起https请求，不然会因为安全问题，AF主动断开https的请求操作并失败返回。请确保self.httpManager.securityPolicy使用的是[AFSecurityPolicy defaultPolicy]，此时，下面的设置才能生效
        self.httpManager.securityPolicy.allowInvalidCertificates = YES;
        
        //(2)下面都是与AF无关的初始化操作
        self.fileCache = [[XYFileCache alloc] initWithNamespace:@"httpCache"];
        self.fileCache.maxCacheAge = 7 * 24 * 60 * 60;
        self.queryingRequests = [NSMutableDictionary dictionary];
        [self initSetting];
        [[XLReachabilityHelper sharedInstance] addNetworkObserverWithTarget:self selector:@selector(onNetworkStatusChanged) withObject:nil];
    }
    return self;
}


- (void)dealloc
{
    [[XLReachabilityHelper sharedInstance] removeNetworkObserver:self];
}


- (void)initSetting
{
    //在此函数中做所有的配置性工作
    self.defaultParams = nil;
    self.defaultHttpHeaderFields = nil;
    self.maxRequestCount = HttpHelperDefaultMaxRequestCountWiFi;
    [self onNetworkStatusChanged];
}


- (void)onNetworkStatusChanged
{
    //此函数监控网络状态的改变，调整并发请求数
    EnumXLNetworkStatus status = [XLReachabilityHelper sharedInstance].currentReachabilityStatus;
    if(status == kXLReachableViaWiFi)
    {
        [self.httpManager.operationQueue setMaxConcurrentOperationCount:MIN(self.maxRequestCount, HttpHelperDefaultMaxRequestCountWiFi)];
    }
    else if(status == kXLReachableViaWWAN)
    {
        [self.httpManager.operationQueue setMaxConcurrentOperationCount:MIN(self.maxRequestCount, HttpHelperDefaultMaxRequestCountWWAN)];
    }
    else //(status == kXLNotReachable)
    {
        [self cancelAllRequest];
    }
}


- (NSURLRequest *)URLRequestWithHttpRequest:(HttpRequest *)httpRequest
{
    NSURL* url = [httpRequest urlWithPath:httpRequest.path params:httpRequest.params];
    if(url == nil)
    {
        return nil;
    }
    
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    urlRequest.HTTPMethod = httpRequest.method;
    urlRequest.timeoutInterval = httpRequest.timeoutInterval;
    urlRequest.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    if(httpRequest.httpBody != nil)
    {
        urlRequest.HTTPBody = httpRequest.httpBody;
    }
    urlRequest.allHTTPHeaderFields = httpRequest.httpHeaders;
    return urlRequest;
}


- (BOOL)preprocessRequest:(HttpRequest *)httpRequest
{
    //在此函数中做所有的发送请求前的额外工作
    if(httpRequest == nil)
    {
        return NO;
    }
    
    if([httpRequest.params isKindOfClass:[NSMutableDictionary class]])
    {
        NSLog(@"");
    }
    
    //(1)设置默认的路径参数和HttpHeader
    [httpRequest.params addEntriesFromDictionary:self.defaultParams];
    [httpRequest.httpHeaders addEntriesFromDictionary:self.defaultHttpHeaderFields];
    //(2)根据我们自己的HttpRequest对象，构造一个系统原生的NSURLRequest对象
    NSURLRequest* urlRequest = [self URLRequestWithHttpRequest:httpRequest];
    if(urlRequest.URL == nil)
    {
        return NO;
    }
    
    //(3)进一步转换为AFNetworking用的NSURLRequest对象
    NSError* error = nil;
    urlRequest = [self.httpManager.requestSerializer requestBySerializingRequest:urlRequest withParameters:nil error:&error];
    if(error != nil)
    {
        return NO;
    }
    
    //(4)检查是否是重复的网络请求，如有需要，取消本次的请求发送
    if(httpRequest.discardDuplication && (self.queryingRequests[urlRequest.URL.absoluteString] != nil))
    {
        return NO;
    }
    
    // (5)检查是否是重复的网络请求，如有需要，取消之前的请求
    if (httpRequest.resend && (self.queryingRequests[urlRequest.URL.absoluteString] != nil))
    {
        [self cancelRequestWithString:urlRequest.URL.absoluteString];
        // 下面有个加入queryingRequests的操作, 但是这里先返回了, 如果后面要改的话, 请注意
        return YES;
    }
    
    // (6)将请求标记到正在发送队列中
    httpRequest.request = urlRequest;
    [self.queryingRequests setObject:@"" forKey:urlRequest.URL.absoluteString];
    
    return YES;
}


- (void)postprocessRequest:(HttpRequest *)httpRequest
{
    //在此函数中做所有的请求处理完毕后的额外工作
    if(httpRequest != nil)
    {
        if ([httpRequest isKindOfClass:[HttpRequest class]])
        {
            [self.queryingRequests removeObjectForKey:httpRequest.request.URL.absoluteString];
            [httpRequest cleanup];
        }
    }
}

#pragma mark - Public Function

+ (id)httpHelper
{
    HttpHelper* helper = [[HttpHelper alloc] init];
    return helper;
}

- (id)loadDataCacheWithPath:(NSString *)path
                     params:(id)params;
{
    HttpRequest *request = [HttpRequest requestWithPath:path params:params];
    
    return [self loadDataCacheWithRequest:request];
}


- (id)loadDataCacheWithRequest:(HttpRequest *)httpRequest
{
    return [self.fileCache objectForKey:[httpRequest.request.URL.absoluteString uxy_MD5String]];
}


- (void)saveDataCache:(NSData*)data withRequest:(HttpRequest *)httpRequest
{
    NSString *key = [httpRequest.request.URL.absoluteString uxy_MD5String];
    if (key == nil)
        return;
    dispatch_async_background_writeFile(^{
        [self.fileCache setObject:data forKey:key];
    });
}


- (NSOperation *)submitRequest:(HttpRequest *)httpRequest
{
    //(1)对请求的预处理（主要是添加默认的路径参数和HttpHeader）
    if([self preprocessRequest:httpRequest] == NO)
    {
        return nil;
    }
    
    //(2)如有需要，先返回以前缓存的数据
    if(httpRequest.usingCache && !httpRequest.ignoreCacheIfOnline && (httpRequest.success != nil))
    {
        NSData* cachedObject = [self loadDataCacheWithRequest:httpRequest];
        if(cachedObject != nil)
        {
            httpRequest.success(httpRequest, nil, cachedObject, YES);
        }
    }
    
    //(3)创建Operation，指定返回时的操作（注意，执行完操作后，要将block置空，打破循环引用）
    AFHTTPRequestOperation *operation = [self.httpManager HTTPRequestOperationWithRequest:httpRequest.request success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        httpRequest.response = operation.response;
        if(httpRequest.success)
        {
            httpRequest.success(httpRequest, nil, responseObject, NO);
        }
        //对于成功的返回，如有需要，将数据缓存到文件
        if(httpRequest.usingCache && (operation.response.statusCode == 200))
        {
            [self saveDataCache:responseObject withRequest:httpRequest];
        }
        [self postprocessRequest:httpRequest];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        httpRequest.response = operation.response;
        if(httpRequest.failure)
        {
            httpRequest.failure(httpRequest, error);
        }
        [self postprocessRequest:httpRequest];
    }];
    
    //(4)准备发起请求
    [self.httpManager.operationQueue addOperation:operation];
    return operation;
}


- (void)cancelRequestWithString:(NSString *)string
{
    //URL中包含参数字符串的网络请求统统取消掉
    NSString* urlString = nil;
    for(AFHTTPRequestOperation *operation in [self.httpManager.operationQueue operations])
    {
        if([operation isKindOfClass:[AFHTTPRequestOperation class]])
        {
            urlString = operation.request.URL.absoluteString;
            if([urlString rangeOfString:string].location != NSNotFound)
            {
                [operation cancel];
                [self postprocessRequest:(HttpRequest*)operation.request];
            }
        }
    }
}


- (void)cancelAllRequest
{
    for(AFHTTPRequestOperation *operation in [self.httpManager.operationQueue operations])
    {
        if([operation isKindOfClass:[AFHTTPRequestOperation class]])
        {
            [operation cancel];
            [self postprocessRequest:(HttpRequest*)operation.request];
        }
    }
}


- (NSString *)parameterStringWithRequest:(HttpRequest *)request
{
    NSDictionary* paramDict = [self parameterDictionaryWithRequest:request];
    if(paramDict == nil)
    {
        return nil;
    }
    
    NSURL* url = [request urlWithPath:request.path params:paramDict];
    if(url == nil)
    {
        return nil;
    }
    
    return [url parameterString];
}


- (NSDictionary *)parameterDictionaryWithRequest:(HttpRequest *)request
{
    if(request == nil)
    {
        return nil;
    }
        
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithDictionary:request.params];
    [param addEntriesFromDictionary:self.defaultParams];
    return param;
}

@end


#pragma mark - Class HttpDownloadHelper

@implementation HttpDownloadHelper

+ (id)httpDownloadHelper
{
    HttpDownloadHelper* helper = [[HttpDownloadHelper alloc] init];
    return helper;
}


- (NSOperation *)submitRequest:(HttpRequest *)httpRequest
{
    //(1)对于savePath为空的请求，仍采用HttpHelper的方法
    if((httpRequest.savePath == nil) || (httpRequest.savePath.length == 0))
    {
        return [super submitRequest:httpRequest];
    }
    
    //(2)对请求的预处理（主要是添加默认的路径参数和HttpHeader）
    if([self preprocessRequest:httpRequest] == NO)
    {
        return nil;
    }
    
    //(3)创建Operation，指定下载和完成时的操作（注意，执行完操作后，要将block置空，打破循环引用）
    AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:httpRequest.request targetPath:httpRequest.savePath shouldResume:YES];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        httpRequest.response = operation.response;
        if(httpRequest.success)
        {
            httpRequest.success(httpRequest, nil, responseObject, NO);
        }
        [self postprocessRequest:httpRequest];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        httpRequest.response = operation.response;
        if(httpRequest.failure)
        {
            httpRequest.failure(httpRequest, error);
        }
        [self postprocessRequest:httpRequest];
    }];
    
    [operation setProgressiveDownloadProgressBlock:^(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile)
    {
        if(httpRequest.progress)
        {
            httpRequest.progress(httpRequest, bytesRead, totalBytesRead, totalBytesExpected, totalBytesReadForFile, totalBytesExpectedToReadForFile);
        }
    }];
    
    //(4)准备发起请求
    [self.httpManager.operationQueue addOperation:operation];
    return operation;
}

@end
