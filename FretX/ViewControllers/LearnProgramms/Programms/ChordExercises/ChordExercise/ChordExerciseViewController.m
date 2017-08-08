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

@interface ChordExerciseViewController ()

@property (strong) ChordExercise* chordExercise;

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
    
    [self layoutChord:self.currentChord];
    
    [self addPopup];
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
    
    self.chordExercise = chordExercise;
    
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    [self.chordExercise.chords sortUsingDescriptors:@[sortDescriptor]];

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
    
    self.popupContainer.hidden = NO;
}

- (void)hidePopup{
    
    self.popupContainer.hidden = YES;
}

#pragma mark - Actions

- (IBAction)onTapBackToMenu:(id)sender{
    
    [self stopExeTimer];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onTapRetry:(id)sender{
    
    self.currentChordIndexInAllSession = 0;
    self.currentRepetition = 1;
    [self layoutExercise:self.chordExercise];
    
    self.exerciseInterval = 0;
    [self hidePopup];
    [self startExeTimer];
}

#warning TEST
- (IBAction)onTestNextChord:(id)sender{
    
    [self setupNextChord];
}

#pragma mark - Layout

- (void)layout{
    [self.view layoutIfNeeded];
    
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
    
//    self.currentChordLabel.text = chordExercise.exerciseName;
    if (chordExercise.chords.count > 0) {
        
        [self layoutChord:chordExercise.chords[0]];
    }
}

- (void)layoutChord:(SongPunch*)chord{
    
    self.currentChord = chord;
    
    self.currentChordLabel.text = chord.chordName;// self.currentChord.chordName;
    if ([self.chordExercise chordNextToChord:self.currentChord]) {
        self.nextChordLabel.text = [self.chordExercise chordNextToChord:self.currentChord].chordName;
    } else{
        self.nextChordLabel.text = @"";

    }
    
    [self.guitarNeckView layoutChord:self.currentChord withPunchAnimation:NO];
    [self layoutProgressForChordExercise:self.chordExercise];
    
    Chord *tmpChord = [[Chord alloc] initWithRoot:self.currentChord.root type:self.currentChord.quality];
    [FretxBLE.sharedInstance sendWithFretCodes:[MusicUtils getBluetoothArrayFromChordWithChordName:tmpChord.name]];
}

- (void)setupNextChord{
    
    SongPunch* nextChord = [self.chordExercise chordNextToChord:self.currentChord];
    if (nextChord)
        [self layoutChord:nextChord];
    else{
        
        if (self.currentRepetition < self.chordExercise.repetitionsCount) {
            self.currentRepetition++;
            [self layoutExercise:self.chordExercise];
        } else {
            [self stopExeTimer];
            [self showPopup];
        }
    }
}

- (void)layoutProgressForChordExercise:(ChordExercise*)exercise{
    
    float repeats = (float)self.chordExercise.repetitionsCount;
    float chordsCount = (float)self.chordExercise.chords.count;
    float progress = self.currentChordIndexInAllSession / (chordsCount * repeats) ;
    [self.fretsProgressView setupProgress:progress];
    self.currentChordIndexInAllSession++;
}



@end
