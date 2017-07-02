//
//  ToastHelper.h
//  FretX
//
//  Created by P1 on 7/1/17.
//  Copyright © 2017 rocks.fretx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ToastHelper : NSObject

+ (void) showToast: (NSString *) message;
+ (void) showLoading: (UIView *) view message : (NSString *) message;
+ (void) hideLoading;

@end
