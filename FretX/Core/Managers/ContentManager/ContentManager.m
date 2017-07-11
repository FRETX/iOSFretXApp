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

#import "ChordExercise.h"
#import "RequestManager.h"
#import "SafeCategories.h"
#import "Melody.h"
#import "Lesson.h"

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

#pragma mark - Learn

- (NSArray<SongPunch*>*)allChords{
    
    
    
    return nil;
}

- (NSArray<NSString*>*)allChordRoots{
    
    NSArray<NSString*>* allChordRoots = [Chord ALL_ROOT_NOTES];
    
//    : public static let ALL_ROOT_NOTES = @[@"A", @"Bb", @"B", @"C", @"C#", @"D", @"Eb", @"E", @"F", @"F#", @"G", @"G#"]
//    public static let ALL_CHORD_TYPES = @[@"maj", @"m", @"maj7", @"m7", @"5", @"7", @"9", @"sus2", @"sus4", @"7sus4", @"7#9", @"add9", @"aug", @"dim", @"dim7"]
//    
//    : public static let ALL_ROOT_NOTES = @["C", @"C#", @"D", @"Eb", @"E", @"F", @"F#", @"G", @"G#", @"A", @"Bb", @"B"]
//    public static let ALL_SCALE_TYPES = @["Major",@"Minor",@"Major Pentatonic",@"Minor Pentatonic",@"Blues",@"Melodic Minor",@"Ionian",@"Dorian",@"Phrygian",@"Lydian",@"Mixolydian",@"Aeolian",@"Locrian",@"Whole Tone"]
    
//    NSArray<NSString*>* allChordRoots = @[@"A", @"Bb", @"B", @"C", @"C#", @"D", @"Eb", @"E", @"F", @"F#", @"G", @"G#"];

    return allChordRoots;
}

- (NSArray<NSString*>*)allChordTypes{
    
    NSArray<NSString*>* allChordTypes = [Chord ALL_CHORD_TYPES];// @[@"maj", @"m", @"maj7", @"m7", @"5", @"7", @"9", @"sus2", @"sus4", @"7sus4", @"7#9", @"add9", @"aug", @"dim", @"dim7"];
    return allChordTypes;
}

- (NSArray<NSString*>*)allScaleRoots{
    
    NSArray<NSString*>* allScaleRoots = [Scale ALL_ROOT_NOTES];// @[@"C", @"C#", @"D", @"Eb", @"E", @"F", @"F#", @"G", @"G#", @"A", @"Bb", @"B"];//
    return allScaleRoots;
}

- (NSArray<NSString*>*)allScaleTypes{
    
    NSArray<NSString*>* allScaleTypes = [Scale ALL_SCALE_TYPES];// @[@"Major",@"Minor",@"Major Pentatonic",@"Minor Pentatonic",@"Blues",@"Melodic Minor",@"Ionian",@"Dorian",@"Phrygian",@"Lydian",@"Mixolydian",@"Aeolian",@"Locrian",@"Whole Tone"];//
    return allScaleTypes;
}

- (NSArray<ChordExercise*>*)defaultChordsExercises{
    
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
    
    NSMutableArray* mutResult = [NSMutableArray new];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"GuidedChordExercises" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray<NSDictionary*> *exercises = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    [exercises enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull exerciseInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ChordExercise* chordExercise = [ChordExercise exerciseWithDictionary:exerciseInfo];
        [mutResult addObject:chordExercise];
    }];
    
    NSArray<ChordExercise*>* chordsExercises = [NSArray arrayWithArray:mutResult];
    return chordsExercises;
}

#pragma mark - Private

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
