//
//  RegisterInformationViewController.m
//  PlanBoardDemo
//
//  Created by OMGDER on 15/10/5.
//  Copyright © 2015年 OMGDER. All rights reserved.
//
#import "RegisterInformationViewController.h"
#import "LoginNetDAO.h"
#import "NSString+XY.h"
#import "RegistInfoEntity.h"
#import "ModuleRouter.h"

typedef enum kActionButtonIndex
{
    kActionButtonIndexPhotoAblum = 1,
    kActionButtonIndexCamera
}kAcitonIndex;

@interface RegisterInformationViewController()
{
    NSDictionary *_registInfoDic;
}

@property (nonatomic, strong) LoginNetDAO *dao;
@property (nonatomic, strong) RegistInfoEntity *entity;

@end

@implementation RegisterInformationViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        _registInfoDic = [[NSMutableDictionary alloc] init];
        _entity = [[RegistInfoEntity alloc] init];
        _dao = [LoginNetDAO dao];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _entity.phoneNum = self.number;
    
    
    if ([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height)
    {
        self.contentViewWidth.constant = [UIScreen mainScreen].bounds.size.width;
        self.contentViewHeight.constant = [UIScreen mainScreen].bounds.size.height;
    }
    else
    {
        self.contentViewWidth.constant = [UIScreen mainScreen].bounds.size.height;
        self.contentViewHeight.constant = [UIScreen mainScreen].bounds.size.width;
    }
    
    
    
    
    self.navigationItem.title = @"注册信息";
   [self.headerIconBtn setImage:[UIImage imageNamed:@"cameraIcon"] forState:UIControlStateNormal];
    //btn.layer.mas
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


#pragma mark -- IBAction

//点击弹出设置头像按钮
- (IBAction)uploadUserImage:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        [actionSheet addButtonWithTitle:@"从相册选择"];
    }
    
    //判断摄像头是否可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [actionSheet addButtonWithTitle:@"拍摄照片"];
    }
    

    
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
    
    
}
- (IBAction)reGetVerifyCode:(id)sender
{

}

- (IBAction)confirmRegistInfo:(id)sender
{
    
    [[ModuleRouter sharedInstance] jumpToMatchListViewControllerFromSource:self];
    
    
    
    if ([self checkRegistInfomation])
    {
        [_dao registRequestWithInfo:_registInfoDic completion:^(id dao, NSDictionary *result, NSError *error) {
            if (result)
            {
                NSLog(@"%@",result);
                
            }
        }];
    }
    else
    {
        
    
    }
    

}

#pragma mark -- UIActionSheet delegat
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case kActionButtonIndexPhotoAblum:
        {
            UIImagePickerController *pickerPhotosAlbumController = [[UIImagePickerController alloc] init];
            pickerPhotosAlbumController.allowsEditing  = YES;
            pickerPhotosAlbumController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            pickerPhotosAlbumController.delegate   = self;
            
            [self presentViewController:pickerPhotosAlbumController animated:NO completion:nil];
            
        
        }
            break;
        case kActionButtonIndexCamera:
        {
            UIImagePickerController *pickerCameraController = [[UIImagePickerController alloc] init];
            pickerCameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerCameraController.delegate = self;
            pickerCameraController.allowsEditing = YES;
            
            [self presentViewController:pickerCameraController animated:NO completion:nil];
        
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -- UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{

    if (image)
    {
        [picker dismissViewControllerAnimated:YES completion:^{
            
            [self.headerIconBtn.layer setMasksToBounds:YES];
            self.headerIconBtn.layer.contents = (id)image.CGImage;
            [self.headerIconBtn setImage:nil forState:UIControlStateNormal];
            self.headerImageData = UIImageJPEGRepresentation(image, 0.5);
        }];
    }

}

- (BOOL)checkRegistInfomation
{
    if (self.number && [self checkPassWordForRegist] && [self checkVerifyCodeForRegist] && [self checkNickName] && [self checkEmail])
    {
        _registInfoDic = @{
                           @"phone"     : self.number,
                           @"passwd"    : self.password,
                           @"nick"      : self.nickName,
                           @"checkcode" : self.verfiyCode,
                           @"email"     : self.email
                          // @"figure_data" : self.headerImageData
                           };
    }
    else
    {
        return NO;
    }
    return YES;
    
}

- (BOOL)checkVerifyCodeForRegist
{
    if (self.verifyCodeTextField.text)
    {
        self.verfiyCode = self.verifyCodeTextField.text;
        return YES;
    }
    else
    {
        return NO;
    }
}



- (BOOL)checkPassWordForRegist
{
    
    if (self.secretCodeTextField.text.length >= 6)
    {
        NSString *passWord = [self.secretCodeTextField.text uxy_MD5String];
        self.password = passWord;
        return YES;
    }
    else
    {
        return NO;
    }
}



- (BOOL)checkNickName
{
    if (self.nickNameTextField.text)
    {
        self.nickName = self.nickNameTextField.text;
        return YES;
    }
    else
        return NO;

}



- (BOOL)checkEmail
{
    if (self.emailTextField.text)
    {
        self.email = self.emailTextField.text;
        return YES;
    }
    else
    {
        return NO;
    }

}




#pragma mark -- background clicked


- (IBAction)backgroundClicked:(id)sender
{
    //[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - hidden keyboard
- (IBAction)textField_DidEndOnExit:(id)sender
{
    // 隐藏键盘.
    [sender resignFirstResponder];
}


@end
