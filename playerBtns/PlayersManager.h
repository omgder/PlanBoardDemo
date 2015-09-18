//
//  PlayersManager.h
//  PlanBoard
//
//  Created by OMGDER on 15/9/4.
//  Copyright (c) 2015年 OMGDER. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RCDraggableButton;
@interface PlayersManager : NSObject
{
    NSMutableArray *_ourTeam;
    NSMutableArray *_againstTeam;
}

@property (strong, nonatomic) RCDraggableButton *football;


//添加一个队友到球场；

- (void)addFootball:(UIView *)playGroundView;


- (void)loadOurAvatarInCustomView: (UIView *)playGroundView;


- (void)removeOneTeamMate;


//添加一个对手到球场
- (void)loadAgainstAvatarInCustomView: (UIView *)playGroundView;


- (void)removeOneAgainst;

//清空球场
- (void)removeAllPlayers:(UIView *)view;


//移除一个球员
- (void)removePlayer:(RCDraggableButton *)player;


@end
