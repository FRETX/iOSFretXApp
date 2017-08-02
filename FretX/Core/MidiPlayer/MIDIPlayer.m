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

- (instancetype)init{
    
    self = [super init];
    if (self) {
        [self initAudioSources];
        
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                             pathForResource:@"chime_bell_ding"
                                             ofType:@"wav"]];
        NSError *error = nil;
        AVAudioPlayer * audioPlayer = [[AVAudioPlayer alloc]
                                       initWithContentsOfURL:url
                                       error:&error];
        self.audioPlayer = audioPlayer;
        if (error)
        {
            NSLog(@"Error in audioPlayer: %@",[error localizedDescription]);
        }
        else
        {
            //        audioPlayer.delegate = self;
            //[audioPlayer play];
            //        [audioPlayer setNumberOfLoops:INT32_MAX]; // for continuous play
        }
    }
    return self;
}

- (void)initAudioSources{
    
    AVAudioEngine* audioEngine = [AVAudioEngine new];
    
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
#warning TEST
//    [audioEngine prepare];
//    [audioEngine startAndReturnError:&engineError];
    
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
    
    [self setupWithArrayOfMIDINotes:notes];
    [self playMIDI];
}

#pragma mark - Wav

- (void)playChimeBell{
    
    [self.audioPlayer play];
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
    }
}

@end
