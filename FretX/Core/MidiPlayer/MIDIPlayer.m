//
//  MIDIPlayer.m
//  FretX
//
//  Created by Developer on 8/2/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "MIDIPlayer.h"

#import <AVFoundation/AVfoundation.h>

@interface MIDIPlayer () <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioUnitSampler* sampler;
@property (nonatomic, strong) AVAudioEngine* audioEngine;
//
@property (nonatomic, strong) NSArray<NSNumber*>* notes;
@property (nonatomic, assign) NSUInteger currentNoteIndex;

@property (strong) NSTimer* timer;

@property (nonatomic, strong) AVAudioPlayer * audioPlayer;

@property (nonatomic, assign) BOOL playingInvoked;

@end

@implementation MIDIPlayer

#pragma mark - Lifecycle

- (instancetype)initWithDelegate:(id<MIDIPlayerDelegate>)delegate{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        [self setupWavPlayer];
    }
    return self;
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        [self setupWavPlayer];
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

//- (void)initializeSources{
//    [self initAudioSources];
//    [self setupWavPlayer];
//}

- (void)setupWavPlayer{
    
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"chime_bell_ding"
                                         ofType:@"wav"]];
    NSError *error = nil;
    AVAudioPlayer * audioPlayer = [[AVAudioPlayer alloc]
                                   initWithContentsOfURL:url
                                   error:&error];
    audioPlayer.delegate = self;
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

- (void)clear{

    [self stopAllSources];
    self.audioPlayer = nil;
    self.audioEngine = nil;
    self.sampler = nil;
    self.delegate = nil;
}

#pragma mark - Wav

- (void)playChimeBell{
    
    if ([self.delegate respondsToSelector:@selector(willPlaying:)])
        [self.delegate willPlaying:self];

    [self.audioPlayer pause];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient withOptions:AVAudioSessionCategoryOptionDuckOthers error:nil];

    [self.audioPlayer pause];
    self.audioPlayer.currentTime = 0.f;
    [self.audioPlayer play];
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"chime_bell_ding" ofType:@"wav"];
//    SystemSoundID soundID;
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
//    AudioServicesPlaySystemSound(soundID);
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        AudioServicesDisposeSystemSoundID(soundID);
//    });

}

#pragma mark - 

- (void)playMIDI{
    
    //    if (!self.audioEngine.running)
    //        [self.audioEngine startAndReturnError:nil];
    
    self.playingInvoked = YES;
    
    self.currentNoteIndex = 0;
    [self startTimer];
}

- (void)playArrayOfMIDINotes:(NSArray<NSNumber*>*)notes{
    
    if ([self.delegate respondsToSelector:@selector(willPlaying:)])
        [self.delegate willPlaying:self];
    
    [self stopMIDI];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient withOptions:AVAudioSessionCategoryOptionDuckOthers error:nil];

    [self initAudioSources];
        
    [self setupWithArrayOfMIDINotes:notes];
    [self playMIDI];
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    NSLog(@"DidFinishPlaying");
    
//    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient withOptions:0 error:nil];
//    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
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
        
//        [self stopTimer];
//        
//        if ([self.delegate respondsToSelector:@selector(didEndPlaying:)])
//            [self.delegate didEndPlaying:self];
        
        [self stopMIDI];

    }
}

- (void)stopMIDI{
    
    self.playingInvoked = NO;
    static BOOL isStopingNow = NO;
    
    if (!isStopingNow) {
        
        isStopingNow = YES;
#warning TEST
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.7f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (!self.playingInvoked)
                [self stopAllSources];
            isStopingNow = NO;
        });
    }
}

- (void)stopAllSources{
    [self stopTimer];
    
    if (self.audioEngine.isRunning) {
        [self.audioEngine stop];
        self.audioEngine = nil;
    }
    
//    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient withOptions:AVAudioSessionCategoryOptionDuckOthers error:nil];
//    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    if ([self.delegate respondsToSelector:@selector(didEndPlaying:)])
        [self.delegate didEndPlaying:self];

}

@end
