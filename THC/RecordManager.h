//
//  RecordManager.h
//  PlanBoard2
//
//  Created by OMGDER on 15/9/16.
//  Copyright (c) 2015年 OMGDER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THCapture.h"
#import "LZXAudioRecordAndTransCoding.h"

#define VEDIOPATH @"vedioPath"

@interface RecordManager : NSObject <THCaptureDelegate,AVAudioRecorderDelegate,LZXAudioRecordAndTransCodingDelegate>
{
    THCapture *capture;
    LZXAudioRecordAndTransCoding *audioRecord;
    NSString *opPath;
}


+ (instancetype)shareInstance;
- (void)recordView:(UIView *)view;

- (void)stopRecord;
@end
