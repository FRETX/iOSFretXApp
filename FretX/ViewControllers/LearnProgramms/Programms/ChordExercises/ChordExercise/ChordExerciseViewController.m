//
//  ChordExerciseViewController.m
//  FretX
//
//  Created by Developer on 7/11/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "ChordExerciseViewController.h"

#import <FretXAudioProcessing/FretXAudioProcessing-Swift.h>
#import <FretXBLE/FretXBLE-Swift.h>

#import "ChordExercise.h"
#import "FretsProgressView.h"
#import "GuitarNeckView.h"
#import "TimeConverter.h"
#import "MIDIPlayer.h"

@interface ChordExerciseViewController () <AudioListener>

@property (strong) ChordExercise* chordExercise;
@property (strong) NSMutableArray<SongPunch *>* exercisePunches;
@property int punchIndex;

//ui
@property (nonatomic, weak) IBOutlet UILabel* currentChordLabel;
@property (nonatomic, weak) IBOutlet UILabel* nextChordLabel;
@property (nonatomic, weak) IBOutlet UIView* fretsContainerView;
@property (nonatomic, weak) GuitarNeckView* guitarNeckView;
@property (nonatomic, weak) IBOutlet UIView* progressContainerView;
@property (nonatomic, weak) FretsProgressView* fretsProgressView;
@property (nonatomic, weak) IBOutlet UIView* popupContainer;

//data
@property (nonatomic, weak) IBOutlet UILabel* popupTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel* currentTimeLabel;
@property (assign) float currentChordIndexInAllSession;
//data
@property (strong) SongPunch* currentChord;

@property (strong) NSTimer* timer;
@property (assign) float exerciseInterval;

@property (assign) int currentRepetition;

@property (strong) MIDIPlayer* midiPlayer;

@end

@implementation ChordExerciseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.currentChordIndexInAllSession = 0;
    self.currentRepetition = 1;
    [self layout];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.midiPlayer playChimeBell];
//    });
}

- (void)viewWillAppear:(BOOL)animated{
    [self layoutChord:self.currentChord];
    [self addPopup];
    [self.fretsProgressView setupProgress:0];

//    self.midiPlayer = [MIDIPlayer new];
    
    [self setupAudioListening];
}

- (void)viewWillDisappear:(BOOL)animated{
    [Audio.shared stop];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Public

- (void)setupChordExercise:(ChordExercise*)chordExercise{
    
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    [self.chordExercise.chords sortUsingDescriptors:@[sortDescriptor]];
    
    self.chordExercise = chordExercise;
    self.punchIndex = 0;
    self.exercisePunches = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<self.chordExercise.repetitionsCount; i++) {
        for (SongPunch* sp in self.chordExercise.chords) {
            [self.exercisePunches addObject:sp];
        }
    }
    
}

#pragma mark - Audio processing

- (void)setupAudioListening{
    
    [Audio.shared setAudioListenerWithListener:self];
    [Audio.shared setTargetChordsWithChords:[self.chordExercise getUniqueAudioProcChords]];
    [Audio.shared setTargetChordWithChord:[[Chord alloc] initWithRoot:self.currentChord.root type:self.currentChord.quality]];
    [Audio.shared start];

}

#pragma mark - Audio listening delegate

- (void)onProgress {
    float progress = [Audio.shared getProgress];
    //    NSLog(@"progress: %f",progress);
    if(progress >= 100){
        [self setupNextChord];
        
        [self.midiPlayer playChimeBell];
    }
}

- (void)onTimeout{
    
}

- (void)onLowVolume{
    
}

- (void)onHighVolume{
    
}


#pragma mark - private

- (void)startExeTimer{
    
    [self stopExeTimer];
    
    float interval = 1.f;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(onFiredExeTimer:) userInfo:nil repeats:YES];
    
}

- (void)stopExeTimer{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)onFiredExeTimer:(NSTimer*)timer{
    
    self.exerciseInterval ++;
    NSString* time = [TimeConverter durationStringFromSeconds:self.exerciseInterval];
    self.currentTimeLabel.text = time;
    self.popupTimeLabel.text = time;
}

#pragma mark - Popup

- (void)addPopup{
    
    [self.view layoutIfNeeded];
    self.popupContainer.frame = self.view.bounds;
    [self.view addSubview:self.popupContainer];
    
    [self hidePopup];
    
}

- (void)showPopup{
    NSLog(@"showing popup");
    self.popupContainer.hidden = NO;
}

- (void)hidePopup{
    self.popupContainer.hidden = YES;
}

#pragma mark - Actions

- (IBAction)onPlayChordButton:(id)sender{
    
    [self.midiPlayer playChimeBell];
    
//    [self.midiPlayer playArrayOfMIDINotes:self.currentChord.midiNotes];
}

- (IBAction)onTapBackToMenu:(id)sender{
    
    [self stopExeTimer];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onTapRetry:(id)sender{
    
    //    self.currentChordIndexInAllSession = 0;
    //    self.currentRepetition = 1;
    _punchIndex = 0;
    [self layoutExercise:self.chordExercise];
    
    self.exerciseInterval = 0;
    [self hidePopup];
    [self.fretsProgressView setupProgress:0];
    [self startExeTimer];
}

#warning TEST
- (IBAction)onTestNextChord:(id)sender{
    
    [self setupNextChord];
}

#pragma mark - Layout

- (void)layout{
    [self.view layoutIfNeeded];
    
//    self.midiPlayer = [MIDIPlayer new];
    
    [self addFretBoard];
    [self addFretsProgressView];
    
    [self layoutExercise:self.chordExercise];
    
    [self startExeTimer];
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


- (void)layoutExercise:(ChordExercise*)chordExercise{
    //TODO: redo this with exercisePunches
    self.currentChordLabel.text = chordExercise.exerciseName;
    if (chordExercise.chords.count > 0) {
        [self layoutChord:chordExercise.chords[0]];
    }
}

- (void)layoutChord:(SongPunch*)chord{
    
    self.currentChord = chord;
    
    self.currentChordLabel.text = chord.chordName;// self.currentChord.chordName;
    if(_punchIndex+1 < [self.exercisePunches count]){
        self.nextChordLabel.text = _exercisePunches[_punchIndex+1].chordName;
    } else {
        self.nextChordLabel.text = @"";
    }
    
    //    if ([self.chordExercise chordNextToChord:self.currentChord]) {
    //        self.nextChordLabel.text = [self.chordExercise chordNextToChord:self.currentChord].chordName;
    //    } else{
    //        self.nextChordLabel.text = @"";
    //
    //    }
    
    [self.guitarNeckView layoutChord:self.currentChord withPunchAnimation:NO];
    //    [self layoutProgressForChordExercise:self.chordExercise];
    Chord *tmpChord = [[Chord alloc] initWithRoot:self.currentChord.root type:self.currentChord.quality];
    [FretxBLE.sharedInstance sendWithFretCodes:[MusicUtils getBluetoothArrayFromChordWithChordName:tmpChord.name]];
}

- (void)setupNextChord{
    self.punchIndex++;
    [self.fretsProgressView setupProgress:((float)_punchIndex/(float)[_exercisePunches count])];
    if(self.punchIndex < [self.exercisePunches count]){
        SongPunch* nextChord = self.exercisePunches[self.punchIndex];
        [Audio.shared setTargetChordWithChord:[[Chord alloc] initWithRoot:nextChord.root type:nextChord.quality]];
        self.currentChord = nextChord;
        
        [self layoutChord:nextChord];
        
    } else{
        //        if (self.currentRepetition < self.chordExercise.repetitionsCount) {
        //            self.currentRepetition++;
        //            [self layoutExercise:self.chordExercise];
        //        } else {
        [self stopExeTimer];
        [Audio.shared stop];
        [self showPopup];
        //        }
    }
}


- (void) didFinishExercise{
    [Audio.shared stop];
    NSLog(@"End of Exercise");
}

@end
