//
//  ChordExercise.h
//  FretX
//
//  Created by Developer on 7/11/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SongPunch.h"
#import <FretXAudioProcessing/FretXAudioProcessing-Swift.h>

@class Chord;

@interface ChordExercise : NSObject

@property (strong) NSString* exerciseID;
@property (strong) NSString* youtubeId;
@property (strong) NSString* exerciseName;
@property (strong,readonly) NSMutableArray<SongPunch*>* chords;
@property (assign) NSUInteger repetitionsCount;

@property (assign) BOOL guided;//else custom

+ (instancetype)exerciseWithDictionary:(NSDictionary*)dictionary;
- (SongPunch*)chordNextToChord:(SongPunch*)chord;

- (void)addChord:(SongPunch*)chord;
- (void)removeChord:(SongPunch*)chord;

- (NSArray<Chord *>*)getUniqueChords;

- (NSDictionary*)plistValues;

- (NSArray<Chord *>*)getUniqueAudioProcChords;

@end
