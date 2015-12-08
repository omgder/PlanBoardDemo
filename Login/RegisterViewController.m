//
//  RegisterViewController.m
//  PlanBoardDemo
//
//  Created by OMGDER on 15/10/5.
//  Copyright © 2015年 OMGDER. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterInformationViewController.h"
#import <SMS_SDK/SMS_SDK.h>
#import "NSString+Extend.h"

#define kPhoneNumberNotNULL @"telphoneNumNotNull"

@interface RegisterViewController ()

@end

@implementation RegisterViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    [self.getVerifyCodeBtn.layer setMasksToBounds:YES];
    [self.getVerifyCodeBtn.layer setCornerRadius:4.f];
    self.navigationItem.title = @"注册";
  
    
    
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)])
    {
        NSArray *list = self.navigationController.navigationBar .subviews;
        for (id obj in list)
        {
            if ([obj isKindOfClass:[UIImageView class]])
            {
                UIImageView *imageView = (UIImageView *)obj;
                NSArray *list2 = imageView.subviews;
                for (id obj2 in list2)
                {
                    if ([obj2 isKindOfClass:[UIImageView class]])
                    {
                        UIImageView *imageView2  =(UIImageView *)obj2;
                        imageView2.hidden = NO;
                    }
                }
            }
        }
    }

    

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark -- btnAction;

- (IBAction)getVerifyCode:(id)sender
{
    
    if ([self.phoneNumberInputTextField.text isTelephone])
    {
    
        [SMS_SDK getVerificationCodeBySMSWithPhone:self.phoneNumberInputTextField.text zone:@"86" result:^(SMS_SDKError *error) {
        
            if (!error)
            {
        
                RegisterInformationViewController *registerInfoVC = [[RegisterInformationViewController alloc] initWithNibName:@"RegisterInformationViewController" bundle:nil];
                
                registerInfoVC.number = self.phoneNumberInputTextField.text;
                [self.navigationController pushViewController:registerInfoVC animated:YES];
            }
            
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:error.errorDescription delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            
            }
            
        
        }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入正确的手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

- (IBAction)clickBackground:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


#pragma mark = UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //[self becomeFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
  //  [self becomeFirstResponder];

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{//限制最大13个字
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (self.phoneNumberInputTextField == textField)
    {
        if ([toBeString length] > 13) {
            textField.text = [toBeString substringToIndex:13];
            return NO;
        }
    }
    return YES;
}


#pragma mark -- updateData


@end
