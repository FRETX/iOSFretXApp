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
#import <FretXAudioProcessing/FretXAudioProcessing-Swift.h>

@interface ChordExercise ()

@property (strong) NSMutableArray<SongPunch*>* chords;

@end

@implementation ChordExercise

- (id)init{
    self = [super init];
    if (self) {
        self.chords = [NSMutableArray new];
    }
    return self;
}

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


//{
//    children =     (
//                    {
//                        id = e14;
//                    }
//                    );
//    chords =     (
//                  {
//                      root = G;
//                      type = maj;
//                  },
//                  {
//                      root = A;
//                      type = m;
//                  }
//                  );
//    id = e13;
//    nRepetitions = 10;
//    name = "Exercise 13";
//    youtubeId = "";
//},

+ (NSArray<ChordExercise*>*)exercisesFromDictionary:(NSDictionary*)dictionary{
    
    NSArray<ChordExercise*>* exercises = nil;
    
    return exercises;
}

+ (instancetype)exerciseWithDictionary:(NSDictionary*)dictionary{
    
    ChordExercise* chordExercise = [ChordExercise new];
    [chordExercise setValuesWithInfo:dictionary];
    
    NSArray* chordsInfos = [dictionary safeArrayObjectForKey:@"chords"];
    chordExercise.guided = dictionary && chordsInfos.count > 0 ? YES : NO;
    
    return chordExercise;
}

- (void)setValuesWithInfo:(NSDictionary*)info{
    
    self.exerciseID = [info safeStringObjectForKey:@"id"];
    self.youtubeId = [info safeStringObjectForKey:@"youtubeId"];
    
    self.exerciseName = [info safeStringObjectForKey:@"name"];
    
    NSNumber* repeats = [info safeNSNumberObjectForKey:@"nRepetitions"];
    self.repetitionsCount = repeats.unsignedIntegerValue;
    
    NSArray* chordsInfos = [info safeArrayObjectForKey:@"chords"];
    self.chords = [NSMutableArray arrayWithArray:[self chordsWithDictionary:chordsInfos]];
    
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
    
    NSUInteger curIndex = [self.chords indexOfObject:chord];
    NSUInteger nextIndex = curIndex + 1;
    if (nextIndex < self.chords.count) {
        SongPunch* nextChord = self.chords[nextIndex];
        return nextChord;
    } else{
        return nil;
    }
    
//    SongPunch* nexthord;
//    if (chord && chord.index < self.chords.count) {
//        NSUInteger nextIndex = chord.index + 1;
//        nexthord = [self.chords objectAtIndex:nextIndex-1];
//    }
//    return nexthord;
}

- (void)addChord:(SongPunch*)chord{
    
    
    NSSortDescriptor* descr = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    [self.chords sortUsingDescriptors:@[descr]];
    
    NSUInteger newIndex = self.chords.lastObject.index + 1;
    chord.index = newIndex;
    
    [self.chords addObject:chord];
}

- (void)removeChord:(SongPunch*)chord{
    
    if ([self.chords containsObject:chord]) {
        [self.chords removeObject:chord];
    }
    
}

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

- (NSDictionary*)plistValues{
    
    NSDictionary* values = @{ @"id" : self.exerciseID,
                              @"name" : self.exerciseName,
                              @"chords" : [self chordsDictionary],
                              @"nRepetitions" : @(self.repetitionsCount) };
    
    return values;
}

- (NSArray<Chord *>*)getUniqueAudioProcChords{
    NSMutableSet<Chord *> *uniqueChords = [[NSMutableSet alloc] init];
    for (SongPunch *sp in self.chords) {
        Chord *tmpChord = [[Chord alloc] initWithRoot:sp.root type:sp.quality];
        if(![tmpChord.getRoot isEqualToString:@""]){
            [uniqueChords addObject:tmpChord];
        }
    }
    
    NSArray<Chord *> *chords = [NSArray arrayWithArray:uniqueChords.allObjects];
    
    return chords;
}

#pragma mark - Private

- (NSArray*)chordsDictionary{
    
    NSMutableArray *result = [NSMutableArray new];
    
    [self.chords enumerateObjectsUsingBlock:^(SongPunch * _Nonnull chord, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDictionary* chordInfo = @{@"root" : chord.root, @"type" : chord.quality};
        [result addObject:chordInfo];
    }];
    
    if (result.count <= 0) {
        return @[];
    } else{
        return [NSArray arrayWithArray:result];
    }
}

#pragma mark -

- (NSString*)description{
    
    NSString* description = [NSString stringWithFormat:@"%@. Name = %@ ID = %@ chords.count = %ld",[super description],self.exerciseName, self.exerciseID, self.chords.count];
    return description;
}

@end
