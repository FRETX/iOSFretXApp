//
//  ExerciseScore.h
//  FretX
//
//  Created by Developer on 8/3/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExerciseScore : NSObject

@property (nonatomic, strong, readonly) NSString* exerciseID;
@property (nonatomic, strong) NSString* scoreValue;

- (void)setValues:(NSDictionary*)values;

- (NSString*)newScoreWithIntervalSeconds:(float)seconds;

@end
