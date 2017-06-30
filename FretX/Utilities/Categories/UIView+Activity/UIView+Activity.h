//
//  UIView+Activity.h
//  OnCall
//
//  Created by Serg Shulga on 2/28/14.
//  Copyright (c) 2014 TecSynth. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

@interface UIView (Activity)

- (void) showActivity;
- (void) hideActivity;
- (BOOL) hasActivity;

- (void) showActivityOnMainWindow;
- (void) hideActivityOnMainWindow;
- (BOOL) hasActivityOnMainWindow;
@end
