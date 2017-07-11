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

@interface ChordExerciseViewController ()

@property (strong) ChordExercise* chordExercise;

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
    }
    
    [self.guitarNeckView layoutChord:self.currentChord withPunchAnimation:NO];
    [self layoutProgressForChordExercise:self.chordExercise];
    
}

- (void)setupNextChord{
    
    SongPunch* nextChord = [self.chordExercise chordNextToChord:self.currentChord];
    if (nextChord)
        [self layoutChord:nextChord];
}

- (void)layoutProgressForChordExercise:(ChordExercise*)exercise{
    
    NSUInteger currentIndex = self.currentChord.index;
    NSUInteger chordsCount = self.chordExercise.repetitionsCount;
    float progress = (float)currentIndex / (float)chordsCount;
    [self.fretsProgressView setupProgress:progress];
}



@end
