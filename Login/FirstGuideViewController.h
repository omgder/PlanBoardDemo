//
//  FirstGuideViewController.h
//  PlanBoardDemo
//
//  Created by OMGDER on 15/10/3.
//  Copyright © 2015年 OMGDER. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface FirstGuideViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *playView;

@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;

@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;



- (void)startPlay;
- (void)stopPlay;

@end
