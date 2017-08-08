//
//  ContentManager.h
//  FretX
//
//  Created by Developer on 7/7/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SongPunch+AudioProcessing.h"

@class Lesson,Melody,SongPunch,ChordExercise;

typedef void (^GuidedExercisesBlock)(BOOL status, NSArray<ChordExercise*>* guidedExercises);

@interface ContentManager : NSObject

+ (instancetype)defaultManager;

//@property (copy) void(^tapNextVideoForSelectedBlock)(Lesson* currentLesson);

#pragma mark - Songs

- (void)getAllSongsWithBlock:(void(^)(NSArray<Melody*>* result, NSError *error))block;

- (void)getLessonForSong:(Melody*)song withBlock:(void(^)(Lesson* lesson, NSError *error))block;

- (void)nextLessonForLesson:(Lesson*)currentLesson withBlock:(void(^)(Lesson* lesson, NSError *error))block;

- (void)searchSongsForTitle:(NSString*)title withBlock:(void(^)(NSArray<Melody*>* result, NSError *error))block;

#pragma mark - Learn

- (NSArray<SongPunch*>*)allChords;
- (NSArray<NSString*>*)allChordRoots;
- (NSArray<NSString*>*)allChordTypes;
- (NSArray<NSString*>*)allScaleRoots;
- (NSArray<NSString*>*)allScaleTypes;

#pragma mark - Guided Exercises

//- (NSArray<ChordExercise*>*)defaultChordsExercises;
- (void)defaultChordsExercisesWithResultBlock:(GuidedExercisesBlock)block;

- (void)saveTime:(float)time forGuidedExercise:(ChordExercise*)chordExercise block:(void(^)(BOOL status))block;

- (void)loadUserProgressWithBlock:(void(^)(BOOL status, NSUInteger exercisesPassed))block;

#pragma mark - Custom Exercises

- (NSArray<ChordExercise*>*)customChordsExercises;
- (void)saveCustomChords:(NSArray<ChordExercise*>*)chordExercises;

- (ChordExercise*)newEmptyChordExercise;

@end
