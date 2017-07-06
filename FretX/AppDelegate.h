//
//  AppDelegate.h
//  FretX
//
//  Created by Developer on 6/28/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) NSString *mUserName;
@property (nonatomic, retain) UIImage *mProfile;
- (void) initialize;
@end

