//
//  AppDelegate.m
//  FretX
//
//  Created by Developer on 6/28/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@import Firebase;
@import GoogleSignIn;
@import Intercom;

#define INTERCOM_APP_ID  @"p1olv87a"
#define INTERCOM_API_KEY @"ios_sdk-c101e2d45892cf8c9d93f135a9475ac2e2dc7ea9"

#import <FretXAudioProcessing/FretXAudioProcessing.h>

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize mUserName, mProfile;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    [self initialize];
    [self setupSocialKeys];

    return YES;
}

- (void) initialize
{
    mProfile = nil;
    mUserName = nil;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject: nil forKey: @"uid"];
    [userDefaults setObject: nil forKey: @"login_type"];
    [userDefaults setObject: nil forKey: @"user_name"];
    [userDefaults setObject: nil forKey: @"user_email"];
    [userDefaults setObject: nil forKey: @"profile_image_data"];
    [userDefaults synchronize];
}

- (void) setupSocialKeys
{
    [FIRApp configure];
    
    
    [GIDSignIn sharedInstance].clientID = [FIRApp defaultApp].options.clientID;
    
    // intercom integrate
    
    [Intercom setApiKey:INTERCOM_API_KEY forAppId:INTERCOM_APP_ID];
    [Intercom setLauncherVisible:NO];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [application registerUserNotificationSettings:[UIUserNotificationSettings
                                                   settingsForTypes:(UIUserNotificationTypeBadge
                                                                     | UIUserNotificationTypeSound
                                                                     | UIUserNotificationTypeAlert)
                                                   categories:nil]];
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [Intercom setDeviceToken:deviceToken];
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    if(_isLanscapeMode)
        return UIInterfaceOrientationMaskLandscape;
    else
        return UIInterfaceOrientationMaskPortrait;
}

- (void)setIsLanscapeMode:(BOOL)isLanscapeMode {
    _isLanscapeMode = isLanscapeMode;
}

#pragma GoogleSignin
- (BOOL)application:(nonnull UIApplication *)application
            openURL:(nonnull NSURL *)url
            options:(nonnull NSDictionary<NSString *, id> *)options {
    return [self application:application
                     openURL:url
            // [START new_options]
           sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                  annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // This is the Facebook or Google+ SDK returning to the app after authentication.
    BOOL expressionValue = NO;
    if ([[GIDSignIn sharedInstance] handleURL:url
                            sourceApplication:sourceApplication
                                   annotation:annotation]) {
        expressionValue = YES;
    }
    
    if ([[FBSDKApplicationDelegate sharedInstance] application:application
                                                       openURL:url
                                             sourceApplication:sourceApplication
                                                    annotation:annotation]) {
        expressionValue = YES;
    }
    return expressionValue;
    
}

@end
