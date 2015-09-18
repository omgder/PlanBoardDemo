//
//  RecordManager.m
//  PlanBoard2
//
//  Created by OMGDER on 15/9/16.
//  Copyright (c) 2015年 OMGDER. All rights reserved.
//

#import "RecordManager.h"


@implementation RecordManager


+ (instancetype)shareInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[RecordManager alloc] init];
        }
    });
    return instance;
}


- (void)recordView:(UIView *)view
{
    if(capture == nil){
        capture=[[THCapture alloc] init];
    }
    capture.frameRate = 30;
    capture.delegate = self;
    
    
    capture.captureLayer = view.layer;
    
    
    
    if (!audioRecord) {
        audioRecord = [[LZXAudioRecordAndTransCoding alloc]init];
        audioRecord.recorder.delegate =  self;
        audioRecord.delegate = self;
    }
    
    
    [capture performSelector:@selector(startRecording1)];
    
    NSString* path=[self getPathByFileName:VEDIOPATH ofType:@"wav"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]){
        [fileManager removeItemAtPath:path error:nil];
    }
    [self performSelector:@selector(toStartAudioRecord) withObject:nil afterDelay:0.1];
    
}

#pragma mark -
#pragma mark audioRecordDelegate
-(void)toStartAudioRecord
{
    [audioRecord beginRecordByFileName:VEDIOPATH];
}

-(void)wavComplete
{
    //视频录制结束,为视频加上音乐
    if (audioRecord) {
        NSString* path=[self getPathByFileName:VEDIOPATH ofType:@"wav"];
        
        NSLog(@"avdio = %@, vedio = %@",path,opPath);
        
        [THCaptureUtilities mergeVideo:opPath andAudio:path andTarget:self andAction:@selector(mergedidFinish:WithError:)];
    }
}


#pragma mark -
#pragma mark THCaptureDelegate
- (void)recordingFinished:(NSString*)outputPath
{
    opPath=outputPath;
    if (audioRecord) {
        [audioRecord endRecord];
    }
    //[self mergedidFinish:outputPath WithError:nil];
}

- (void)recordingFaild:(NSError *)error
{
}


#pragma mark -
#pragma mark CustomMethod

- (void)video: (NSString *)videoPath didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInfo{
    if (error) {
        NSLog(@"---%@",[error localizedDescription]);
    }
}

- (void)mergedidFinish:(NSString *)videoPath WithError:(NSError *)error
{
    NSDateFormatter* dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    NSString* currentDateStr=[dateFormatter stringFromDate:[NSDate date]];
    
    NSString* fileName=[NSString stringWithFormat:@"白板录制,%@.mov",currentDateStr];
    
    NSString* path=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",fileName]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:videoPath])
    {
        NSError *err=nil;
        [[NSFileManager defaultManager] moveItemAtPath:videoPath toPath:path error:&err];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"allVideoInfo"]) {
        NSMutableArray* allFileArr=[[NSMutableArray alloc] init];
        [allFileArr addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"allVideoInfo"]];
        [allFileArr insertObject:fileName atIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:allFileArr forKey:@"allVideoInfo"];
    }
    else{
        NSMutableArray* allFileArr=[[NSMutableArray alloc] init];
        [allFileArr addObject:fileName];
        [[NSUserDefaults standardUserDefaults] setObject:allFileArr forKey:@"allVideoInfo"];
    }
    
    //音频与视频合并结束，存入相册中
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
        UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
    }
}


- (void)stopRecord
{
    
    [capture performSelector:@selector(stopRecording)];
}

- (NSString*)getPathByFileName:(NSString *)_fileName ofType:(NSString *)_type
{
    NSString* fileDirectory = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:_fileName]stringByAppendingPathExtension:_type];
    return fileDirectory;
}

@end
