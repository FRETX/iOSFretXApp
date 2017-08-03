//
//  User.m
//  FretX
//
//  Created by Developer on 8/3/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "User.h"

#import "SafeCategories.h"

@interface User ()

@end

@implementation User


//prefs =     {
//    guitar = classical;
//    hand = right;
//    level = beginner;
//};

- (void)setValuesWithInfo:(NSDictionary*)values{
    
    NSDictionary* prefs = [values safeDictionaryObjectForKey:@"prefs"];
    
    NSString *mHandedness = [prefs safeStringObjectForKey: @"hand"];
    if ([mHandedness isEqualToString: @"right"]) {
        self.handType = HandTypeRight;
    } else
        self.handType = HandTypeLeft;
    
    NSString *mGuitar = [prefs safeStringObjectForKey: @"guitar"];
    if ([mGuitar isEqualToString: @"classical"]) {
        self.guitarType = GuitarTypeClassical;
    } else if ([mGuitar isEqualToString: @"electric"])
        self.guitarType = GuitarTypeElectric;
    else
        self.guitarType = GuitarTypeAcoustic;
    
    
    NSString *mLevel = [prefs safeStringObjectForKey: @"level"];
    if ([mLevel isEqualToString: @"beginner"]) {
        self.skillType = SkillTypeBegginer;
    } else
        self.skillType = SkillTypePlayer;
    
    if ([values objectForKey:@"score"]) {
        NSDictionary* scores = [values safeDictionaryObjectForKey:@"score"];
        
        NSUInteger exercisesPassed = scores.allKeys.count > 0 ? scores.allKeys.count : 0;
        self.exercisesPassed = exercisesPassed + 1;
        
        self.scores = scores;
    } else {
        self.exercisesPassed = 1;
        self.scores = @{};
    }
    
}


@end
