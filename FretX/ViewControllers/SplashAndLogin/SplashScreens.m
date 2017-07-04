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
    [self.navigationController setNavigationBarHidden:YES];
    double delayInSeconds = 2.5;
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
    NSString *currentUid = [defaults objectForKey: @"uid"];
    NSString *uid = [[[FIRAuth auth] currentUser] uid];
    
    if (currentUid == nil) {
        [self gotoLogin];
    } else if ([currentUid isEqualToString: uid])
    {
        [self gotoMain];
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
