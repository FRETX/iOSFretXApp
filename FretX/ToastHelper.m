//
//  ToastHelper.m
//  FretX
//
//  Created by P1 on 7/1/17.
//  Copyright © 2017 rocks.fretx. All rights reserved.
//

#import "ToastHelper.h"
#import "MBProgressHUD.h"

@implementation ToastHelper

+ (void) showToast: (NSString *) message
{
    
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    
    int duration = 3; // duration in seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
    
}

+ (void) showLoading: (UIView *) view message : (NSString *) message
{
    MBProgressHUD *hud;
    hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = message;
}

+ (void) hideLoading
{
    MBProgressHUD *hud;
    [hud setHidden:YES];
}

@end
