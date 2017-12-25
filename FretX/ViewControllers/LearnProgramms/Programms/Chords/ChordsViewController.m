//
//  ChordsViewController.m
//  FretX
//
//  Created by Developer on 7/10/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "ChordsViewController.h"

#import <FretXAudioProcessing/FretXAudioProcessing-Swift.h>
#import <FretXBLE/FretXBLE-Swift.h>

#import "ItemsCollectionView.h"
#import "ContentManager.h"
#import "GuitarNeckView.h"
#import "SongPunch.h"
#import "MIDIPlayer.h"
@import FirebaseAnalytics;

@interface ChordsViewController () < ItemsCollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UIView* fretsContainerView;
@property (nonatomic, weak) GuitarNeckView* guitarNeckView;

@property (nonatomic, weak) IBOutlet UIView* rootsContainerView;
@property (nonatomic, weak) ItemsCollectionView* rootsPickerView;

@property (nonatomic, weak) IBOutlet UIView* typesContainerView;
@property (nonatomic, weak) ItemsCollectionView* typePickerView;

@property (nonatomic, weak) IBOutlet UILabel* chordNameLabel;

//data
@property (strong) NSArray<SongPunch*>* allChords;
@property (strong) NSArray<NSString*>* chordRoots;
@property (strong) NSArray<NSString*>* chordTypes;

@property (strong) SongPunch* currentChord;
@property (strong) NSString* currentRoot;
@property (strong) NSString* currentType;

@property (nonatomic, strong) MIDIPlayer* midiPlayer;

@end

@implementation ChordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self layout];
    [self updateChord];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [FIRAnalytics logEventWithName:kFIREventSelectContent
                        parameters:@{
                                     kFIRParameterItemID:@"Chords",
                                     kFIRParameterItemName:@"Chords",
                                     kFIRParameterContentType:@"TAB"
                                     }];
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


- (void)setInitialValues{
    
    self.currentRoot = self.chordRoots[0];
    self.currentType = self.chordTypes[0];

    [self updateChord];
}

- (void)getContent{
    
    self.allChords = [[ContentManager defaultManager] allChords];
    self.chordRoots = [[ContentManager defaultManager] allChordRoots];
    self.chordTypes = [[ContentManager defaultManager] allChordTypes];
    
    if (self.chordRoots.count > 0 && self.chordTypes.count > 0) {
        [self setInitialValues];
    }
}

- (void)layout{
    
    self.midiPlayer = [MIDIPlayer new];
    
    [self getContent];
    
    [self.view layoutIfNeeded];
    [self addChordRootsPicker];
    [self addChordTypesPicker];
    [self addFretBoard];
    
}

- (void)updateChord{
    
    SongPunch* currentChord = [SongPunch initChordWithRoot:self.currentRoot type:self.currentType];
    [self layoutChord:currentChord];
    Chord *tmpChord = [[Chord alloc] initWithRoot:self.currentChord.root type:self.currentChord.quality];
    BOOL leftHanded = [[NSUserDefaults standardUserDefaults] boolForKey:@"leftHanded"];
    NSArray<NSNumber *> *btArray = [MusicUtils getBluetoothArrayFromChordWithChordName:tmpChord.name];
    if(leftHanded){
        btArray = [MusicUtils leftHandizeBluetoothArrayWithBtArray:btArray];
    }
    [FretxBLE.sharedInstance sendWithFretCodes:btArray];
}

- (void)layoutChord:(SongPunch*)chord{
    
    self.currentChord = chord;
    
    self.chordNameLabel.text = chord.chordName;
    
    [self.guitarNeckView layoutChord:self.currentChord withPunchAnimation:NO withLeftHanded:false];
    
//    Chord *tmpChord = [[Chord alloc] initWithRoot:self.currentChord.root type:self.currentChord.quality];
//    [FretxBLE.sharedInstance sendWithFretCodes:[MusicUtils getBluetoothArrayFromChordWithChordName:tmpChord.name]];
}

- (void)addChordRootsPicker{
    
    if (self.rootsPickerView) {
        [self.rootsPickerView removeFromSuperview];
    }
    
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"ItemsCollectionView"
                                                      owner:self
                                                    options:nil];
    
    self.rootsPickerView = [nibViews firstObject];
    CGRect bounds = self.rootsContainerView.bounds;
    [self.rootsPickerView setFrame:bounds];
    [self.rootsContainerView addSubview:self.rootsPickerView];
    
    [self.rootsPickerView setupWithContent:self.chordRoots delegate:self];
    
    [self.view layoutIfNeeded];
}

- (void)addChordTypesPicker{
    
    if (self.typePickerView) {
        [self.typePickerView removeFromSuperview];
    }
    
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"ItemsCollectionView"
                                                      owner:self
                                                    options:nil];
    
    self.typePickerView = [nibViews firstObject];
    CGRect bounds = self.typesContainerView.bounds;
    [self.typePickerView setFrame:bounds];
    [self.typesContainerView addSubview:self.typePickerView];
    
    [self.typePickerView setupWithContent:self.chordTypes delegate:self];
    
    [self.view layoutIfNeeded];
}

- (void)addFretBoard{
    
    if (self.guitarNeckView) {
        [self.guitarNeckView removeFromSuperview];
    }
    
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"GuitarNeckView"
                                                      owner:self
                                                    options:nil];
    
    self.guitarNeckView = [nibViews firstObject];
    CGRect bounds = self.fretsContainerView.bounds;
    [self.guitarNeckView setFrame:bounds];
    [self.fretsContainerView addSubview:self.guitarNeckView];
    
    [self.view layoutIfNeeded];
}

#pragma mark - Actions

- (IBAction)onPlayChordButton:(id)sender{

    [self.midiPlayer playArrayOfMIDINotes:self.currentChord.midiNotes];
}

#pragma mark - ItemsCollectionViewDelegate

- (void)itemsCollectionView:(ItemsCollectionView*)collectionView didSelectTitle:(NSString*)title atIndex:(NSUInteger)selectedIndex{
    
    if ([self.rootsPickerView isEqual:collectionView]) {
        self.currentRoot = title;
    } else{
        self.currentType = title;
    }
    
    [self updateChord];
}




@end
