//
//  BLEConnectionViewController.m
//  FretX
//
//  Created by Developer on 7/13/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "BLEConnectionViewController.h"

@interface BLEConnectionViewController ()

@end

@implementation BLEConnectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

#pragma mark -  Actions

- (IBAction)onPressConnectionButton:(id)sender{
    
}

- (IBAction)onPressDoItLaterButton:(id)sender{
    
    [self performSegueWithIdentifier:kLightsIndicatorsSegue sender:self];
}

- (IBAction)onNeedAssistanceButton:(id)sender{
    
}

@end
