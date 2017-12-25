//
//  MelodyChordsViewController.m
//  FretX
//
//  Created by Developer on 6/29/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "MelodyChordsViewController.h"

//#import "Melody.h"

#import "PlayYoutubeViewController.h"
#import "FretsProgressView.h"
#import "GuitarNeckView.h"
#import "RequestManager.h"
#import "Lesson.h"
#import "SongPunch.h"
#import <FretXAudioProcessing/FretXAudioProcessing-Swift.h>
#import <FretXBLE/FretXBLE-Swift.h>
@import FirebaseAnalytics;

//#import "MIDIPlayer.h"

//@interface MelodyChordsViewController () <MIDIPlayerDelegate, AudioListener>
@interface MelodyChordsViewController () <AudioListener>

//UI
@property (nonatomic, weak) IBOutlet UILabel* songFullNameLabel;
@property (nonatomic, weak) IBOutlet UILabel* currentChordLabel;
@property (nonatomic, weak) IBOutlet UILabel* nextChordLabel;
@property (nonatomic, weak) IBOutlet UIView* fretsContainerView;
@property (nonatomic, weak) GuitarNeckView* guitarNeckView;
@property (nonatomic, weak) IBOutlet UIView* progressContainerView;
@property (nonatomic, weak) FretsProgressView* fretsProgressView;
@property (nonatomic, weak) IBOutlet UIImageView* microphoneImageView;

//Data
@property (strong, nonatomic) Lesson* lesson;
@property (strong, nonatomic) NSArray<SongPunch*>* chords;
@property (strong) SongPunch* currentChord;

//@property (nonatomic, strong) MIDIPlayer* midiPlayer;

@end

@implementation MelodyChordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self layout];
}

- (void) viewDidAppear:(BOOL)animated{
    [FIRAnalytics logEventWithName:kFIREventSelectContent
                        parameters:@{
                                     kFIRParameterItemID:self.lesson.fretxID,
                                     kFIRParameterItemName:self.lesson.songName,
                                     kFIRParameterContentType:@"PREVIEW"
                                     }];
}

//- (void)viewWillAppear:(BOOL)animated{
//    [Audio.shared setAudioListenerWithListener:self];
//    [Audio.shared setTargetChordsWithChords:[self.lesson getUniqueAudioProcChords]];
//    [Audio.shared setTargetChordWithChord:[[Chord alloc] initWithRoot:self.currentChord.root type:self.currentChord.quality]];
//    [Audio.shared start];
//}

//- (void)viewWillDisappear:(BOOL)animated{
//    [Audio.shared stop];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self layout];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

//    [Audio.shared stopListening];
    [Audio.shared stop];

//    [self.midiPlayer clear];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:kOpenPlayYoutubeSegueID]) {
        
        PlayYoutubeViewController* playYoutubeController = segue.destinationViewController;
        [playYoutubeController setupLesson:self.lesson];
    }
}

#pragma mark - Public

- (void)setupLesson:(Lesson*)lesson{
    self.lesson = lesson;
    [Audio.shared setTargetChordWithChord:[[Chord alloc] initWithRoot:lesson.punches[0].root type:lesson.punches[0].quality]];
    NSArray* chords = [NSArray arrayWithArray:lesson.punches];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"self.isEmpty == 0"];
    NSArray* filteredArray = [chords filteredArrayUsingPredicate:predicate];
    self.chords = filteredArray;
}

#pragma mark - Private

- (void)layoutLesson:(Lesson*)lesson{
    
    self.songFullNameLabel.text = lesson.melodyTitle;
    if (self.chords.count > 0) {
        [self layoutChord:self.chords[0]];
    }
}

- (void)layoutChord:(SongPunch*)chord{
    
    self.currentChord = chord;
    
    self.currentChordLabel.text = chord.chordName;// self.currentChord.chordName;
    if ([self.lesson chordNextToChord:self.currentChord allowEmpty:NO]) {
        self.nextChordLabel.text = [self.lesson chordNextToChord:self.currentChord allowEmpty:NO].chordName;
    } else{
        self.nextChordLabel.text = @"";
    }
    BOOL leftHanded = [[NSUserDefaults standardUserDefaults] boolForKey:@"leftHanded"];
    [self.guitarNeckView layoutChord:self.currentChord withPunchAnimation:YES withLeftHanded:(BOOL)leftHanded];
//    [self.guitarNeckView layoutChord:self.currentChord];
    [self layoutProgressForLesson:self.lesson];
    Chord *tmpChord = [[Chord alloc] initWithRoot:self.currentChord.root type:self.currentChord.quality];
    NSArray<NSNumber *> *btArray = [MusicUtils getBluetoothArrayFromChordWithChordName:tmpChord.name];
    if(leftHanded){
        btArray = [MusicUtils leftHandizeBluetoothArrayWithBtArray:btArray];
    }
    [FretxBLE.sharedInstance sendWithFretCodes:btArray];
    //update next chord
    
}

- (void)setupNextChord{
    
    SongPunch* nextChord = [self.lesson chordNextToChord:self.currentChord allowEmpty:NO];
    if (nextChord){
        [self layoutChord:nextChord];
        [Audio.shared setTargetChordWithChord:[[Chord alloc] initWithRoot:nextChord.root type:nextChord.quality]];
    }

}

- (void)layoutProgressForLesson:(Lesson*)lesson{
    
    NSUInteger currentIndex = [self.chords indexOfObject:self.currentChord];
    NSUInteger chordsCount = self.chords.count;
    float progress = (float)currentIndex / (float)chordsCount;
    [self.fretsProgressView setupProgress:progress];
}

#pragma mark - 

- (void)layout{

//    self.midiPlayer = [[MIDIPlayer alloc] initWithDelegate:self];
    
    [self.view layoutIfNeeded];
    [self addFretBoard];
    [self addFretsProgressView];
    
    [self layoutLesson:self.lesson];

    [self setupAudioListening];
}

- (void)addFretBoard{
    
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"GuitarNeckView"
                                                      owner:self
                                                    options:nil];
    
    self.guitarNeckView = [nibViews firstObject];
    CGRect bounds = self.fretsContainerView.bounds;
    [self.guitarNeckView setFrame:bounds];
    [self.fretsContainerView addSubview:self.guitarNeckView];
    
    [self.view layoutIfNeeded];
}

- (void)addFretsProgressView{
    
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"FretsProgressView"
                                                      owner:self
                                                    options:nil];
    
    self.fretsProgressView = [nibViews firstObject];
    CGRect bounds = self.progressContainerView.bounds;
    [self.fretsProgressView setFrame:bounds];
    [self.progressContainerView addSubview:self.fretsProgressView];

    [self.view layoutIfNeeded];
}

#pragma mark - Audio processing

- (void)setupAudioListening{
    
    [Audio.shared setAudioListenerWithListener:self];
    [Audio.shared setTargetChordsWithChords:[self.lesson getUniqueAudioProcChords]];
    [Audio.shared setTargetChordWithChord:[[Chord alloc] initWithRoot:self.currentChord.root type:self.currentChord.quality]];
    [Audio.shared start];
    
}

#pragma mark - Audio listening delegate

- (void)onProgress {
    float progress = [Audio.shared getProgress];
    //    NSLog(@"progress: %f",progress);
    if(progress >= 100){
        [self setupNextChord];
        
//        [self.midiPlayer playChimeBell];
    }
}

- (void)onTimeout{
    
}

- (void)onLowVolume{
    
    self.microphoneImageView.image = [UIImage imageNamed:@"MicrophoneIconDefault"];
}

- (void)onHighVolume{
    
    self.microphoneImageView.image = [UIImage imageNamed:@"MicrophoneIconGreen"];
}


#pragma mark - Actions

- (IBAction)onPlayChordButton:(id)sender{

//    [self.midiPlayer playArrayOfMIDINotes:self.currentChord.midiNotes];
}

- (IBAction)onPlayYoutubeButton:(id)sender{
    
    [self performSegueWithIdentifier:kOpenPlayYoutubeSegueID sender:self];
}

- (IBAction)onNextChordButton:(id)sender{
    
    [self setupNextChord];
//    [self.midiPlayer playArrayOfMIDINotes:self.currentChord.midiNotes];
}

//#pragma mark - MIDIPlayer
//
//- (void)willPlaying:(MIDIPlayer*)player{
//    
//    [Audio.shared stopListening];
//}
//
//- (void)didEndPlaying:(MIDIPlayer*)player{
//    
//    [Audio.shared startListening];
//}


@end
