//
//  ModuleRouter.m
//  PlanBoardDemo
//
//  Created by OMGDER on 15/10/3.
//  Copyright © 2015年 OMGDER. All rights reserved.
//

#import "ModuleRouter.h"
#import "PlayGroundViewController.h"


@implementation ModuleRouter

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id singleton;
    dispatch_once( &once, ^{ singleton = [[self alloc] init]; } );
    return singleton;
}

- (void)jumpToMatchListViewControllerFromSource:(UIViewController *)source
{
    UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"PlanBoardStoryBoard" bundle:nil];
    [source presentViewController:[mainBoard instantiateViewControllerWithIdentifier:@"rootTab"] animated:YES completion:nil];
}

@end
