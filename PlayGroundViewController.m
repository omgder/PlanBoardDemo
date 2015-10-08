//
//  PlayGroundViewController.m
//  PlanBoard2
//
//  Created by OMGDER on 15/9/13.
//  Copyright (c) 2015年 OMGDER. All rights reserved.
//

#import "PlayGroundViewController.h"
#import "PlayersManager.h"
#import "HMSideMenu.h"
#import "RecordManager.h"
#import "ACEDrawingView.h"


#define VEDIOPATH @"vedioPath"

@interface PlayGroundViewController ()
{
    NSMutableArray *_ourTeamates;
    NSMutableArray *_enermyTeamtes;
    BOOL _isRecording;
}



@property (nonatomic, strong) PlayersManager *playMan;  //球员管理；
@property (nonatomic, strong) UIView *playView;         //球场
@property (nonatomic, strong) UIImageView *grassView;   //球场背景
@property (nonatomic, strong) ACEDrawingView *drawView; //画笔




@end

@implementation PlayGroundViewController



- (void)viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:animated];
    
    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //初始化草皮 哈哈 就是加载图片
    
    _grassView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    UIImage *grassImage = [UIImage imageNamed:@"img_playGround.jpg"];
    _grassView.image = grassImage;
    [self.view addSubview:_grassView];
    
    //初始化球员管理
    _playMan = [[PlayersManager alloc] init];
    _playView = [[UIView alloc] initWithFrame:self.view.bounds];
    _playView.backgroundColor = [UIColor clearColor];
    
    NSLog(@"！！%@",NSStringFromCGRect([UIScreen mainScreen].bounds));
    NSLog(@"！！!%@",NSStringFromCGRect(self.view.frame));
    [self.view addSubview:_playView];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    
    
    //初始化划线
    _drawView = [[ACEDrawingView alloc] initWithFrame:self.view.bounds];
    _drawView.backgroundColor = [UIColor clearColor];
    _drawView.delegate = self;
    _drawView.lineWidth  = 2.f;
    _drawView.lineColor  = [UIColor whiteColor];
    _drawView.userInteractionEnabled = NO;
    [self.view addSubview:_drawView];
    
    //右侧侧边栏按钮开关
    UIButton *menuSwitch = [UIButton buttonWithType:UIButtonTypeCustom];
    menuSwitch.tag = 10000;
    
    menuSwitch.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 + 73, 22 , 40, 40);
    [menuSwitch.layer setCornerRadius:menuSwitch.frame.size.height / 2];
    [menuSwitch.layer setMasksToBounds:YES];
    [menuSwitch setImage:[UIImage imageNamed:@"icon_addPlayer"] forState:UIControlStateNormal];
    
    [menuSwitch setTitle:@"menu" forState:UIControlStateNormal];
    [menuSwitch setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [menuSwitch addTarget:self action:@selector(toggleAddPlayerMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuSwitch];
    
    
    
    
    UIButton *recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    recordBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 111, 22 , 40, 40);
    [recordBtn.layer setCornerRadius:recordBtn.frame.size.height / 2];
    [recordBtn.layer setMasksToBounds:YES];
    [recordBtn setImage:[UIImage imageNamed:@"icon_record"] forState:UIControlStateNormal];
    
    [recordBtn setTitle:@"menu" forState:UIControlStateNormal];
    [recordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [recordBtn addTarget:self action:@selector(recordMustSuccess:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recordBtn];
    
    UIButton *stopRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stopRecordBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 51
                                     , 22 , 40, 40);
    [stopRecordBtn.layer setCornerRadius:stopRecordBtn.frame.size.height / 2];
    [stopRecordBtn.layer setMasksToBounds:YES];
    [stopRecordBtn setImage:[UIImage imageNamed:@"icon_stopRecord"] forState:UIControlStateNormal];
    
    [stopRecordBtn setTitle:@"menu" forState:UIControlStateNormal];
    [stopRecordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [stopRecordBtn addTarget:self action:@selector(stopRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopRecordBtn];
    
    
    UIButton *penBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    penBtn.tag = 10001;
    penBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 + 11, 22 , 40, 40);
    [penBtn.layer setCornerRadius:penBtn.frame.size.height / 2];
    [penBtn.layer setMasksToBounds:YES];
    [penBtn setImage:[UIImage imageNamed:@"icon_add_our"] forState:UIControlStateNormal];
    
    [penBtn setTitle:@"menu" forState:UIControlStateNormal];
    [penBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [penBtn addTarget:self action:@selector(toggleAddPlayerMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:penBtn];
    
    
    [self createRightMenu];
    
    [self createLeftMenu];
    
    [_playMan addFootball:_playView];

}

#pragma mark -- initMenu

- (void)createRightMenu
{
    //add Player
    UIView *addPlayerOurItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [addPlayerOurItem setMenuActionWithBlock:^{
        NSLog(@"add succeed");
      
        [self addOurPlayer:nil];
        [_playView bringSubviewToFront:_playMan.football];
        
    }];
    
    UIImageView *addPlayerIcon = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 36, 36)];
    [addPlayerIcon setImage:[UIImage imageNamed:@"icon_add_our"]];
    [addPlayerOurItem addSubview:addPlayerIcon];
    
    
    
    
    
    UIView *descOurPlayerItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [descOurPlayerItem setMenuActionWithBlock:^{
        [self removeOneTeammate:nil];
    }];
    UIImageView *desclIcon = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 36 , 36)];
    [desclIcon setImage:[UIImage imageNamed:@"icon_desc_our"]];
    [descOurPlayerItem addSubview:desclIcon];
    
    
    
    
    
    UIView *addPlayerAgainstItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [addPlayerAgainstItem setMenuActionWithBlock:^{
        
        [self addAgainstPlayer:nil];
        [_playView bringSubviewToFront:_playMan.football];
        
    }];
    UIImageView *addPlayerAgainstIcon = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 35, 35)];
    [addPlayerAgainstIcon setImage:[UIImage imageNamed:@"icon_add_against"]];
    [addPlayerAgainstItem addSubview:addPlayerAgainstIcon];
    
    UIView *descAgainstPlayerItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [descAgainstPlayerItem setMenuActionWithBlock:^{
        
        [self removeOneAgainst:nil];
    }];
    UIImageView *descAgainstPlayerIcon = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 36, 36)];
    [descAgainstPlayerIcon setImage:[UIImage imageNamed:@"icon_desc_against"]];
    [descAgainstPlayerItem addSubview:descAgainstPlayerIcon];
    
    self.rightSideMenu = [[HMSideMenu alloc] initWithItems:@[addPlayerOurItem, descOurPlayerItem, addPlayerAgainstItem, descAgainstPlayerItem]];
    [self.rightSideMenu setItemSpacing:5.0f];
    [self.view addSubview:self.rightSideMenu];
}


- (void)createLeftMenu
{
    //add Player
    UIView *undo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [undo setMenuActionWithBlock:^{
        [self undoDraw:nil];
    }];
    
    UIImageView *undoIcon = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 36, 36)];
    [undoIcon setImage:[UIImage imageNamed:@"icon_undo"]];
    [undo addSubview:undoIcon];
    
    
    
    UIView *redo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [redo setMenuActionWithBlock:^{
        [self redoDraw:nil];
    }];
    
    UIImageView *redoIcon = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 36, 36)];
    [redoIcon setImage:[UIImage imageNamed:@"icon_redo"]];
    [redo addSubview:redoIcon];
    
    UIView *clean = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [clean setMenuActionWithBlock:^{
        NSLog(@"add succeed");
        [self clearLines:nil];
    }];
    
    UIImageView *cleanIcon = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 36, 36)];
    [cleanIcon setImage:[UIImage imageNamed:@"icon_desc_against"]];
    [clean addSubview:cleanIcon];
    
    

    self.leftSideMenu = [[HMSideMenu alloc] initWithItems:@[undo , redo, clean]];
    
    self.leftSideMenu.menuPosition = HMSideMenuPositionLeft;
    [self.leftSideMenu setItemSpacing:5.0f];
    [self.view addSubview:self.leftSideMenu];
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

#pragma mark -- Edit Plays

- (IBAction)addOurPlayer:(id)sender
{
    NSLog(@"addPlayer");
    [_playMan loadOurAvatarInCustomView:_playView];
    
}


- (IBAction)removeOneTeammate:(id)sender
{
    NSLog(@"removeteammate");
    [_playMan removeOneTeamMate];
}


- (IBAction)addAgainstPlayer:(id)sender
{
    NSLog(@"addPlayer");
    [_playMan loadAgainstAvatarInCustomView:_playView];
}

- (IBAction)removeOneAgainst:(id)sender
{
    NSLog(@"removeAgainst");
    [_playMan removeOneAgainst];

}

#pragma mark -- Menu

- (IBAction)toggleAddPlayerMenu:(id)sender
{
    if (((UIButton *)sender).tag == 10000)
    {
  
        if (self.rightSideMenu.isOpen)
        {
            [self.rightSideMenu close];
     //   _drawView.userInteractionEnabled = NO;
        }
        else
        {
            [self.rightSideMenu open];
     //   _drawView.userInteractionEnabled = YES;
        }
    }
    else if (((UIButton *)sender).tag == 10001)
    {
    
        if (self.leftSideMenu.isOpen)
        {
            [self.leftSideMenu close];
              _drawView.userInteractionEnabled = NO;
        }
        else
        {
            [self.leftSideMenu open];
            _drawView.userInteractionEnabled = YES;
        }
    }
}

#pragma mark -- Record Manager

- (IBAction)recordMustSuccess:(id)sender
{
    if (!_isRecording) {
          _isRecording = YES;
        [[RecordManager shareInstance] recordView:self.view];
    }
  
    
}

- (IBAction)stopRecord:(id)sender
{
    if (_isRecording) {
        _isRecording = NO;
        [[RecordManager shareInstance] stopRecord];
    }
    
   
}



#pragma mark -- drawing



- (IBAction)undoDraw:(id)sender
{
    if ([_drawView canUndo])
    {
        [_drawView undoLatestStep];
    }
    [self updateButtonStatus];
}


- (IBAction)redoDraw:(id)sender
{
    if ([_drawView canRedo])
    {
        [_drawView redoLatestStep];
    }
    [self updateButtonStatus];
    
}


- (IBAction)clearLines:(id)sender
{
    [_drawView clear];
    [self updateButtonStatus];
}

#pragma mark - ACEDrawing View Delegate

- (void)drawingView:(ACEDrawingView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool
{
    [self updateButtonStatus];
}

- (void)updateButtonStatus
{
   // self.undoButton.enabled = [self.drawingView canUndo];
   // self.redoButton.enabled = [self.drawingView canRedo];
}


@end

