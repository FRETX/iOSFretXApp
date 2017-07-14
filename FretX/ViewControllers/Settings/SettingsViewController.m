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
#import <FretXBLE/FretXBLE-Swift.h>
@import Firebase;

#import "MainSettingsViewController.h"

@interface SettingsViewController ()
{
    
    __weak IBOutlet UIImageView *imv_profile;
    AppDelegate *app;
    NSData *mDataOfProfileImage;
    FIRDatabaseReference *dbRef;
    __weak IBOutlet UILabel *lb_userName;
    MBProgressHUD *hud;
    NSString *mlogin_type;
    
    // segmented control
    __weak IBOutlet UISegmentedControl *s_hand;
    __weak IBOutlet UISegmentedControl *s_guitar;
    __weak IBOutlet UISegmentedControl *s_skill;
    
}
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *mUID = [[[FIRAuth auth] currentUser] uid];
    [Intercom registerUserWithEmail: mUID];
    [self getProfileInfo];
}

- (void) viewDidAppear:(BOOL)animated{
    [FretxBLE.sharedInstance clear];
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
    
    NSString *currentUID = [[[FIRAuth auth] currentUser] uid];
    dbRef = [[[[FIRDatabase database] reference] child: @"users"] child: currentUID];

    [self showLoading: @"Loading..."];
    [dbRef observeSingleEventOfType: FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *dic = snapshot.value;
        hud.hidden = YES;
        if ([snapshot hasChild: @"profile_image_data"]) {
            mDataOfProfileImage = [[NSData alloc] initWithBase64EncodedString: [dic objectForKey: @"profile_image_data"] options: 0];
            imv_profile.image = [UIImage imageWithData: mDataOfProfileImage];
        }
        
        if (!dic || [dic isEqual:[NSNull null]]) {
            return;
        }
        
        NSString *mUserName = [dic objectForKey: @"user_name"];
        lb_userName.text = mUserName;
        
        mlogin_type = [dic objectForKey: @"login_type"];
        
        NSDictionary *pref_dic = [dic objectForKey: @"prefs"];
        NSString *mHandedness = [pref_dic objectForKey: @"hand"];
        if ([mHandedness isEqualToString: @"right"]) {
            [s_hand setSelectedSegmentIndex: 0];
        } else
            [s_hand setSelectedSegmentIndex: 1];
        
        NSString *mGuitar = [pref_dic objectForKey: @"guitar"];
        if ([mGuitar isEqualToString: @"classical"]) {
            [s_guitar setSelectedSegmentIndex: 0];
        } else if ([mGuitar isEqualToString: @"electric"])
            [s_guitar setSelectedSegmentIndex: 1];
        else
            [s_guitar setSelectedSegmentIndex: 2];
            
        
        NSString *mLevel = [pref_dic objectForKey: @"level"];
        if ([mLevel isEqualToString: @"beginner"]) {
            [s_skill setSelectedSegmentIndex: 0];
        } else
            [s_skill setSelectedSegmentIndex: 1];
        
    }];
    
}

- (void) showLoading: (NSString *) message
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = message;
}
- (IBAction)didChangeValueOfPrefs:(id)sender {
    UISegmentedControl *selectedControll = (UISegmentedControl *) sender;
    switch (selectedControll.tag) {
        case 1:
            // change Handedness
            if (selectedControll.selectedSegmentIndex == 0) {
                [[[dbRef child: @"prefs"] child: @"hand"] setValue: @"right"];
            } else
            {
                [[[dbRef child: @"prefs"] child: @"hand"] setValue: @"left"];
            }
            break;
        case 2:
            // change Guitar Type
            switch (selectedControll.selectedSegmentIndex) {
                case 0:
                    [[[dbRef child: @"prefs"] child: @"guitar"] setValue: @"classical"];
                    break;
                case 1:
                    [[[dbRef child: @"prefs"] child: @"guitar"] setValue: @"electric"];
                    break;
                case 2:
                    [[[dbRef child: @"prefs"] child: @"guitar"] setValue: @"acoustic"];
                    break;
                 
            }
            break;
        case 3:
            // change Skill Level
            if (selectedControll.selectedSegmentIndex == 0) {
                [[[dbRef child: @"prefs"] child: @"level"] setValue: @"beginner"];
            } else
            {
                [[[dbRef child: @"prefs"] child: @"level"] setValue: @"player"];
            }
            break;
        
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
    
    UIStoryboard *onboardingStoryboard = [UIStoryboard storyboardWithName:@"Onboarding" bundle:nil];
    MainSettingsViewController *mainSettingsController = [onboardingStoryboard instantiateViewControllerWithIdentifier:@"MainSettingsViewController"];
    
    [self.navigationController pushViewController:mainSettingsController animated:YES];
}

- (IBAction)didSelectLeaveMessage:(id)sender {
    [Intercom presentMessenger];
}


@end
