//
//  RegistInfoEntity.h
//  PlanBoardDemo
//
//  Created by OMGDER on 15/10/11.
//  Copyright © 2015年 OMGDER. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegistInfoEntity : NSObject


@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) NSString *verifyCode;
@property (nonatomic, copy) NSString *passWord;
@property (nonatomic, strong) NSData *headerImageData;

@end
