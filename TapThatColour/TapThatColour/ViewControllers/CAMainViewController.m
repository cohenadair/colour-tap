//
//  ViewController.m
//  ColorTap
//
//  Created by Cohen Adair on 2015-07-09.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <iAd/iAd.h>
#import "CAMainViewController.h"
#import "CAGameOverViewController.h"
#import "CAGameScene.h"
#import "CAGameCenterManager.h"
#import "CAUserSettings.h"
#import "CATexture.h"

@interface CAMainViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tapToBeginLabel;

@property (nonatomic) UIBarButtonItem *soundButton;
@property (nonatomic) UIBarButtonItem *flexibleSpace;
@property (nonatomic) UIBarButtonItem *playButton;
@property (nonatomic) UIBarButtonItem *pauseButton;

@property (nonatomic) SKView *spriteView;
@property (nonatomic) CAGameScene *gameScene;
@property (nonatomic) BOOL autoStartGame;

@property (nonatomic) BOOL didEnterBackground;

@end

@implementation CAMainViewController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [CAUtilities hideStatusBar];
    
    [self initGameCenter];
    [self initSpriteView];
    [self initToolbar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self toggleSoundButton];
    [self togglePlayPauseButton];
    
    [self showGameView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initGameCenter {
    __weak typeof(self) weakSelf = self;
    
    [[CAGameCenterManager sharedManager] authenticateInViewController:self willPresentBlock:^{
        if (weakSelf.gameScene.animationBegan)
            [weakSelf pauseGame];
    }];
}

#pragma mark - Sprite View

- (void)initSpriteView {
    self.spriteView = (SKView *)self.view;
    //self.spriteView.showsDrawCount = YES;
    //self.spriteView.showsNodeCount = YES;
    //self.spriteView.showsFPS = YES;
    
    [[CATexture sharedTexture] setSpriteView:self.spriteView];
}

- (void)showGameView {
    __weak typeof(self) weakSelf = self;
    
    [self setGameScene:[[CAGameScene alloc] initWithSize:[CAUtilities screenSize]]];
    [self.gameScene setViewController:self];
    [self.gameScene setAutoStart:self.autoStartGame];
    [self.gameScene setOnGameStart:^(void) {
        [[weakSelf pauseButton] setEnabled:YES];
        [[weakSelf tapToBeginLabel] setHidden:YES];
    }];

    [self.spriteView presentScene:self.gameScene];
}

- (void)pauseGame {
    self.spriteView.paused = YES;
    self.spriteView.userInteractionEnabled = NO;
    [self togglePlayPauseButton];
}

#pragma mark - Toolbar

// done programatically so toggling between play/pause can be done with the system buttons
- (void)initToolbar {
    [CAUtilities makeToolbarTransparent:self.navigationController.toolbar];
    
    self.soundButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sound"] style:UIBarButtonItemStylePlain target:self action:@selector(tapSoundButton)];
    self.soundButton.tintColor = [UIColor blackColor];
    
    self.flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    self.pauseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(tapPlayPauseButton)];
    self.pauseButton.tintColor = [UIColor blackColor];
    self.pauseButton.enabled = NO;
    
    self.playButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(tapPlayPauseButton)];
    self.playButton.tintColor = [UIColor blackColor];
}

- (void)toggleSoundButton {
    if ([[CAUserSettings sharedSettings] muted])
        [self.soundButton setImage:[UIImage imageNamed:@"mute"]];
    else
        [self.soundButton setImage:[UIImage imageNamed:@"sound"]];
}

- (void)togglePlayPauseButton {
    if (self.spriteView.paused)
        self.toolbarItems = @[self.soundButton, self.flexibleSpace, self.playButton];
    else
        self.toolbarItems = @[self.soundButton, self.flexibleSpace, self.pauseButton];
}

- (void)tapSoundButton {
    [[CAUserSettings sharedSettings] setMuted:![[CAUserSettings sharedSettings] muted]];
    [self toggleSoundButton];
}

- (void)tapPlayPauseButton {
    self.spriteView.paused = !self.spriteView.paused;
    self.spriteView.userInteractionEnabled = !self.spriteView.paused;
    [self togglePlayPauseButton];
}

#pragma mark - Navigation

- (IBAction)unwindToMain:(UIStoryboardSegue *)aSegue {
    [self setAutoStartGame:YES];
}

- (void)segueToGameOver {
    [self performSegueWithIdentifier:@"fromMainToGameOver" sender:nil];
}

#pragma mark - Application Closing/Opening

- (void)applicationWillEnterBackground {
    self.didEnterBackground = YES;
}

- (void)applicationWillEnterForeground {
    
}

// an SKView is automatically unpaused when the application becomes active
- (void)applicationDidBecomeActive {
    [self pauseGameAfterDidBecomeActive];
}

- (void)pauseGameAfterDidBecomeActive {
    __weak typeof(self) weakSelf = self;
    
    // needs a short delay to override the SKView's callback actions
    [CAUtilities executeBlockAfterMs:1 block:^(void) {
        if (weakSelf.didEnterBackground &&
            weakSelf.gameScene.animationBegan && // no need to pause if the game hasn't started
            !weakSelf.gameScene.isGameOver) // no need to pause if the game is over
        {
            [self pauseGame];
        }
    }];
}

@end
