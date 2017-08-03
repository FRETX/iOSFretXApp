//
//  DataBaseManager.h
//  FretX
//
//  Created by Developer on 8/3/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface DataBaseManager : NSObject

+ (instancetype)defaultManager;

- (void)fetchUserWithBlock:(void(^)(BOOL status, User* user))block;

- (void)saveUserScore:(NSString*)scoreValue forExerciseID:(NSString*)exerciseID;

@end
