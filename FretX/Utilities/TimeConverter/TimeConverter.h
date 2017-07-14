//
//  TimeConverter.h
//  FretX
//
//  Created by Developer on 7/14/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeConverter : NSObject


+ (NSString*)durationStringFromSeconds:(float)audioDurationSeconds;

@end
