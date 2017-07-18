//
//  NotSureViewController.m
//  FretX
//
//  Created by Evgen Litvinenko on 17.07.17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "NotSureViewController.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface NotSureViewController ()

@end

@implementation NotSureViewController

- (void)showForViewController:(UIViewController *)controller {
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        self.providesPresentationContextTransitionStyle = YES;
        self.definesPresentationContext = YES;
        
        [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    }
    else
    {
        [self setModalPresentationStyle:UIModalPresentationCurrentContext];
        [self.navigationController setModalPresentationStyle:UIModalPresentationCurrentContext];
    }
    
    [controller.navigationController presentViewController:self animated:NO completion:nil];
}

#pragma mark - Actions

- (IBAction)onOk:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
