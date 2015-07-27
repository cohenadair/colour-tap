//
//  CAGameOverViewController.m
//  TapThatColour
//
//  Created by Cohen Adair on 2015-07-22.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import "CAGameOverViewController.h"
#import "CAUserSettings.h"

@interface CAGameOverViewController ()

@property (weak, nonatomic) IBOutlet UIButton *soundButton;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (nonatomic) BOOL muted;

@end

@implementation CAGameOverViewController

- (CAUserSettings *)userSettings {
    return [CAUserSettings sharedSettings];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scoreLabel setText:[NSString stringWithFormat:@"%ld", (long)self.score]];
    [self initSoundButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)tapShareButton:(UIButton *)aSender {
    NSArray *items = @[[NSString stringWithFormat:@"I just scored %ld on #TapThatColour! Check it out on the App Store!", (long)self.score]];
    UIActivityViewController *act = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    [self presentViewController:act animated:YES completion:nil];
}

- (IBAction)tapRateButton:(UIButton *)aSender {
    NSString *stringUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%d", 1019522139];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringUrl]];
}

- (IBAction)tapSoundButton:(UIButton *)sender {
    CAUserSettings *userSettings = [self userSettings];
    userSettings.muted = !userSettings.muted;
    [self initSoundButton];
}

- (void)initSoundButton {
    if ([self userSettings].muted)
        [self.soundButton setImage:[UIImage imageNamed:@"mute"] forState:UIControlStateNormal];
    else
        [self.soundButton setImage:[UIImage imageNamed:@"sound"] forState:UIControlStateNormal];
}

@end
