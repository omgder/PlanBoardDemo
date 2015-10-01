//
//  AppServerConfig.h
//  PlanBoardDemo
//
//  Created by OMGDER on 15/10/1.
//  Copyright © 2015年 OMGDER. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kRegistServerAddress @"http://119.29.89.117/goal/iface/doreg.json"
#define kLoginServerAddress  @"http://119.29.89.117/goal/iface/dologin.json"


@interface AppServerConfig : NSObject

@property (nonatomic, copy)NSString *registServerAddress;
@property (nonatomic, copy)NSString *loginServerAddress;



- (void)loadServerConfigs;

@end
