//
//  ChordExercise.h
//  FretX
//
//  Created by Developer on 7/11/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SongPunch.h"

@interface ChordExercise : NSObject

@property (assign) int exerciseID;
@property (strong) NSString* exerciseName;
@property (strong,readonly) NSMutableArray<SongPunch*>* chords;
@property (assign) NSUInteger repetitionsCount;

+ (instancetype)exerciseWithDictionary:(NSDictionary*)dictionary;
- (SongPunch*)chordNextToChord:(SongPunch*)chord;

- (void)addChord:(SongPunch*)chord;
- (void)removeChord:(SongPunch*)chord;

- (NSDictionary*)plistValues;

@end
