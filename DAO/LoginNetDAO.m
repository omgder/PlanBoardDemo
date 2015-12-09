//
//  LoginNetDAO.m
//  PlanBoardDemo
//
//  Created by OMGDER on 15/10/9.
//  Copyright © 2015年 OMGDER. All rights reserved.
//

#import "LoginNetDAO.h"
#import "HttpHelper.h"
#import "XYJsonHelper.h"
#import "XLHttpHelper.h"

#define kRegisterAddress @"http://119.29.89.117/goal/iface/doreg.json"





@implementation LoginNetDAO

+ (instancetype)dao
{
    return [[LoginNetDAO alloc] init];
}

- (void)registRequestWithInfo:(NSDictionary *)registInfo completion:(RegistResultBlock)completion
{
    NSString *url = @"http://119.29.89.117/goal/iface/doreg.json";
    //要传dic不然要崩溃
   
    HttpRequest* request = [HttpRequest requestWithPostPath:url params:registInfo data:registInfo];
    
    [[request success:^(id request, NSError *error, id responseObject, BOOL isCache)
    {
        NSDictionary *resultDic = [responseObject uxy_jsonValue];
        if (completion)
        {
            completion(self, resultDic ,error);
        }
        
    } failure:^(id request, NSError *error)
    {
        if (completion)
        {
            completion(self, nil ,error);
        }
        
    }] submitToHttpHelper:[XLHttpHelper sharedHelper]];
    
    
}



@end
