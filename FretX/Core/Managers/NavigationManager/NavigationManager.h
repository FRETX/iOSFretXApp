//
//  NavigationManager.h
//  FretX
//
//  Created by Developer on 7/7/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NavigationManager : NSObject

+ (instancetype)defaultManager;

@property (assign) BOOL needToOpenPreviewScreen;

@end
