//
//  LoginActivity.h
//  FretX
//
//  Created by P1 on 6/28/17.
//  Copyright © 2017 rocks.fretx. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleSignIn;
@import Firebase;
@import FBSDKCoreKit;
@import FBSDKLoginKit;

@interface LoginActivity : UIViewController <GIDSignInUIDelegate, GIDSignInDelegate>

@end
