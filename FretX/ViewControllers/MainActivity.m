//
//  MainActivity.m
//  FretX
//
//  Created by P1 on 6/28/17.
//  Copyright © 2017 rocks.fretx. All rights reserved.
//

#import "MainActivity.h"
#import "LoginActivity.h"
#import "AppDelegate.h"
#import "UIViewController+Alerts.h"
#import "ToastHelper.h"
#import "MBProgressHUD.h"
@import Firebase;

@interface MainActivity ()
{
    AppDelegate *app;
    FIRDatabaseReference *dbRef;
    MBProgressHUD *hud;
    NSString *mUserID;
    
    __weak IBOutlet UIView *v_body;
    __weak IBOutlet UITextField *tf_guitar;
    __weak IBOutlet UITextField *tf_hand;
    __weak IBOutlet UITextField *tf_level;
    
}
@end

@implementation MainActivity

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dbRef = [[FIRDatabase database] reference];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    mUserID = [defaults objectForKey: @"user_id"];
}

- (void) showProgressBar: (NSString *) message
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = message;
}

- (IBAction)didSelectSave:(id)sender {
    NSString *mGuitar = tf_guitar.text;
    NSString *mHand = tf_hand.text;
    NSString *mLevel = tf_level.text;
    
    if (mGuitar != nil && mHand != nil && mLevel != nil) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             mGuitar, @"guitar",
                             mHand, @"hand",
                             mLevel, @"level", nil];
        [[[[dbRef child: @"users"] child: mUserID] child: @"prefs"] setValue: dic];
    } else
    {
        [self showMessagePrompt: @"All fields are required."];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
