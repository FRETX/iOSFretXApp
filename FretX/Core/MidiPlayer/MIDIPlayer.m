//
//  MIDIPlayer.m
//  FretX
//
//  Created by Developer on 8/2/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "MIDIPlayer.h"

#import <AVFoundation/AVfoundation.h>

@interface MIDIPlayer ()

@property (nonatomic, strong) AVAudioUnitSampler* sampler;
@property (nonatomic, strong) AVAudioEngine* audioEngine;
//
@property (nonatomic, strong) NSArray<NSNumber*>* notes;
@property (nonatomic, assign) NSUInteger currentNoteIndex;

@property (strong) NSTimer* timer;

@property (nonatomic, strong) AVAudioPlayer * audioPlayer;

@end

@implementation MIDIPlayer

#pragma mark - Lifecycle

- (instancetype)initWithDelegate:(id<MIDIPlayerDelegate>)delegate{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        [self initializeSources];
    }
    return self;
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        [self initializeSources];
    }
    return self;
}

- (void)initAudioSources{
    
    AVAudioEngine* audioEngine = [AVAudioEngine new];
//#warning TEST
//    AudioOutputUnitStop(audioEngine.inputNode.audioUnit);
//    AudioUnitUninitialize(audioEngine.inputNode.audioUnit);
    
    self.audioEngine = audioEngine;
    
    self.sampler = [AVAudioUnitSampler new];
    [audioEngine attachNode:self.sampler];
    [audioEngine connect:self.sampler to:audioEngine.outputNode format:nil];
    
    NSURL* soundbankURL = [[NSBundle mainBundle] URLForResource:@"gs_instruments" withExtension:@"dls"];
    
    if (!soundbankURL) {
        NSLog(@"Could not initalize soundbank.");
        return;
    }
    
    UInt8 melodicBank = kAUSampler_DefaultMelodicBankMSB;
    UInt8 gmHarpsichord = 6;
    //    do {
    //
    //        try self.sampler!.loadSoundBankInstrumentAtURL(soundbank, program: gmHarpsichord, bankMSB: melodicBank, bankLSB: 0)
    //
    //    }catch {
    //        NSLog(@"An error occurred \(error)");
    //        return;
    //    }
    
    NSError* engineError = nil;

    [audioEngine prepare];
    [audioEngine startAndReturnError:&engineError];
    
    if (engineError) {
        NSLog(@"audioEngine error");
    }
    
    NSError* error = nil;
    [self.sampler loadSoundBankInstrumentAtURL:soundbankURL program:gmHarpsichord bankMSB:melodicBank bankLSB:0 error:&error];
    if (error) {
        NSLog(@"SoundBank loading error");
    }
    
    //[self.sampler startNote:60 withVelocity:64 onChannel:0];
}

- (void)initializeSources{
    [self initAudioSources];
    
    [self setupWavPlayer];
}

- (void)setupWavPlayer{
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"chime_bell_ding"
                                         ofType:@"wav"]];
    NSError *error = nil;
    AVAudioPlayer * audioPlayer = [[AVAudioPlayer alloc]
                                   initWithContentsOfURL:url
                                   error:&error];
    self.audioPlayer = audioPlayer;
    if (error) {
        NSLog(@"Error in audioPlayer: %@",[error localizedDescription]);
    } else {
        //        [audioPlayer setNumberOfLoops:INT32_MAX]; // for continuous play
    }
}

#pragma mark - Public

- (void)setupWithArrayOfMIDINotes:(NSArray<NSNumber*>*)notes{
    
    self.currentNoteIndex = 0;
    self.notes = notes;
}

- (void)playMIDI{
    
//    if (!self.audioEngine.running)
//        [self.audioEngine startAndReturnError:nil];
    
    self.currentNoteIndex = 0;
    [self startTimer];
}

- (void)playArrayOfMIDINotes:(NSArray<NSNumber*>*)notes{
    
    if ([self.delegate respondsToSelector:@selector(willPlaying:)])
        [self.delegate willPlaying:self];
    
  //  [self initializeSources];
    
    [self setupWithArrayOfMIDINotes:notes];
    [self playMIDI];
}

#pragma mark - Wav

- (void)playChimeBell{
    
    if ([self.delegate respondsToSelector:@selector(willPlaying:)])
        [self.delegate willPlaying:self];

    [self.audioPlayer pause];
    self.audioPlayer.currentTime = 0.f;
    [self.audioPlayer play];
    
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    if ([self.delegate respondsToSelector:@selector(didEndPlaying:)])
        [self.delegate didEndPlaying:self];
}

#pragma mark - Private

- (void)startTimer{
    
    [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(onPlayingTimer:) userInfo:nil repeats:YES];
//    [self.timer fire];
}

- (void)stopTimer{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)onPlayingTimer:(NSTimer*)timer{
    
    if (self.currentNoteIndex < self.notes.count) {
        
        NSNumber* noteNumber = [self.notes objectAtIndex:self.currentNoteIndex];
        [self.sampler startNote:noteNumber.unsignedIntegerValue withVelocity:64 onChannel:0];
        self.currentNoteIndex++;
    } else{
        
        [self stopTimer];
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.7f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//             [self stopAllSources];
//        });
    }
}

- (void)stopAllSources{
    [self stopTimer];
    
    [self.audioEngine stop];
    self.audioEngine = nil;
    
    if ([self.delegate respondsToSelector:@selector(didEndPlaying:)])
        [self.delegate didEndPlaying:self];

}

@end
