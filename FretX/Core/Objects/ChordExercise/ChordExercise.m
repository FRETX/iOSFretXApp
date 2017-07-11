//
//  ChordExercise.m
//  FretX
//
//  Created by Developer on 7/11/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "ChordExercise.h"

#import <FretXAudioProcessing/FretXAudioProcessing-Swift.h>

#import "SafeCategories.h"
#import "SongPunch.h"
#import "SongPunch+AudioProcessing.h"

@implementation ChordExercise

//    {
//        "name" : "Exercise 1",
//        "id": "",
//        "chords" : [
//                    {
//                        "root": "C",
//                        "type" : "maj7"
//                    },
//                    {
//                        "root": "D",
//                        "type" : "sus2"
//                    }
//                    ],
//        "nRepetitions" : 10
//    },

+ (NSArray<ChordExercise*>*)exercisesFromDictionary:(NSDictionary*)dictionary{
    
    NSArray<ChordExercise*>* exercises = nil;
    
    return exercises;
}

+ (instancetype)exerciseWithDictionary:(NSDictionary*)dictionary{
    
    ChordExercise* chordExercise = [ChordExercise new];
    [chordExercise setValuesWithInfo:dictionary];
    return chordExercise;
}

- (void)setValuesWithInfo:(NSDictionary*)info{
    
    self.exerciseName = [info safeStringObjectForKey:@"name"];
    
    NSNumber* repeats = [info safeNSNumberObjectForKey:@"nRepetitions"];
    self.repetitionsCount = repeats.unsignedIntegerValue;
    
    NSArray* chordsInfos = [info safeArrayObjectForKey:@"chords"];
    self.chords = [self chordsWithDictionary:chordsInfos];
    
}

- (NSArray<SongPunch*>*)chordsWithDictionary:(NSArray<NSDictionary*>*)chordsInfos{
    
    NSMutableArray* mutResult = [NSMutableArray new];
    [chordsInfos enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull chordInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString* root = [chordInfo safeStringObjectForKey:@"root"];
        NSString* type = [chordInfo safeStringObjectForKey:@"type"];
        SongPunch* chord = [SongPunch initChordWithRoot:root type:type];
        chord.index = idx;
        
        [mutResult addObject:chord];
    }];
    
    NSArray<SongPunch*>* result = [NSArray arrayWithArray:mutResult];
    
    return result;

}

- (SongPunch*)chordNextToChord:(SongPunch*)chord{
    
    SongPunch* nexthord;
    if (chord && chord.index < (self.chords.count-1)) {
        NSUInteger nextIndex = chord.index + 1;
        nexthord = [self.chords objectAtIndex:nextIndex];
    }
    return nexthord;
}


@end
