//
//  TroubleshootingViewController.m
//  FretX
//
//  Created by Developer on 18.07.17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "TroubleshootingViewController.h"
#import "VideoTutorialViewController.h"

@interface TroubleshootingViewController ()

@end

@implementation TroubleshootingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onTurnDeviceOn:(UIButton*)sender{
    VideoTutorialViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VideoTutorialViewController"];
    [vc showSingleViedeo:sender.tag];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
    
}

@end
