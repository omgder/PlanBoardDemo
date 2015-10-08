//
//  CALayer+ColorFromUIColor.m
//  PlanBoardDemo
//
//  Created by OMGDER on 15/10/6.
//  Copyright © 2015年 OMGDER. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CALayer+ColorFromUIColor.h"

@implementation CALayer (colorFromUIColor)
- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}

@end
