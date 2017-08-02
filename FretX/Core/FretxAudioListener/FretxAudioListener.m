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

- (void)setupAudioListenerWithDelegate:(id<AudioListener>)delegate chords:(NSArray<Chord *>*)chords{
    
    [Audio.shared setAudioListenerWithListener:delegate];
    [Audio.shared setTargetChordsWithChords:chords];
    [Audio.shared start];
}

- (void)setupChord:(Chord*)chord{
    
    [Audio.shared setTargetChordWithChord:chord];
}

- (void)startListener{
    
    [Audio.shared startListening];
}

- (void)stopListener{
    
    [Audio.shared stopListening];
}


//- (void)onProgress {
//    float progress = [Audio.shared getProgress];
//    //    NSLog(@"progress: %f",progress);
//    if(progress >= 100){
//        [self setupNextChord];
//    }
//}
//
//- (void)onTimeout{
//    
//}
//
//- (void)onLowVolume{
//    
//}
//
//- (void)onHighVolume{
//    
//}


@end
