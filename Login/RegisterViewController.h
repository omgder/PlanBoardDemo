//
//  RegisterViewController.h
//  PlanBoardDemo
//
//  Created by OMGDER on 15/10/5.
//  Copyright © 2015年 OMGDER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberInputTextField;

@property (weak, nonatomic) IBOutlet UIButton *getVerifyCodeBtn;


@end
