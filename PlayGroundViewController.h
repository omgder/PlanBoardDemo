//
//  PlayGroundViewController.h
//  PlanBoard2
//
//  Created by OMGDER on 15/9/13.
//  Copyright (c) 2015年 OMGDER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THCapture.h"
#import "LZXAudioRecordAndTransCoding.h"
#import "HMSideMenu.h"
#import "ACEDrawingView.h"
@class RCDraggableButton;

@interface PlayGroundViewController : UIViewController <ACEDrawingViewDelegate>

@property (strong, nonatomic) HMSideMenu *rightSideMenu;
@property (strong, nonatomic) HMSideMenu *leftSideMenu;

@end
