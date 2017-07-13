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

//data
@property (strong) SongPunch* currentChord;

@end

@implementation ChordExerciseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layout];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self layoutChord:self.currentChord];
}

- (void)viewWillAppear:(BOOL)animated{
    [Audio.shared setAudioListenerWithListener:self];
    [Audio.shared setTargetChordsWithChords:[self.chordExercise getUniqueChords]];
    [Audio.shared setTargetChordWithChord:[[Chord alloc] initWithRoot:self.currentChord.root type:self.currentChord.quality]];
    [Audio.shared start];
}

- (void)viewWillDisappear:(BOOL)animated{
    [Audio.shared stop];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onProgress {
    float progress = [Audio.shared getProgress];
    //    NSLog(@"progress: %f",progress);
    if(progress >= 100){
        [self setupNextChord];
    }
}

- (void)onTimeout{
    
}

- (void)onLowVolume{
    
}

- (void)onHighVolume{
    
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
    self.punchIndex = 0;
    self.exercisePunches = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<self.chordExercise.repetitionsCount; i++) {
        for (SongPunch* sp in self.chordExercise.chords) {
            [self.exercisePunches addObject:sp];
        }
    }
}

#pragma mark - Layout


- (void)layout{
    [self.view layoutIfNeeded];
    [self addFretBoard];
    [self addFretsProgressView];
    
    [self layoutExercise:self.chordExercise];
    
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
    self.punchIndex++;
    if(self.punchIndex < [self.exercisePunches count]){
        SongPunch* nextChord = self.exercisePunches[self.punchIndex];
        self.currentChord = nextChord;
        [self layoutChord:nextChord];
        [Audio.shared setTargetChordWithChord:[[Chord alloc] initWithRoot:nextChord.root type:nextChord.quality]];
    } else {
        //TODO: pop up end of exercise dialog
        [self layoutProgressForChordExercise:self.chordExercise];
        [self didFinishExercise];
    }
    
//    SongPunch* nextChord = [self.chordExercise chordNextToChord:self.currentChord];
//    if (nextChord)
    
    
}

- (void)layoutProgressForChordExercise:(ChordExercise*)exercise{
    
    NSUInteger currentIndex = self.punchIndex;
    NSUInteger chordsCount = self.exercisePunches.count;
    float progress = (float)currentIndex / (float)chordsCount;
    [self.fretsProgressView setupProgress:progress];
}

- (void) didFinishExercise{
    [Audio.shared stop];
    NSLog(@"End of Exercise");
}

@end
