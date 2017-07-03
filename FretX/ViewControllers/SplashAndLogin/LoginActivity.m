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
}
@end

@implementation LoginActivity

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    vCustomLogin.hidden = YES;
    v_register.hidden = YES;
    v_forgotpassword.hidden = YES;
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    dbRef = [[[FIRDatabase database] reference] child: @"users"];
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
            
            [ToastHelper showLoading: self.view message: @"Logging in..."];
            
            if ([FBSDKAccessToken currentAccessToken]) {
                
                [self signInFirebase: [FBSDKAccessToken currentAccessToken].tokenString];
                
            }
            
            
        }
    }];
    
}

- (void) signInFirebase: (NSString *) accessToken
{
    FIRAuthCredential *credential = [FIRFacebookAuthProvider credentialWithAccessToken:accessToken];
    
    
    
    [[FIRAuth auth] signInWithCredential:credential completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        [ToastHelper hideLoading];
        if (error) {
            [self showMessagePrompt:error.localizedDescription];
            NSLog(@"Error %@", error.localizedDescription);
        } else
        {
            button.userInteractionEnabled = YES;
            
            NSString *currentUserID = [[FIRAuth auth] currentUser].uid;
            NSString *currentEmail = [[FIRAuth auth] currentUser].email;
            NSString *userName = [[FIRAuth auth] currentUser].displayName;
            
            [self storeEmail: currentEmail userID:currentUserID];
            
            dicToStoreInFirebaseUser = [NSDictionary dictionaryWithObjectsAndKeys:
                                        currentEmail, @"user_email",
                                        accessToken, @"access_token",
                                        userName, @"user_name",
                                        nil];
            
            [[dbRef child: currentUserID] setValue: dicToStoreInFirebaseUser];
            [self gotoMainViewController];
            
        }
    }];
}

- (void) gotoMainViewController
{
    MainTabBarController *mLogin = [self.storyboard instantiateViewControllerWithIdentifier: @"mainActivity"];
    [self.navigationController pushViewController: mLogin animated: YES];
   
}

- (IBAction)didSelectOtherSignin:(id)sender {
    vCustomLogin.hidden = NO;
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
            [[FIRAuth auth] signInWithEmail:mEmail password:mPassword completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                if (error) {
                    [self showMessagePrompt: error.localizedDescription];
                    tf_emailCustomLogin.text = @"";
                    tf_passwordCustomLogin.text = @"";
                } else
                {
                    [self gotoMainViewController];
                }
            }];
            
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
        
        [ToastHelper showLoading: self.view message: @"Signing in..."];
        GIDAuthentication *authentication = user.authentication;
        FIRAuthCredential *credential =
        [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken
                                         accessToken:authentication.accessToken];
        
        
        [[FIRAuth auth] signInWithCredential:credential completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
            button.userInteractionEnabled = YES;
            if (error) {
                [self showMessagePrompt:error.localizedDescription];
            } else
            {
                NSString *currentUserID = [[FIRAuth auth] currentUser].uid;
                NSString *currentEmail = [[FIRAuth auth] currentUser].email;
                NSString *userName = [[FIRAuth auth] currentUser].displayName;
                [self storeEmail: currentEmail userID:currentUserID];
                
                dicToStoreInFirebaseUser = [NSDictionary dictionaryWithObjectsAndKeys:
                                            currentEmail, @"user_email",
                                            authentication.idToken, @"id_token",
                                            authentication.accessToken, @"access_token",
                                            userName, @"user_name",
                                            nil];
                [[dbRef child: currentUserID] setValue: dicToStoreInFirebaseUser];
                [self gotoMainViewController];
            }
        }];
        
    } else {
        button.userInteractionEnabled = YES;
        // ...
        [self showMessagePrompt:error.localizedDescription];
    }
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
