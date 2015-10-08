//
//  XLReachabilityHelper.h
//  iThunder
//
//  Created by wihing on 12-9-14.
//  Copyright (c) 2012年 czh0766. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	kXLNotReachable = 0,
	kXLReachableViaWiFi,
	kXLReachableViaWWAN
} EnumXLNetworkStatus;

@interface XLReachabilityHelper : NSObject

+ (XLReachabilityHelper *)sharedInstance;

- (void)addNetworkObserverWithTarget:(id)target selector:(SEL)selector withObject:(id)object;
- (void)removeNetworkObserver:(id)observer;

- (EnumXLNetworkStatus) currentReachabilityStatus;
- (NSString *) currentReachabilityType;

@end
