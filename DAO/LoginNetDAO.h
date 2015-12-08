//
//  LoginNetDAO.h
//  PlanBoardDemo
//
//  Created by OMGDER on 15/10/9.
//  Copyright © 2015年 OMGDER. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RegistResultBlock)(id dao, NSDictionary *result, NSError *error);

@interface LoginNetDAO : NSObject


+ (instancetype)dao;
- (void)registRequestWithInfo:(NSDictionary *)registInfo completion:(RegistResultBlock)completion;


@end
