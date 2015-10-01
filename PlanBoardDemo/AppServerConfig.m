//
//  AppServerConfig.m
//  PlanBoardDemo
//
//  Created by OMGDER on 15/10/1.
//  Copyright © 2015年 OMGDER. All rights reserved.
//

#import "AppServerConfig.h"

@implementation AppServerConfig

- (id)init
{
    if (self =[super init])
    {
        
    }
    return self;
}


- (void)loadServerConfigs
{
    self.registServerAddress = kRegistServerAddress;
    self.loginServerAddress  = kLoginServerAddress;
}

@end
