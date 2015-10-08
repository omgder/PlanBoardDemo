//
//  NSString+Extend.m
//  PlanBoardDemo
//
//  Created by OMGDER on 15/10/7.
//  Copyright © 2015年 OMGDER. All rights reserved.
//

#import "NSString+Extend.h"

@implementation NSString (Extend)


- (BOOL)isTelephone
{
    if (self == nil)
        return NO;
    
    //联通号码
    NSString *regex_Unicom = @"^(130|131|132|133|185|186|156|155)[0-9]{8}";
    //移动号码
    NSString *regex_CMCC = @"^(134|135|136|137|138|139|147|150|151|152|157|158|159|182|187|188)[0-9]{8}";
    //电信号码段(电信新增号段181)
    NSString *regex_Telecom = @"^(133|153|180|181|189)[0-9]{8}";
    
    NSPredicate *pred_Unicom = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex_Unicom];
    BOOL isMatch_Unicom = [pred_Unicom evaluateWithObject:self];
    
    NSPredicate *pred_CMCC = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex_CMCC];
    BOOL isMatch_CMCC = [pred_CMCC evaluateWithObject:self];
    
    NSPredicate *pred_Telecom = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex_Telecom];
    BOOL isMatch_Telecom = [pred_Telecom evaluateWithObject:self];
    
    if (isMatch_Unicom || isMatch_CMCC || isMatch_Telecom)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}




- (NSString *)URLEncodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(__bridge CFStringRef)self,NULL, CFSTR("%"), kCFStringEncodingUTF8));
    return result?:self;
}

@end
