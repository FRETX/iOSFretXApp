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

@interface MelodyChordsViewController ()

//UI
@property (nonatomic, weak) IBOutlet UILabel* songFullNameLabel;
@property (nonatomic, weak) IBOutlet UILabel* currentChordLabel;
@property (nonatomic, weak) IBOutlet UILabel* nextChordLabel;
@property (nonatomic, weak) IBOutlet UIView* fretsContainerView;
@property (nonatomic, weak) GuitarNeckView* guitarNeckView;
@property (nonatomic, weak) IBOutlet UIView* progressContainerView;
@property (nonatomic, weak) FretsProgressView* fretsProgressView;


//Data
@property (strong, nonatomic) Lesson* lesson;
@property (strong, nonatomic) NSArray<SongPunch*>* chords;
@property (strong) SongPunch* currentChord;
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
    
    [self.guitarNeckView layoutChord:self.currentChord];
    [self layoutProgressForLesson:self.lesson];
    Chord *tmpChord = [[Chord alloc] initWithRoot:self.currentChord.root type:self.currentChord.quality];
    [FretxBLE.sharedInstance sendWithFretCodes:[MusicUtils getBluetoothArrayFromChordWithChordName:tmpChord.name]];
}

- (void)setupNextChord{
    
    SongPunch* nextChord = [self.lesson chordNextToChord:self.currentChord allowEmpty:NO];
    if (nextChord)
        [self layoutChord:nextChord];
    else{
        
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

    [self.view layoutIfNeeded];
}

#pragma mark - Actions

- (IBAction)onPlayYoutubeButton:(id)sender{
    
    [self performSegueWithIdentifier:kOpenPlayYoutubeSegueID sender:self];
}

- (IBAction)onNextChordButton:(id)sender{
    
    [self setupNextChord];
}



@end
