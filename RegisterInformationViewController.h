//
//  RegisterInformationViewController.h
//  PlanBoardDemo
//
//  Created by OMGDER on 15/10/5.
//  Copyright © 2015年 OMGDER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterInformationViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate>


@property (weak, nonatomic) IBOutlet UIButton *headerIconBtn;


@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;

@property (weak, nonatomic) IBOutlet UIButton *getVerifyCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *secretCodeTextField;

@property (weak, nonatomic) IBOutlet UIButton *registInfoConfirmBtn;



- (void)setUserHeadIconWithImage:(UIImage *)image;



- (IBAction)uploadUserImage:(id)sender;
- (IBAction)reGetVerifyCode:(id)sender;
- (IBAction)confirmRegistInfo:(id)sender;



@end
