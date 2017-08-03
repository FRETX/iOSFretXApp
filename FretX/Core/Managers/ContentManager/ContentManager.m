//
//  ContentManager.m
//  FretX
//
//  Created by Developer on 7/7/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "ContentManager.h"

#import <FretXAudioProcessing/FretXAudioProcessing-Swift.h>
#import <FretXBLE/FretXBLE-Swift.h>
#import <Firebase/Firebase.h>

#import "DataBaseManager.h"
#import "ChordExercise.h"
#import "RequestManager.h"
#import "SafeCategories.h"
#import "Melody.h"
#import "Lesson.h"
#import "User.h"

@interface ContentManager ()

@property (nonatomic, strong) NSArray<Melody*>* allSongs;

@end

@implementation ContentManager


+ (instancetype)defaultManager{
    
    static ContentManager *contentManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        contentManager = [ContentManager new];
    });
    return contentManager;
}

#pragma mark - Public

#pragma mark - Songs

- (void)getAllSongsWithBlock:(void(^)(NSArray<Melody*>* result, NSError *error))block{
    
    __weak typeof(self) weakSelf = self;
    [[RequestManager defaultManager] loadAllMelodiesWithBlock:^(NSArray<Melody*>* result, NSError *error) {
        
        NSArray<Melody*>* sortedResult;
        if (!error) {
            sortedResult = [weakSelf sortedSongsByCreationDateWithArray:result];
            self.allSongs = sortedResult;
        }
        
        if (block) {
            block(sortedResult, error);
        }
    }];
}

- (void)getLessonForSong:(Melody*)song withBlock:(void(^)(Lesson* lesson, NSError *error))block{
    
    if (!song) {
        if (block)
            block(nil, nil);
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [[RequestManager defaultManager] getLessonForMelody:song withBlock:^(Lesson* lesson, NSError *error) {
        
        if (lesson) {
            lesson.nextLessonYoutubeID = [weakSelf nextLessonYoutubeIDAfterLesson:lesson];
        }
        if (block) {
            block(lesson, error);
        }
    }];
}

- (void)nextLessonForLesson:(Lesson*)currentLesson withBlock:(void(^)(Lesson* lesson, NSError *error))block{
    
    Melody* nextSong = [self nextSongAfterLesson:currentLesson];
    if (!nextSong) {
        if (block)
            block(nil, nil);
        return;
    }
    [self getLessonForSong:nextSong withBlock:^(Lesson *lesson, NSError *error) {
        
        if (block) {
            block(lesson, error);
        }
    }];
}

- (void)searchSongsForTitle:(NSString*)title withBlock:(void(^)(NSArray<Melody*>* result, NSError *error))block{
    
    if (self.allSongs.count > 0){
        if (block) {
            NSArray* searchedResult = [self searchSongsForTitle:title];
            block(searchedResult, nil);
        }
    } else{
        [self getAllSongsWithBlock:^(NSArray<Melody *> *result, NSError *error) {
            
            if (!error && result.count > 0) {
                if (block) {
                    NSArray* searchedResult = [self searchSongsForTitle:title];
                    block(searchedResult, nil);
                }
            } else{
                block(nil, nil);
            }
        }];
    }
}
#pragma mark -
#pragma mark - Learn
#pragma mark -

- (NSArray<SongPunch*>*)allChords{
    
    
    
    return nil;
}

- (NSArray<NSString*>*)allChordRoots{
    
    NSArray<NSString*>* allChordRoots = [Chord ALL_ROOT_NOTES];
    return allChordRoots;
}

- (NSArray<NSString*>*)allChordTypes{
    
    NSArray<NSString*>* allChordTypes = [Chord ALL_CHORD_TYPES];
    return allChordTypes;
}

- (NSArray<NSString*>*)allScaleRoots{
    
    NSArray<NSString*>* allScaleRoots = [Scale ALL_ROOT_NOTES];
    return allScaleRoots;
}

- (NSArray<NSString*>*)allScaleTypes{
    
    NSArray<NSString*>* allScaleTypes = [Scale ALL_SCALE_TYPES];
    return allScaleTypes;
}

#pragma mark - Guided Exercises

- (void)defaultChordsExercisesWithResultBlock:(GuidedExercisesBlock)block{
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"GuidedChordExercises" ofType:@"json"];
//    NSArray<ChordExercise*>* chordsExercises = [self defaultChordsExercisesFromPath:filePath];
//    return chordsExercises;
    
    [[RequestManager defaultManager] getGuidedExercisesInfoWithBlock:^(NSArray* object, NSError *error) {
        
        if (block){
            
            if (object && !error) {
                
                NSArray<ChordExercise*>* guidedExercises = [self defaultChordsExercisesFromInfo:object];
                
                block(YES,guidedExercises);
                
            } else {
                block(NO,nil);
            }
        }
    }];
}

- (void)saveTime:(float)time forGuidedExercise:(ChordExercise*)chordExercise block:(void(^)(BOOL status))block{
    
    if (chordExercise.guided){
        
        [[DataBaseManager defaultManager] fetchUserWithBlock:^(BOOL status, User *user) {
            
            NSString* exerciseID = chordExercise.exerciseID;
            NSString* scoresValue = user.scores[exerciseID];
            if (block && exerciseID.length > 0) {
                
                NSString* stringTime = [NSString stringWithFormat:@"%d", (int)time];
                if (scoresValue.length > 0) {
                    stringTime = [NSString stringWithFormat:@"%@ %d", scoresValue,(int)time];
                }
                
                [[DataBaseManager defaultManager] saveUserScore:stringTime forExerciseID:chordExercise.exerciseID];
                
                block(status);
            } else{
                block(NO);
            }
        }];
    }
}

- (void)loadUserProgressWithBlock:(void(^)(BOOL status, NSUInteger exercisesPassed))block{
    
    [[DataBaseManager defaultManager] fetchUserWithBlock:^(BOOL status, User *user) {
        
        if (block) {
            block(status, user.exercisesPassed);
        }
    }];
}

#pragma mark - Custom Exercises

- (NSArray<ChordExercise*>*)customChordsExercises{
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CustomExercises" ofType:@"plist"];
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"CustomExercises"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSArray<ChordExercise*>* chordsExercises = [self customChordsExercisesFromFile];
        
        NSSortDescriptor* desc = [NSSortDescriptor sortDescriptorWithKey:@"exerciseID" ascending:NO];
        NSArray<ChordExercise*>* sortedChordsExercises = [chordsExercises sortedArrayUsingDescriptors:@[desc]];
        
        return sortedChordsExercises;
    } else{
        return nil;
    }
}

- (void)saveCustomChords:(NSArray<ChordExercise*>*)chordExercises{
    
    NSMutableArray* mutChordsExercises = [NSMutableArray new];
    
    [chordExercises enumerateObjectsUsingBlock:^(ChordExercise * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDictionary* exerciseValues = [obj plistValues];
        [mutChordsExercises addObject:exerciseValues];
    }];
    
    NSArray<NSDictionary*>* chordExercisesInfos = [NSArray arrayWithArray:mutChordsExercises];
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"CustomExercises"];

    BOOL success = [chordExercisesInfos writeToFile:path atomically:YES];
//    if (success)
//        NSLog(@"exercises saved");
//    else
//        NSLog(@"exercises not saved");
}

#pragma mark -
#pragma mark - Private
#pragma mark -

#pragma mark - Custom exercises

- (NSArray<ChordExercise*>*)customChordsExercisesFromFile{
    
    NSString *fileName = @"/CustomExercises";
    NSURL *documentsFolderURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString *filePath = [documentsFolderURL.path stringByAppendingString:fileName];
    
    NSArray<NSDictionary*>* jsonArray = [NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray* mutResult = [NSMutableArray new];
    [jsonArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull exerciseInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ChordExercise* chordExercise = [ChordExercise exerciseWithDictionary:exerciseInfo];
        [mutResult addObject:chordExercise];
    }];
    
    NSArray<ChordExercise*>* chordsExercises = [NSArray arrayWithArray:mutResult];
    return chordsExercises;
    
    return chordsExercises;
}

#pragma mark - Guided exercises

- (NSArray<ChordExercise*>*)defaultChordsExercisesFromInfo:(NSArray<NSDictionary*>*)info{
    
    NSMutableArray* mutResult = [NSMutableArray new];

    [info enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull exerciseInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ChordExercise* chordExercise = [ChordExercise exerciseWithDictionary:exerciseInfo];
        [mutResult addObject:chordExercise];
    }];
    
    NSArray<ChordExercise*>* chordsExercises = [NSArray arrayWithArray:mutResult];
    return chordsExercises;
}

//- (NSArray<ChordExercise*>*)defaultChordsExercisesFromPath:(NSString*)filePath{
//    
//    NSMutableArray* mutResult = [NSMutableArray new];
//    
//    //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CustomExercises" ofType:@"plist"];
//    NSData *data = [NSData dataWithContentsOfFile:filePath];
//    NSError* error = nil;
//    NSArray<NSDictionary*> *exercises = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];//NSJSONReadingAllowFragments //kNilOptions
//    
//    [exercises enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull exerciseInfo, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        ChordExercise* chordExercise = [ChordExercise exerciseWithDictionary:exerciseInfo];
//        [mutResult addObject:chordExercise];
//    }];
//    
//    NSArray<ChordExercise*>* chordsExercises = [NSArray arrayWithArray:mutResult];
//    return chordsExercises;
//}



#pragma mark -

- (NSArray<Melody*>*)searchSongsForTitle:(NSString*)title{
    NSArray* filteredArray = [self filteredSongsByTitle:title];
    NSArray* sortedResult = [self sortedSongsByCreationDateWithArray:filteredArray];
    return sortedResult;
}

- (NSArray<Melody*>*)filteredSongsByTitle:(NSString*)title{
    
    if (!title || title.length <= 0) {
        return self.allSongs;
    } else {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"self.songTitle contains[c] %@",title];
        NSArray<Melody*>* filteredArray = [self.allSongs filteredArrayUsingPredicate:predicate];
        return filteredArray;
    }
}

- (NSArray<Melody*>*)sortedSongsByCreationDateWithArray:(NSArray<Melody*>*)array{
    
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO];
    NSArray* sortedArray = [array sortedArrayUsingDescriptors:@[sortDescriptor]];
    return sortedArray;
}

- (NSString*)nextLessonYoutubeIDAfterLesson:(Lesson*)lesson{
    
    Melody* nextSong = [self nextSongAfterLesson:lesson];
    if (nextSong) {
        return nextSong.youtubeVideoId;
    } else{
        return self.allSongs.firstObject.youtubeVideoId;
    }
}

- (Melody*)nextSongAfterLesson:(Lesson*)lesson{
    
    NSString* lessonFretxID = lesson.fretxID;
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"self.fretxID like[c] %@",lessonFretxID];
    NSArray* filteredArray = [self.allSongs filteredArrayUsingPredicate:predicate];
    
    Melody* song;
    if (filteredArray.count > 0) {
        song = filteredArray.firstObject;
    }
    
    NSUInteger nextSongIndex = [self.allSongs indexOfObject:song] + 1;
    if (song && nextSongIndex < self.allSongs.count) {
        Melody* nextSong = [self.allSongs objectAtIndex:nextSongIndex];
        return nextSong;
    } else{
        return self.allSongs.firstObject;
    }
}


@end
