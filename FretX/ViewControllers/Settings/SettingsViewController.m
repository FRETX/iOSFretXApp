//
//  SettingsViewController.m
//  FretX
//
//  Created by Developer on 6/29/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "SettingsViewController.h"
#import <Intercom/Intercom.h>
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "UIViewController+Alerts.h"
#import "LoginActivity.h"
@import Firebase;

@interface SettingsViewController ()
{
    
    __weak IBOutlet UIImageView *imv_profile;
    __weak IBOutlet UISwitch *sw_handness;
    AppDelegate *app;
    NSData *mDataOfProfileImage;
    FIRDatabaseReference *dbRef;
    __weak IBOutlet UILabel *lb_userName;
    MBProgressHUD *hud;
    __weak IBOutlet UISwitch *sw_handeness;
    NSString *mlogin_type;
    NSString *mHandeness;
}
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *mUID = [[[FIRAuth auth] currentUser] uid];
    [Intercom registerUserWithEmail: mUID];
    [self getProfileInfo];
}

- (void) getProfileInfo
{
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    // draw circular image
    imv_profile.layer.cornerRadius = 40;
    imv_profile.clipsToBounds = YES;
    imv_profile.layer.backgroundColor=[[UIColor clearColor] CGColor];
    imv_profile.layer.borderWidth=3.0;
    imv_profile.layer.masksToBounds = YES;
    imv_profile.layer.borderColor=[[UIColor whiteColor] CGColor];
    
    // retrieve data
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *currentEmail = [userDefaults objectForKey: @"user_email"];
//    
    NSString *currentUID = [[[FIRAuth auth] currentUser] uid];
    dbRef = [[[[FIRDatabase database] reference] child: @"users"] child: currentUID];
//    if (currentEmail == nil) {
//        
//    } else
//    {
//        NSString *profilePictureStr = [userDefaults objectForKey: @"profile_image_data"];
//        mDataOfProfileImage = [[NSData alloc] initWithBase64EncodedString: profilePictureStr options: 0];
//        imv_profile.image = [UIImage imageWithData: mDataOfProfileImage];
//        currentEmail = [userDefaults objectForKey: @"user_email"];
//        [Intercom registerUserWithEmail:currentEmail];
//    }
    [self showLoading: @"Loading..."];
    [dbRef observeSingleEventOfType: FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *dic = snapshot.value;
        hud.hidden = YES;
        if ([snapshot hasChild: @"profile_image_data"]) {
            mDataOfProfileImage = [[NSData alloc] initWithBase64EncodedString: [dic objectForKey: @"profile_image_data"] options: 0];
            imv_profile.image = [UIImage imageWithData: mDataOfProfileImage];
        }
        
        
        NSString *mUserName = [dic objectForKey: @"user_name"];
        lb_userName.text = mUserName;
        
        mlogin_type = [dic objectForKey: @"login_type"];
        
        NSDictionary *pref_dic = [dic objectForKey: @"prefs"];
        mHandeness = [pref_dic objectForKey: @"hand"];
        if ([mHandeness isEqualToString: @"left"]) {
            [sw_handness setOn: YES];
        } else
            [sw_handness setOn: NO];
        
    }];
    
}

- (void) showLoading: (NSString *) message
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = message;
}

- (IBAction)didChangeHandSwitch:(id)sender {
    if ([sw_handness isOn]) {
        [sw_handness setOn: NO];
        [[[dbRef child: @"prefs"] child: @"hand"] setValue: @"right"];
    } else
    {
        [sw_handness setOn: YES];
        [[[dbRef child: @"prefs"] child: @"hand"] setValue: @"left"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didSelectSignout:(id)sender {
    NSError *signoutError;
    BOOL status;
    status = [[FIRAuth auth] signOut: &signoutError];
    if (!status) {
        [self showMessagePrompt: signoutError.localizedDescription];
        return;
    } else
    {
        [app initialize];
        [Intercom reset];
        [self gotoLoginScreen];
    }
}

- (void) gotoLoginScreen
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    LoginActivity *mLogin = [sb instantiateViewControllerWithIdentifier: @"LoginViewController"];
    [mLogin setModalPresentationStyle:UIModalPresentationCustom];
    [mLogin setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:mLogin animated:YES completion:nil];
}

- (IBAction)didSelectOnboarding:(id)sender {
}

- (IBAction)didSelectLeaveMessage:(id)sender {
    [Intercom presentMessenger];
}


@end
