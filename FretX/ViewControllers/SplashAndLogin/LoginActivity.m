//
//  LoginActivity.m
//  FretX
//
//  Created by P1 on 6/28/17.
//  Copyright © 2017 rocks.fretx. All rights reserved.
//

#import "LoginActivity.h"
#import "ToastHelper.h"
#import "UIViewController+Alerts.h"
#import "MainTabBarController.h"
#import "MBProgressHUD.h"

#define profilePermission @"public_profile"
#define emailPermission @"email"
#define friendPermission @"user_friends"

@interface LoginActivity ()
{
    // custom login
    __weak IBOutlet UIView *vCustomLogin;
    __weak IBOutlet UITextField *tf_emailCustomLogin;
    __weak IBOutlet UITextField *tf_passwordCustomLogin;
    
    // register
    __weak IBOutlet UIView *v_register;
    __weak IBOutlet UITextField *tf_userName;
    __weak IBOutlet UITextField *tf_emailRegister;
    __weak IBOutlet UITextField *tf_passwordRegister;
    
    FIRDatabaseReference *dbRef;
    NSDictionary *dicToStoreInFirebaseUser;
    UIButton *button;
    
    // forgot password
    __weak IBOutlet UIView *v_forgotpassword;
    __weak IBOutlet UITextField *tf_emailForgotPassword;
    __weak IBOutlet UIButton *btn_back;
    MBProgressHUD *hud;
}
@end

@implementation LoginActivity

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    btn_back.hidden = YES;
    vCustomLogin.hidden = YES;
    v_register.hidden = YES;
    v_forgotpassword.hidden = YES;
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    dbRef = [[[FIRDatabase database] reference] child: @"users"];
    [self.navigationController setNavigationBarHidden:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"uid"];
    [defaults synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didSelectSigninWithFacebook:(id)sender {
    
    button = sender;
    button.userInteractionEnabled = NO;
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    //    [loginManager logInWithReadPermissions: [@"publick_profile", @"email"] fromViewController:self handler]
    
    [loginManager logInWithReadPermissions:@[emailPermission] fromViewController: self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
            [self showMessagePrompt:error.localizedDescription];
            button.userInteractionEnabled = YES;
            NSLog(@"Error %@", error.localizedDescription);
        } else if (result.isCancelled) {
            // Handle cancellations
            [self showMessagePrompt: @"Facebook login cancelled."];
            button.userInteractionEnabled = YES;
            NSLog(@"Facebook login cancelled.");
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            
            [self showLoading:@"Logging in..."];
            
            if ([FBSDKAccessToken currentAccessToken]) {
                
                [self signInFirebase: [FBSDKAccessToken currentAccessToken].tokenString];
                
            }
            
            
        }
    }];
    
}

- (IBAction)didSelectBack:(id)sender {
    if (vCustomLogin.hidden == NO) {
        vCustomLogin.hidden = YES;
        btn_back.hidden = YES;
    } else if (v_forgotpassword.hidden == NO)
    {
        v_forgotpassword.hidden = YES;
        vCustomLogin.hidden = NO;
    } else if (v_register.hidden == NO)
    {
        v_register.hidden = YES;
        vCustomLogin.hidden = NO;
    }
}

- (void) signInFirebase: (NSString *) accessToken
{
    FIRAuthCredential *credential = [FIRFacebookAuthProvider credentialWithAccessToken:accessToken];
    
    [self gotoMainViewController: credential];
    
}

- (void) gotoMainViewController: (FIRAuthCredential *) credential
{
    NSLog(@"--------- %@", credential);
    [[FIRAuth auth] signInWithCredential: credential completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        button.userInteractionEnabled = YES;
        hud.hidden = YES;
        if (error) {
            [self showMessagePrompt: error.localizedDescription];
            tf_emailCustomLogin.text = @"";
            tf_passwordCustomLogin.text = @"";
        } else
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *uid = [[[FIRAuth auth] currentUser] uid];
            [defaults setObject:uid forKey:@"uid"];
            [defaults synchronize];
            
            MainTabBarController *mLogin = [self.storyboard instantiateViewControllerWithIdentifier: @"mainActivity"];
            [self.navigationController pushViewController: mLogin animated: YES];
        }
    }];
    
   
}

- (IBAction)didSelectOtherSignin:(id)sender {
    vCustomLogin.hidden = NO;
    btn_back.hidden = NO;
}

- (IBAction)didSelectSigninWithGoogle:(id)sender {
    button.userInteractionEnabled = NO;
    [[GIDSignIn sharedInstance] signIn];
}

#pragma mark CustomLogin

- (IBAction)didSelectLogin:(id)sender {
    NSString *mEmail = tf_emailCustomLogin.text;
    NSString *mPassword = tf_passwordCustomLogin.text;
    
    if (mEmail != nil && mPassword != nil) {
        
        if ([self NSStringIsValidEmail: mEmail]) {
            FIRAuthCredential *credential = [FIREmailAuthProvider credentialWithEmail: mEmail password: mPassword];
            [self gotoMainViewController:credential];
            
            
        } else
        {
            [self showMessagePrompt: @"Email is invalid."];
        }
    }
    
    
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
   BOOL stricterFilter = NO;
   NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
   NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
   NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
   NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
   return [emailTest evaluateWithObject:checkString];
}


- (IBAction)didSelectForgotPassword:(id)sender {
    v_forgotpassword.hidden = NO;
    vCustomLogin.hidden = YES;
}

- (IBAction)sendPasswordWithEmail:(id)sender {
    NSString *mEmail = tf_emailForgotPassword.text;
    if (mEmail != nil) {
        if ([self NSStringIsValidEmail: mEmail]) {
            [[FIRAuth auth] sendPasswordResetWithEmail: mEmail completion:^(NSError * _Nullable error) {
                if (error) {
                    [self showMessagePrompt: error.localizedDescription];
                } else
                {
                    v_forgotpassword.hidden = YES;
                
                }
            }];
        } else
        {
            [self showMessagePrompt: @"Email is invalid."];
        }
    } else
    {
        [self showMessagePrompt: @"Please fill in the blank."];
    }
    
}

- (IBAction)goToRegister:(id)sender {
    
    v_register.hidden = NO;
    vCustomLogin.hidden = YES;
}

#pragma mark Register

- (IBAction)didSelectRegister:(id)sender {
    
    NSString *mEmail = tf_emailRegister.text;
    NSString *mPassword = tf_passwordRegister.text;
    NSString *mUserName = tf_userName.text;
    
    if (mEmail != nil && mPassword != nil && mUserName != nil) {
        
        if ([self NSStringIsValidEmail: mEmail]) {
            [[FIRAuth auth] createUserWithEmail: mEmail password:mPassword completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                if (error) {
                    [self showMessagePrompt:error.localizedDescription];
                } else
                {
                    NSString *currentUserID = [[FIRAuth auth] currentUser].uid;
                    NSString *currentEmail = [[FIRAuth auth] currentUser].email;
                    
                    [self storeEmail: currentEmail userID:currentUserID];
                    
                    dicToStoreInFirebaseUser = [NSDictionary dictionaryWithObjectsAndKeys:
                                                currentEmail, @"user_email",
                                                mUserName, @"user_name",
                                                nil];
                    
                    [[dbRef child: currentUserID] setValue: dicToStoreInFirebaseUser];
                    v_register.hidden = YES;
                    [self showMessagePrompt: @"User registered successfully."];
                }
            }];
        } else
        {
            [self showMessagePrompt: @"Email is invalid."];
        }
    }
    
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    
    if (error == nil) {
        
        [self showLoading: @"Signing in..."];
        GIDAuthentication *authentication = user.authentication;
        FIRAuthCredential *credential =
        [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken
                                         accessToken:authentication.accessToken];
        
        [self gotoMainViewController:credential];
        
    } else {
        button.userInteractionEnabled = YES;
        // ...
        [self showMessagePrompt:error.localizedDescription];
    }
}

- (void) showLoading: (NSString *) message
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = message;
}

- (void) storeEmail: (NSString *) mEmail userID: (NSString *) mUserID
{
    // store the credential to remove current user later
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:mEmail forKey:@"userEmail"];
    [userdefaults setObject: mUserID forKey: @"user_id"];
    [userdefaults synchronize];
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
//    if (error == nil) {
//        [[GIDSignIn sharedInstance] signIn];
//    } else
//    {
//        [self showMessagePrompt:error.localizedDescription];
//    }
    
    
}
@end
