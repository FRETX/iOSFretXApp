//
//  Lesson.m
//  FretX
//
//  Created by Developer on 6/29/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "Lesson.h"

#import "SafeCategories.h"
#import "Chord.h"

@implementation Lesson

- (void)setValuesWithInfo:(NSDictionary*)info{
    
    
    self.songName = [info safeStringObjectForKey:@"song_title"];
    self.artistName = [info safeStringObjectForKey:@"artist"];
    self.backendID = [info safeStringObjectForKey:@"id"];
    self.youtubeVideoId = [info safeStringObjectForKey:@"youtube_id"];
    self.fretxID = [info safeStringObjectForKey:@"fretx_id"];
    
    self.punches = [self chordsWithInfo:info];
}

- (NSArray*)chordsWithInfo:(NSDictionary*)info{
    
    NSMutableArray<Chord*>* mutChords = [NSMutableArray new];
    NSArray<NSDictionary*>* punchesInfo = [info safeArrayObjectForKey:@"punches"];
    [punchesInfo enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        Chord* chord =  [Chord new];
        [chord setValues:obj];
        [mutChords addObject:chord];
    }];
    
    NSArray* chords = [NSArray arrayWithArray:mutChords];
    return chords;
}

@end
