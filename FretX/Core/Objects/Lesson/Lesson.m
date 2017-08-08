//
//  Lesson.m
//  FretX
//
//  Created by Developer on 6/29/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "Lesson.h"

#import <FretXAudioProcessing/FretXAudioProcessing.h>

#import "SafeCategories.h"
#import "SongPunch.h"
#import <FretXAudioProcessing/FretXAudioProcessing-Swift.h>


@implementation Lesson

- (void)setValuesWithInfo:(NSDictionary*)info{
    
    self.melodyTitle = [info safeStringObjectForKey:@"title"];
    self.songName = [info safeStringObjectForKey:@"song_title"];
    self.artistName = [info safeStringObjectForKey:@"artist"];
    self.backendID = [info safeStringObjectForKey:@"id"];
    self.youtubeVideoId = [info safeStringObjectForKey:@"youtube_id"];
    self.fretxID = [info safeStringObjectForKey:@"fretx_id"];
    
    self.punches = [self chordsWithInfo:info];
}

- (NSArray*)chordsWithInfo:(NSDictionary*)info{
    
    NSMutableArray<SongPunch*>* mutChords = [NSMutableArray new];
    NSArray<NSDictionary*>* punchesInfo = [info safeArrayObjectForKey:@"punches"];
    [punchesInfo enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SongPunch* chord =  [SongPunch new];
        [chord setValues:obj];
        chord.index = idx;
        [mutChords addObject:chord];
    }];
    
    NSArray* chords = [NSArray arrayWithArray:mutChords];
    return chords;
}

- (SongPunch*)chordNextToChord:(SongPunch*)chord allowEmpty:(BOOL)allowEmpty{
    
    if (!chord)
        return nil;
    
    NSUInteger nextIndex = chord.index + 1;
    SongPunch* nextChord;
    while (!nextChord && nextIndex < self.punches.count) {
        
        SongPunch* chord = [self.punches objectAtIndex:nextIndex];
        if ((!chord.isEmpty && !allowEmpty) || (allowEmpty))
            nextChord = [self.punches objectAtIndex:nextIndex];
        else
            nextIndex++;
    }
    
//    SongPunch* nexthord;
//    if (chord && chord.index < (self.punches.count-1)) {
//        NSUInteger nextIndex = chord.index + 1;
//        nexthord = [self.punches objectAtIndex:nextIndex];
//    }
    return nextChord;
}

- (SongPunch*)chordClosestToTime:(float)time{
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"self.timeMs <= %f",time];
    NSArray* filteredArray = [self.punches filteredArrayUsingPredicate:predicate];
    
    if (filteredArray.count <= 0)
        return nil;
    
    NSSortDescriptor* descriptor = [NSSortDescriptor sortDescriptorWithKey:@"timeMs" ascending:YES];
    NSArray* sortedArray = [filteredArray sortedArrayUsingDescriptors:@[descriptor]];
    
    if (sortedArray.count <= 0)
        return nil;
    
    SongPunch* clossestChord = sortedArray.lastObject;
    SongPunch* resultChord = [self chordNextToChord:clossestChord allowEmpty:YES];

//    if (resultChord)
//        return resultChord;
//    else
        return clossestChord;
}

- (NSMutableArray<Chord *>*)getUniqueChords{
    NSMutableSet<Chord *> *uniqueChords = [[NSMutableSet alloc] init];
    for (SongPunch *sp in self.punches) {
        Chord *tmpChord = [[Chord alloc] initWithRoot:sp.root type:sp.quality];
        if(![tmpChord.getRoot isEqualToString:@""]){
            [uniqueChords addObject:tmpChord];
        }
    }
    
    NSMutableArray<Chord *> *chords = [[NSMutableArray alloc] init];
    
    for (Chord* ch in uniqueChords) {
        [chords addObject:ch];
    }
    
    return chords;
}



@end
