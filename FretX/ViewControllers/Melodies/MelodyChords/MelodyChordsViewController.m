//
//  MelodyChordsViewController.m
//  FretX
//
//  Created by Developer on 6/29/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "MelodyChordsViewController.h"

//#import "Melody.h"
#import "FretsProgressView.h"
#import "GuitarNeckView.h"
#import "RequestManager.h"
#import "FingerPosition.h"
#import "Lesson.h"
#import "Chord.h"

@interface MelodyChordsViewController ()

//UI
@property (nonatomic, weak) IBOutlet UILabel* melodyFullNameLabel;
@property (nonatomic, weak) IBOutlet UILabel* currentChordLabel;
@property (nonatomic, weak) IBOutlet UILabel* nextChordLabel;
@property (nonatomic, weak) IBOutlet UIView* fretsContainerView;
@property (nonatomic, weak) GuitarNeckView* guitarNeckView;
@property (nonatomic, weak) IBOutlet UIView* progressContainerView;
@property (nonatomic, weak) FretsProgressView* fretsProgressView;
//Data
@property (strong, nonatomic) Lesson* lesson;
@property (strong) Chord* currentChord;
@end

@implementation MelodyChordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layout];
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

- (void)setupLesson:(Lesson*)lesson{
    
    self.lesson = lesson;
}

- (void)layoutLesson:(Lesson*)lesson{
    
    self.melodyFullNameLabel.text = lesson.melodyTitle;
    if (lesson.punches.count > 0) {
        
        [self layoutChord:lesson.punches[0]];
    }
}

- (void)layoutChord:(Chord*)chord{
    
    self.currentChord = chord;
    
    self.currentChordLabel.text = chord.chordName;// self.currentChord.chordName;
    if ([self.lesson chordNextToChord:self.currentChord]) {
        self.nextChordLabel.text = [self.lesson chordNextToChord:self.currentChord].chordName;
    }
    
    [self.guitarNeckView layoutChord:self.currentChord];
    [self layoutProgressForLesson:self.lesson];
}

#pragma mark - Private

- (void)setupNextChord{
    
    Chord* nextChord = [self.lesson chordNextToChord:self.currentChord];
    if (nextChord)
        [self layoutChord:nextChord];
}

- (void)layoutProgressForLesson:(Lesson*)lesson{
    
#warning TEST
//    [self.fretsProgressView showAnimation];
    
    NSUInteger currentIndex = [self.lesson.punches indexOfObject:self.currentChord];
    NSUInteger chordsCount = self.lesson.punches.count;
    float progress = (float)currentIndex / (float)chordsCount;
    [self.fretsProgressView setupProgress:progress];
}

#pragma mark - Layout

- (void)layout{
    [self.view layoutIfNeeded];
    [self addFretBoard];
    [self addFretsProgressView];
    
    [self layoutLesson:self.lesson];
    
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
    
#warning TEST
//    [self.fretsProgressView setupStyle:ProgressViewStyleWide];
    
    [self.view layoutIfNeeded];
}

#pragma mark - Actions

- (IBAction)onNextChordButton:(id)sender{
    
    [self setupNextChord];
}







@end
