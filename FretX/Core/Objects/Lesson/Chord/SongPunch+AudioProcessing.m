//
//  SongPunch+AudioProcessing.m
//  FretX
//
//  Created by Developer on 7/10/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "SongPunch+AudioProcessing.h"

#import <FretXAudioProcessing/FretXAudioProcessing-Swift.h>

#import "FingerPosition.h"

@implementation SongPunch (AudioProcessing)


+ (instancetype)initScaleWithRoot:(NSString*)root type:(NSString*)type{
    
    Scale *audioProcScale = [[Scale alloc] initWithRoot:root type:type];
    
    SongPunch* songPunch = [SongPunch new];
    if (songPunch) {
        songPunch.root = root;
        songPunch.quality = type;
        songPunch.chordName = [NSString stringWithFormat:@"%@ %@",root,type];
        songPunch.fingering = [SongPunch fingersPositionsWithAudioProcPositions:[audioProcScale getFingering]];
    }
    return songPunch;
}

+ (instancetype)initChordWithRoot:(NSString*)root type:(NSString*)type{
    
    Chord *audioProcChord = [[Chord alloc] initWithRoot:root type:type];
    
    SongPunch* songPunch;
    if (audioProcChord) {
        
        songPunch = [SongPunch new];
        
        songPunch.root = root;
        songPunch.quality = type;
        songPunch.chordName = [NSString stringWithFormat:@"%@ %@",root,type];
        
        NSLog(@" ");
        NSLog(@"%@ %@",root,type);
        songPunch.fingering = [SongPunch fingersPositionsWithAudioProcPositions:[audioProcChord getFingering]];
        NSLog(@" ");
    }
    return songPunch;
}

+ (NSArray<FingerPosition*>*)fingersPositionsWithAudioProcPositions:(NSArray<FretboardPosition*>*)fretboardPositions{
    
    NSMutableArray* mutResult = [NSMutableArray new];
    
    [fretboardPositions enumerateObjectsUsingBlock:^(FretboardPosition * _Nonnull fretPosition, NSUInteger idx, BOOL * _Nonnull stop) {
        
        FingerPosition* fingerPosition = [FingerPosition new];
        
        fingerPosition.string = (int)[fretPosition getString];
        fingerPosition.fret = (int)[fretPosition getFret];
        
        NSLog(@"tap=%ld string=%d fret=%d ", idx, fingerPosition.string, fingerPosition.fret);
        
        [mutResult addObject:fingerPosition];
    }];
    
    NSArray<FingerPosition*>* result = [NSArray arrayWithArray:mutResult];
    return result;
}





@end
