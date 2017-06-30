//
//  RequestManager.h
//  FretX
//
//  Created by Developer on 6/29/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Melody.h"

typedef void (^APIResultBlock)(id object, NSError* error);

@interface RequestManager : NSObject

+ (instancetype)defaultManager;

#pragma mark - Melodies

- (void)loadAllMelodiesWithBlock:(APIResultBlock)block;
- (void)getLessonForMelody:(Melody*)melody withBlock:(APIResultBlock)block;

@end
