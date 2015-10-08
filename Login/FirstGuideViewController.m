//
//  FirstGuideViewController.m
//  PlanBoardDemo
//
//  Created by OMGDER on 15/10/3.
//  Copyright © 2015年 OMGDER. All rights reserved.
//

#import "FirstGuideViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "RegisterViewController.h"

@interface FirstGuideViewController ()
@property (strong, nonatomic)MPMoviePlayerController *playerController;




@end

@implementation FirstGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 //   self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
    [self.LoginBtn.layer setMasksToBounds:YES];
    [self.LoginBtn.layer setCornerRadius:2.f];
    //[self.LoginBtn]
    
    [self.registBtn.layer setMasksToBounds:YES];
    [self.registBtn.layer setCornerRadius:2.f];
    
    
    
    //[self.view bringSubviewToFront:self.buttonsView];

    [self _init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self startPlay];
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
                        imageView2.hidden = YES;
                    }
                }
            }
        }
    }


}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopPlay];
    
    [super viewWillDisappear:animated];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
     //   [self _init];
    }
    return self;
}


- (void)_init
{
   
    NSString *path = [[NSBundle mainBundle] pathForResource:@"lanchvide" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:path];
     _playerController = [[MPMoviePlayerController alloc] initWithContentURL:url];
    [[_playerController view] setFrame:[UIScreen mainScreen].bounds];
    _playerController.controlStyle = MPMovieControlStyleNone;
    _playerController.movieSourceType = MPMovieSourceTypeFile;
    _playerController.repeatMode = MPMovieRepeatModeOne;
    _playerController.scalingMode = MPMovieScalingModeAspectFill;
    _playerController.shouldAutoplay = YES;
    // self.imageView = [UIImageView alloc]initWithImage:[UIImage imageNamed:@""];
    [self.playView addSubview:[_playerController view]];
    [self startPlay];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)startPlay
{
    [_playerController play];
}

- (void)stopPlay
{
    [_playerController stop];
}

#pragma mark -- push

- (IBAction)gotoRegisterView:(id)sender
{
    RegisterViewController *registerVC = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:registerVC animated:YES];
    
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"back"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 34, 4, 4)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];


}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
