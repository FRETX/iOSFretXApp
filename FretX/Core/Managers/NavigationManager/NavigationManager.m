//
//  NavigationManager.m
//  FretX
//
//  Created by Developer on 7/7/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "NavigationManager.h"

@implementation NavigationManager

+ (instancetype)defaultManager{
    
    static NavigationManager *navigationManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        navigationManager = [NavigationManager new];
    });
    return navigationManager;
}



@end
