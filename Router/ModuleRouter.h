//
//  ModuleRouter.h
//  PlanBoardDemo
//
//  Created by OMGDER on 15/10/3.
//  Copyright © 2015年 OMGDER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ModuleRouter : NSObject

+ (instancetype)sharedInstance;

- (void)jumpToMatchListViewControllerFromSource:(UIViewController *)source;


@end
