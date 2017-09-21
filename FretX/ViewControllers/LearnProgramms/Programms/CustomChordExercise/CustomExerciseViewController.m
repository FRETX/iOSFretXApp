//
//  CustomExerciseViewController.m
//  FretX
//
//  Created by Developer on 7/12/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "CustomExerciseViewController.h"

#import <FretXAudioProcessing/FretXAudioProcessing-Swift.h>

#import "ChordExerciseViewController.h"
#import "ItemsCollectionView.h"
#import "ContentManager.h"
#import "GuitarNeckView.h"
#import "SongPunch.h"
#import "ExercisesPopupView.h"
#import "ChordExercise.h"
#import "ContentManager.h"

@interface CustomExerciseViewController () <ExercisesPopupViewDelegate, ItemsCollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UIView* fretsContainerView;
@property (nonatomic, weak) GuitarNeckView* guitarNeckView;

@property (nonatomic, weak) IBOutlet UIView* rootsContainerView;
@property (nonatomic, weak) ItemsCollectionView* rootsPickerView;

@property (nonatomic, weak) IBOutlet UIView* typesContainerView;
@property (nonatomic, weak) ItemsCollectionView* typePickerView;

@property (nonatomic, weak) ExercisesPopupView* exercisesPopupView;

@property (nonatomic, weak) IBOutlet UILabel* chordNameLabel;

@property (weak) IBOutlet UIButton* chordListButton;
@property (weak) IBOutlet UIButton* addButton;
@property (weak) IBOutlet UIButton* startButton;
@property (nonatomic, weak) IBOutlet UITapGestureRecognizer* tapRecognizer;
//data
@property (strong) NSArray<SongPunch*>* allChords;
@property (strong) NSArray<NSString*>* chordRoots;
@property (strong) NSArray<NSString*>* chordTypes;

@property (strong) SongPunch* currentChord;
@property (strong) NSString* currentRoot;
@property (strong) NSString* currentType;

@property (strong) NSMutableArray<ChordExercise*>* chordExercises;
@property (strong) ChordExercise* currentExercise;

@end

@implementation CustomExerciseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self reloadExerciseList];
}

- (void)reloadExerciseList{
    if ([[ContentManager defaultManager] customChordsExercises].count > 0 ) {
        self.chordExercises = [[[ContentManager defaultManager] customChordsExercises] mutableCopy];
    } else{
        self.chordExercises = [@[[self newEmptyChordExercise]] mutableCopy];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self layout];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self updateChord];
    [self.exercisesPopupView setupChordExercises:self.chordExercises];
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     
     if ([segue.identifier isEqualToString:kPickedExerciseSegue]) {
         ChordExerciseViewController* chordExerciseViewController = segue.destinationViewController;
         [chordExerciseViewController setupChordExercise:self.currentExercise];
     }
 }

#pragma mark - Layout

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
    
    [self getContent];
    
    [self.view layoutIfNeeded];
    [self addChordRootsPicker];
    [self addChordTypesPicker];
    [self addFretBoard];
    [self addExercisesPopupView];
    
    [self updateButtonsFonts];
}

- (void)updateButtonsFonts{
    
    float kDefaultScreenHeight = 568.f;
    float currentScreenHeight = [UIScreen mainScreen].bounds.size.height;
    float multiplier = currentScreenHeight / kDefaultScreenHeight;
    float fontSize = 18.f * multiplier;
    
    self.chordListButton.titleLabel.font =
    self.addButton.titleLabel.font =
    self.startButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
}

- (void)updateChord{
    
    SongPunch* currentChord = [SongPunch initChordWithRoot:self.currentRoot type:self.currentType];
    [self layoutChord:currentChord];
    
}

- (void)layoutChord:(SongPunch*)chord{
    
    self.currentChord = chord;
    
    self.chordNameLabel.text = chord.chordName;
    BOOL leftHanded = [[NSUserDefaults standardUserDefaults] valueForKey:@"leftHanded"];
    [self.guitarNeckView layoutChord:self.currentChord withPunchAnimation:YES withLeftHanded:(BOOL)leftHanded];
    
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

- (void)addExercisesPopupView{
    
    if (self.exercisesPopupView) {
        [self.exercisesPopupView removeFromSuperview];
    }
    
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"ExercisesPopupView"
                                                      owner:self
                                                    options:nil];
    
    self.exercisesPopupView = [nibViews firstObject];
    CGRect bounds = self.view.bounds;
    [self.exercisesPopupView setFrame:bounds];
    [self.view addSubview:self.exercisesPopupView];
    
    [self.exercisesPopupView setupChordExercises:self.chordExercises];
    self.exercisesPopupView.delegate = self;
    
    [self.view layoutIfNeeded];
    
    [self hideExercisesPopupAnimated:NO];
}

#pragma mark -

- (void)removeExercise:(ChordExercise*)chordExercise{
    
    if ([self.chordExercises containsObject:chordExercise]) {
        [self.chordExercises removeObject:chordExercise];
    }
    [self.exercisesPopupView setupChordExercises:self.chordExercises];
}

- (void)showExercisesPopupAnimated:(BOOL)animated{
    
    self.tapRecognizer.enabled = YES;
    self.exercisesPopupView.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        
        self.exercisesPopupView.alpha = 1.f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideExercisesPopupAnimated:(BOOL)animated{
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.exercisesPopupView.alpha = 0.f;
    } completion:^(BOOL finished) {
        
        self.exercisesPopupView.hidden = YES;
        self.tapRecognizer.enabled = NO;
    }];
}

- (ChordExercise*)newEmptyChordExercise{
    
    ChordExercise* chordsExercise = [ChordExercise new];
    
    NSArray<ChordExercise*>* customExercises = self.chordExercises;
    NSString* newID = customExercises.count > 0 ? [NSString stringWithFormat:@"%ld",customExercises.count+1] : @"1";
    chordsExercise.exerciseID = newID;
    chordsExercise.exerciseName = @"New";
    chordsExercise.repetitionsCount = 2;
    
    return chordsExercise;
}

#pragma mark - Actions

- (IBAction)onChordListButton:(UIButton*)sender{
    
    if (self.exercisesPopupView.hidden) {
        [self showExercisesPopupAnimated:YES];
    } else{
        [self hideExercisesPopupAnimated:YES];
    }

}

- (IBAction)onAddChordButton:(UIButton*)sender{
    
    [self.currentExercise addChord:self.currentChord];
    [self.exercisesPopupView setupChordExercises:self.chordExercises];
}

- (IBAction)onStartButton:(UIButton*)sender{
    
    if (self.currentExercise ) {
        if (self.currentExercise.chords.count > 0)
            [self performSegueWithIdentifier:kPickedExerciseSegue sender:self];
        else{
            NSString* message = @"This exercise is empty. Add some chords to start.";
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:self.currentExercise.exerciseName
                                                                                     message:message
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* agreeAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:agreeAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

//- (IBAction)onTapViewGesture:(UITapGestureRecognizer*)sender{
//    
//    [self hideExercisesPopupAnimated:YES];
//}

#pragma mark - ItemsCollectionViewDelegate

- (void)itemsCollectionView:(ItemsCollectionView*)collectionView didSelectTitle:(NSString*)title atIndex:(NSUInteger)selectedIndex{
    
    if ([self.rootsPickerView isEqual:collectionView]) {
        self.currentRoot = title;
    } else{
        self.currentType = title;
    }
    
    [self updateChord];
}

#pragma mark - ExercisesPopupViewDelegate

- (void)didTapToClose{
    [self hideExercisesPopupAnimated:YES];
    [self.view endEditing:YES];
}

- (void)didTapAddExercise{
    
    ChordExercise* chordExercise = [self newEmptyChordExercise];
    [self.chordExercises addObject:chordExercise];
    
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"exerciseID" ascending:NO];
    [self.chordExercises sortUsingDescriptors:@[sortDescriptor]]; // @[sortDescriptor]
    
    [self.exercisesPopupView setupChordExercises:self.chordExercises];
}

- (void)exercisesPopupView:(ExercisesPopupView*)exercisesPopupView didSelectExercise:(ChordExercise*)chordExercise{
    self.currentExercise = chordExercise;
}

- (void)exercisesPopupView:(ExercisesPopupView*)exercisesPopupView didSelectForSaveExercise:(ChordExercise*)chordExercise{

    [[ContentManager defaultManager] saveCustomChords:self.chordExercises];
    [self reloadExerciseList];
    [self.exercisesPopupView setupChordExercises:self.chordExercises];
    [self.view endEditing:YES];
}

- (void)exercisesPopupView:(ExercisesPopupView*)exercisesPopupView willRemoveExercise:(ChordExercise*)chordExercise{
    
    NSString* message = [NSString stringWithFormat:@"Are you sure you want to delete %@",chordExercise.exerciseName];
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* agreeAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self removeExercise:chordExercise];
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:agreeAction];
    UIAlertAction* declineAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:declineAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
