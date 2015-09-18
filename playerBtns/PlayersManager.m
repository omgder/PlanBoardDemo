//
//  PlayersManager.m
//  PlanBoard
//
//  Created by OMGDER on 15/9/4.
//  Copyright (c) 2015年 OMGDER. All rights reserved.
//
#import  <UIKit/UIKit.h>
#import "PlayersManager.h"
#import "RCDraggableButton.h"

@implementation PlayersManager



#pragma mark -- ourTeam Edit

- (id)init
{
    if (self = [super init]) {
        _ourTeam = [@[] mutableCopy];
        _againstTeam = [@[] mutableCopy];
    }
    return self;
}


- (void)loadOurAvatarInCustomView: (UIView *)playGroundView
{
    if (_ourTeam.count > 11) {
        return;
    }
    
    RCDraggableButton *avatar = [[RCDraggableButton alloc] initInView:playGroundView WithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 60 - 44 , playGroundView.bounds.size.height - 50, 44, 44)];
    [avatar setBackgroundImage:[UIImage imageNamed:@"redShirt"] forState:UIControlStateNormal];
    [avatar setBackgroundColor:[UIColor clearColor]];
    avatar.layer.borderWidth = 0.f;
    
    [avatar setAutoDocking:NO];
    
    avatar.longPressBlock = ^(RCDraggableButton *avatar) {
        NSLog(@"\n\tAvatar in customView ===  LongPress!!! ===");
        //More todo here.
        
    };
    
    avatar.tapBlock = ^(RCDraggableButton *avatar) {
        NSLog(@"\n\tAvatar in customView ===  Tap!!! ===");
        //More todo here.
        
    };
    
    avatar.draggingBlock = ^(RCDraggableButton *avatar) {
        NSLog(@"\n\tAvatar in customView === Dragging!!! ===");
        //More todo here.
        
    };
    
    avatar.dragDoneBlock = ^(RCDraggableButton *avatar) {
        NSLog(@"\n\tAvatar in customView === DragDone!!! ===");
        //More todo here.
        
    };
    
    avatar.autoDockingBlock = ^(RCDraggableButton *avatar) {
        NSLog(@"\n\tAvatar in customView === AutoDocking!!! ===");
        //More todo here.
        
    };
    
    avatar.autoDockingDoneBlock = ^(RCDraggableButton *avatar) {
        NSLog(@"\n\tAvatar in customView === AutoDockingDone!!! ===");
        //More todo here.
        
    };
    
    [_ourTeam addObject:avatar];
    
}


- (void)removeOneTeamMate
{
    if (_ourTeam) {
        
        [[_ourTeam lastObject] removeFromSuperview];
        [_ourTeam removeLastObject];
    }
}

#pragma mark -- againstTeam Edit

- (void)loadAgainstAvatarInCustomView: (UIView *)playGroundView
{
    if (_againstTeam.count > 11) {
        return;
    }
    
    RCDraggableButton *avatar = [[RCDraggableButton alloc] initInView:playGroundView WithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 + 60 , playGroundView.bounds.size.height - 50, 44, 44)];
    [avatar setBackgroundImage:[UIImage imageNamed:@"blueShirt"] forState:UIControlStateNormal];
    [avatar setBackgroundColor:[UIColor clearColor]];
    avatar.layer.borderWidth = 0.f;
    
    [avatar setAutoDocking:NO];
    
    avatar.longPressBlock = ^(RCDraggableButton *avatar) {
        NSLog(@"\n\tAvatar in customView ===  LongPress!!! ===");
        //More todo here.
        
    };
    
    avatar.tapBlock = ^(RCDraggableButton *avatar) {
        NSLog(@"\n\tAvatar in customView ===  Tap!!! ===");
        //More todo here.
        
    };
    
    avatar.draggingBlock = ^(RCDraggableButton *avatar) {
        NSLog(@"\n\tAvatar in customView === Dragging!!! ===");
        //More todo here.
        
    };
    
    avatar.dragDoneBlock = ^(RCDraggableButton *avatar) {
        NSLog(@"\n\tAvatar in customView === DragDone!!! ===");
        //More todo here.
        
    };
    
    avatar.autoDockingBlock = ^(RCDraggableButton *avatar) {
        NSLog(@"\n\tAvatar in customView === AutoDocking!!! ===");
        //More todo here.
        
    };
    
    avatar.autoDockingDoneBlock = ^(RCDraggableButton *avatar) {
        NSLog(@"\n\tAvatar in customView === AutoDockingDone!!! ===");
        //More todo here.
        
    };
    
    [_againstTeam addObject:avatar];
}

- (void)removeOneAgainst
{
    if (_againstTeam)
    {
        [[_againstTeam lastObject] removeFromSuperview];
        [_againstTeam removeLastObject];
    }
}
//

- (void)removeAllPlayers:(UIView *)view
{
    [RCDraggableButton removeAllFromView:view];
}

- (void)removePlayer:(RCDraggableButton *)player
{
    [RCDraggableButton removeRCDBtn:player];
}


- (void)addFootball:(UIView *)playGroundView
{
    self.football = [[RCDraggableButton alloc] initInView:playGroundView WithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width /  2 - 10  , playGroundView.bounds.size.height / 2 - 10, 20, 20)];
    [self.football setBackgroundImage:[UIImage imageNamed:@"icon_football"] forState:UIControlStateNormal];
    [self.football setBackgroundColor:[UIColor clearColor]];
    self.football.layer.borderWidth = 0.f;
    
    [self.football setAutoDocking:NO];
    
    self.football.longPressBlock = ^(RCDraggableButton *avatar) {
        NSLog(@"\n\tAvatar in customView ===  LongPress!!! ===");
        //More todo here.
        
    };
    
    self.football.tapBlock = ^(RCDraggableButton *avatar) {
        NSLog(@"\n\tAvatar in customView ===  Tap!!! ===");
        //More todo here.
        
    };
    
    self.football.draggingBlock = ^(RCDraggableButton *avatar) {
        NSLog(@"\n\tAvatar in customView === Dragging!!! ===");
        //More todo here.
        
    };
    
    self.football.dragDoneBlock = ^(RCDraggableButton *avatar) {
        NSLog(@"\n\tAvatar in customView === DragDone!!! ===");
        //More todo here.
        
    };
    
    self.football.autoDockingBlock = ^(RCDraggableButton *avatar) {
        NSLog(@"\n\tAvatar in customView === AutoDocking!!! ===");
        //More todo here.
        
    };
    
    self.football.autoDockingDoneBlock = ^(RCDraggableButton *avatar) {
        NSLog(@"\n\tAvatar in customView === AutoDockingDone!!! ===");
        //More todo here.
    };
}

@end
