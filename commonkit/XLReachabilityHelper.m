//
//  XLReachabilityHelper.m
//  iThunder
//
//  Created by wihing on 12-9-14.
//  Copyright (c) 2012年 czh0766. All rights reserved.
//

#import "XLReachabilityHelper.h"
#import "Reachability.h"

@interface ReachabilityObserver : NSObject

@property (weak, nonatomic) id target;
@property (assign, nonatomic) SEL selector;
@property (weak, nonatomic) id object;

@end

@implementation ReachabilityObserver
@end

@interface XLReachabilityHelper ()

@property (strong, nonatomic) Reachability* internetReach;
@property (strong, nonatomic) NSMutableArray *observers;

@end

@implementation XLReachabilityHelper

+ (XLReachabilityHelper *)sharedInstance
{
    static XLReachabilityHelper *helper;
    @synchronized ([XLReachabilityHelper class]) {
        if (helper == nil) {
            helper = [[XLReachabilityHelper alloc] init];
        }
    }
    return helper;
}

- (EnumXLNetworkStatus) currentReachabilityStatus
{
    return (EnumXLNetworkStatus)[_internetReach currentReachabilityStatus];
}

- (NSString *) currentReachabilityType
{
    EnumXLNetworkStatus currentNetStatus = [self currentReachabilityStatus];
    NSString *netType = @"";
    switch (currentNetStatus) {
        case kXLReachableViaWiFi:
            netType = @"Wi-Fi";
            break;
        case kXLReachableViaWWAN:
            netType = @"3G";
            break;
        default:
            netType = @"Unknown";
            break;
    }
    return netType;
}

- (void)addNetworkObserverWithTarget:(id)target selector:(SEL)selector withObject:(id)object
{
    ReachabilityObserver *observer = [[ReachabilityObserver alloc] init];
    observer.target = target;
    observer.selector = selector;
    observer.object = object;
    [self.observers addObject:observer];
}

- (void)removeNetworkObserver:(id)observer
{
    NSMutableArray* arr = [NSMutableArray array];
    for (ReachabilityObserver *reachiabilityObserver in self.observers)
    {
        if (reachiabilityObserver.target == observer)
        {
            [arr addObject:reachiabilityObserver];
        }
    }
    [self.observers removeObjectsInArray:arr];
}

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
        _internetReach = [Reachability reachabilityForInternetConnection];
        [_internetReach startNotifier];
        _observers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) reachabilityChanged: (NSNotification* )note
{
    //线程不安全，加强安全
    @synchronized(self)
    {
        Reachability* curReach = [note object];
        NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
        NSArray *observers = [NSArray arrayWithArray:self.observers];
        for (ReachabilityObserver *observer in observers) {
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            if (observer.target && [observer.target respondsToSelector:observer.selector])
                [observer.target performSelector:observer.selector withObject:observer.object];
#pragma clang diagnostic pop
        }
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:kReachabilityChangedNotification];
}
@end