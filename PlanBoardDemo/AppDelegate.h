//
//  AppDelegate.h
//  PlanBoardDemo
//
//  Created by OMGDER on 15/9/17.
//  Copyright (c) 2015年 OMGDER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobClick.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *firstGuideNavigationController;

@property (strong, nonatomic) UINavigationController *homepageNavigationViewController;
@property (strong, nonatomic) UINavigationController * playGroundNavigationController;
@property (strong, nonatomic) UINavigationController * teamNavigationController;
@property (strong, nonatomic) UINavigationController * personCenterNavigationController;

@end

