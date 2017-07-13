//
//  ScaleExercisesViewController.m
//  FretX
//
//  Created by Developer on 7/10/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "ScaleExercisesViewController.h"

#import <FretXAudioProcessing/FretXAudioProcessing-Swift.h>
#import <FretXBLE/FretXBLE-Swift.h>

#import "ItemsCollectionView.h"
#import "ContentManager.h"
#import "GuitarNeckView.h"
#import "SongPunch.h"

@interface ScaleExercisesViewController () <ItemsCollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UIView* fretsContainerView;
@property (nonatomic, weak) GuitarNeckView* guitarNeckView;

@property (nonatomic, weak) IBOutlet UIView* rootsContainerView;
@property (nonatomic, weak) ItemsCollectionView* rootsPickerView;

@property (nonatomic, weak) IBOutlet UIView* typesContainerView;
@property (nonatomic, weak) ItemsCollectionView* typePickerView;

@property (nonatomic, weak) IBOutlet UILabel* chordNameLabel;

//data
@property (strong) NSArray<SongPunch*>* allChords;
@property (strong) NSArray<NSString*>* scaleRoots;
@property (strong) NSArray<NSString*>* scaleTypes;

@property (strong) SongPunch* currentChord;
@property (strong) NSString* currentRoot;
@property (strong) NSString* currentType;

@end

@implementation ScaleExercisesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layout];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self updateChord];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setInitialValues{
    
    self.currentRoot = self.scaleRoots[0];
    self.currentType = self.scaleTypes[0];
    
    [self updateChord];
}

- (void)getContent{
    
    self.scaleRoots = [[ContentManager defaultManager] allScaleRoots];
    self.scaleTypes = [[ContentManager defaultManager] allScaleTypes];
    
    if (self.scaleRoots.count > 0 && self.scaleTypes.count > 0) {
        [self setInitialValues];
    }
}

- (void)layout{
    
    [self getContent];
    
    [self.view layoutIfNeeded];
    [self addChordRootsPicker];
    [self addChordTypesPicker];
    [self addFretBoard];
    
}

- (void)updateChord{

    SongPunch *newChord = [SongPunch initScaleWithRoot:self.currentRoot type:self.currentType];
    [self layoutChord:newChord];
    Scale *tmpScale = [[Scale alloc] initWithRoot:self.currentRoot type:self.currentType];
    [FretxBLE.sharedInstance sendWithFretCodes:[MusicUtils getBluetoothArrayFromScaleWithScale:tmpScale]];
}

- (void)layoutChord:(SongPunch*)chord{
    
    self.currentChord = chord;
    
    self.chordNameLabel.text = chord.chordName;
    
    [self.guitarNeckView layoutChord:self.currentChord withPunchAnimation:NO];
    
    
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
    
    [self.rootsPickerView setupWithContent:self.scaleRoots delegate:self];
    
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
    
    [self.typePickerView setupWithContent:self.scaleTypes delegate:self];
    
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
