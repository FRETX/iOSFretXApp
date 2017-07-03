//
//  SplashScreens.m
//  FretX
//
//  Created by P1 on 6/28/17.
//  Copyright © 2017 rocks.fretx. All rights reserved.
//

#import "SplashScreens.h"
#import "MainTabBarController.h"
#import "UIViewController+Alerts.h"
#import "LoginActivity.h"
@import Firebase;

@interface SplashScreens ()
{
    FIRDatabaseReference *dbRef;
}
@end

@implementation SplashScreens

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dbRef = [[FIRDatabase database] reference];
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self checkUser];
        
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) checkUser
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentEmail = [defaults objectForKey: @"userEmail"];
    if (currentEmail != nil) {
        [[[[dbRef child: @"users"] queryOrderedByChild: @"user_email"]
          queryEqualToValue: currentEmail]
         observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
             if (snapshot.value != [NSNull null]){
                 [self gotoMain];
             }else
             {
                 [self gotoLogin];
             }
         }];
    } else
    {
        [self gotoLogin];
    }
    
}

- (void) gotoMain
{
    MainTabBarController *mLogin = [self.storyboard instantiateViewControllerWithIdentifier: @"mainActivity"];
    [self.navigationController pushViewController: mLogin animated: YES];
}

- (void) gotoLogin
{
    LoginActivity *mLogin = [self.storyboard instantiateViewControllerWithIdentifier: @"LoginViewController"];
    [self.navigationController pushViewController: mLogin animated: NO];
    
    return;
}

@end
