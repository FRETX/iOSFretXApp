//
//  MIDIPlayer.h
//  FretX
//
//  Created by Developer on 8/2/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MIDIPlayer;

@protocol MIDIPlayerDelegate <NSObject>

- (void)didEndPlaying:(MIDIPlayer*)midiPlayer;
- (void)willPlaying:(MIDIPlayer*)midiPlayer;

@end

@interface MIDIPlayer : NSObject

@property (nonatomic, weak) id<MIDIPlayerDelegate> delegate;

//- (void)setupWithArrayOfMIDINotes:(NSArray<NSNumber*>*)notes;
//
//- (void)playMIDI;

- (instancetype)initWithDelegate:(id<MIDIPlayerDelegate>)delegate;

- (void)playArrayOfMIDINotes:(NSArray<NSNumber*>*)notes;

#pragma mark - Wav

- (void)playChimeBell;

@end
