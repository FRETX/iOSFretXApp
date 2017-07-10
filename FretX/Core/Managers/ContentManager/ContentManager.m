//
//  ContentManager.m
//  FretX
//
//  Created by Developer on 7/7/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "ContentManager.h"

#import "RequestManager.h"
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
