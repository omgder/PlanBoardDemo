//
//  RegisterInformationViewController.h
//  PlanBoardDemo
//
//  Created by OMGDER on 15/10/5.
//  Copyright © 2015年 OMGDER. All rights reserved.
//

/**
 *  注册类，负责注册信息的校验 和上报
 *
 *  @param copy
 *  @param nonatomic
 *
 *  @return
 */


#import <UIKit/UIKit.h>



@interface RegisterInformationViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate>
/**
 *  上报的字段
 */

@property (copy, nonatomic) NSString *number;
@property (copy, nonatomic) NSString *nickName;
@property (copy, nonatomic) NSString *verfiyCode;
@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString *email;
@property (strong, nonatomic) NSData *headerImageData;

/**
 *  IBOutlet
 */

@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *headerIconBtn;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getVerifyCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *secretCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *registInfoConfirmBtn;


/**
 *  content view的约束需要动态改变，因为scrollview不能设置autolayout
 *
 *
 */

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;


/**
 *  Public interface
 *
 *
 */
- (void)setUserHeadIconWithImage:(UIImage *)image;

/**
 *  IBAction
 *
 *  @param sender
 */

- (IBAction)uploadUserImage:(id)sender;
- (IBAction)reGetVerifyCode:(id)sender;
- (IBAction)confirmRegistInfo:(id)sender;



@end
