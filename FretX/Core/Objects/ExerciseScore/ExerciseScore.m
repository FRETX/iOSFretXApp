//
//  ExerciseScore.m
//  FretX
//
//  Created by Developer on 8/3/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "ExerciseScore.h"

#import "SafeCategories.h"

@interface ExerciseScore ()

@property (nonatomic, strong) NSString* exerciseID;

@end

@implementation ExerciseScore

//exerciseID;
//scoreValue;

+ (instancetype)initWithExerciseID:(NSString*)exerciseID scroreValue:(NSString*)scoreValue{
    
    ExerciseScore* exerciseScore = [ExerciseScore new];
    if (exerciseScore) {
        exerciseScore.exerciseID = exerciseID;
        exerciseScore.scoreValue = scoreValue;
    }
    return exerciseScore;
}

- (NSString*)newScoreWithIntervalSeconds:(float)seconds{
    
    NSString* newScore = [NSString stringWithFormat:@"%f",seconds];
    NSString* allScores = [NSString stringWithFormat:@"%@ %@",self.scoreValue, newScore];
    return allScores;
}

@end
