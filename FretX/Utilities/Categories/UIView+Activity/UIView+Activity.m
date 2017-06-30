//
//  UIView+Activity.m
//  OnCall
//
//  Created by Serg Shulga on 2/28/14.
//  Copyright (c) 2014 TecSynth. All rights reserved.
//

#import "UIView+Activity.h"

#define ACTIVITY_TAG 599

@implementation UIView (Activity)

- (void) showActivity
{
    if (![self viewWithTag: ACTIVITY_TAG])
    {
        UIView* activity = [[UIView alloc] initWithFrame: self.bounds];
        activity.alpha = 0.5;
        activity.backgroundColor = [UIColor grayColor];
        activity.tag = ACTIVITY_TAG;
        activity.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.center = activity.center;
        
        [activity addSubview: indicator];
        
        [indicator startAnimating];
        
        [self addSubview: activity];
    }
    else
    {
        [self bringSubviewToFront: [self viewWithTag: ACTIVITY_TAG]];
    }
}


- (void) showActivityOnMainWindow
{
    AppDelegate *del = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (![self viewWithTag: ACTIVITY_TAG])
    {
        UIView* activity = [[UIView alloc] initWithFrame: self.bounds];
        activity.alpha = 0.5;
        activity.backgroundColor = [UIColor grayColor];
        activity.tag = ACTIVITY_TAG;
        activity.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.center = activity.center;
        
        [activity addSubview: indicator];
        
        [indicator startAnimating];
        
        [del.window addSubview: activity];
    }
    else
    {
        [del.window bringSubviewToFront: [del.window viewWithTag: ACTIVITY_TAG]];
    }
    
}

- (BOOL) hasActivityOnMainWindow
{
    AppDelegate *del = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return [del.window viewWithTag: ACTIVITY_TAG] != nil;
}


- (void) hideActivityOnMainWindow
{
    AppDelegate *del = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [[del.window viewWithTag: ACTIVITY_TAG] removeFromSuperview];
    //[[self viewWithTag: ACTIVITY_TAG] removeFromSuperview];
}

- (void) hideActivity
{
    [[self viewWithTag: ACTIVITY_TAG] removeFromSuperview];
}

- (BOOL) hasActivity
{
    return [self viewWithTag: ACTIVITY_TAG] != nil;
}

@end
