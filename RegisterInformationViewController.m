//
//  RegisterInformationViewController.m
//  PlanBoardDemo
//
//  Created by OMGDER on 15/10/5.
//  Copyright © 2015年 OMGDER. All rights reserved.
//
#import "RegisterInformationViewController.h"

typedef enum kActionButtonIndex
{
    kActionButtonIndexPhotoAblum = 1,
    kActionButtonInd    
@implementation RegisterInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
        }];
    }

}


@end
