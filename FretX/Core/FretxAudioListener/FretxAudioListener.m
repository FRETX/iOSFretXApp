//
//  FretxAudioListener.m
//  FretX
//
//  Created by Developer on 8/2/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "FretxAudioListener.h"

#import <FretXAudioProcessing/FretXAudioProcessing-Swift.h>
#import <FretXBLE/FretXBLE-Swift.h>

@implementation FretxAudioListener

- (instancetype)shared{
    
    static FretxAudioListener* listener;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        listener = [FretxAudioListener new];
    });
    
    return listener;
}

//- (void)setupAudioListenerWithDelegate:(id<AudioListener>)delegate{
//    
//    [Audio.shared setAudioListenerWithListener:delegate];
//    [Audio.shared setTargetChordsWithChords:[self.chordExercise getUniqueChords]];
//    [Audio.shared setTargetChordWithChord:[[Chord alloc] initWithRoot:self.currentChord.root type:self.currentChord.quality]];
//    [Audio.shared start];
//}

@end
