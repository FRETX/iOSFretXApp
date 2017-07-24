//
//  FretxKitViewController.m
//  FretX
//
//  Created by Developer on 7/13/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "FretxKitViewController.h"

@interface FretxKitViewController ()

@end

@implementation FretxKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Actions

- (IBAction)onReadyButton:(UIButton*)sender{
    [self performSegueWithIdentifier:kOpenVideoScreensSegue sender:self];
}

- (IBAction)onDoItLaterButton:(UIButton*)sender{
    [self.tabBarController setSelectedIndex:0];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
