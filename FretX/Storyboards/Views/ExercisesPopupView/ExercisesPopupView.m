//
//  ExercisesPopupView.m
//  FretX
//
//  Created by Developer on 7/11/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "ExercisesPopupView.h"

#import "ChordExercise.h"
#import "ChordTableCell.h"

#define ExerciseRowHeight 38.f
#define ExerciseListMinBottomSpace 115.f

typedef enum {
    TableTypeChords = 1,
    TableTypeExercises
}TableType;

@interface ExercisesPopupView () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

//ui
@property (weak) IBOutlet UIView* exercisesContainerView;
@property (weak) IBOutlet UIView* containerView;
@property (weak) IBOutlet UITableView* chordsTableView;
@property (weak) IBOutlet UITableView* exercisesTableView;

@property (weak) IBOutlet UILabel* selectedExerciseLabel;
@property (weak) IBOutlet UIView* savingView;
@property (weak) IBOutlet UITextField* nameTextField;
@property (weak) IBOutlet UILabel* emptyMessageLabel;
@property (weak) IBOutlet UIImageView* arrowImageView;

@property (weak) IBOutlet NSLayoutConstraint* exercisesBottomConstraint;
//data
@property (weak) ChordExercise* selectedChordExercise;
@property (weak) NSArray<ChordExercise*>* chordExercises;

@property (assign) BOOL exercisesListOpened;
//@property (assign) BOOL savingViewOpened;
@end

@implementation ExercisesPopupView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code

    [self hideExercisesTableAnimated:NO];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.exercisesTableView.tableFooterView = [UIView new];
    self.chordsTableView.tableFooterView = [UIView new];
    
    [self addExercisesListShadow];
    [self addSavingViewShadow];
    
    [self layoutIfNeeded];
    [self hideSavingViewAnimated:NO];
    [self hideExercisesTableAnimated:NO];
    [self hideBlankNameMessage];
    
    self.nameTextField.layer.borderWidth = 1;
    self.nameTextField.layer.borderColor = [UIColor blackColor].CGColor;
    
    [self.exercisesTableView registerNib:[UINib nibWithNibName:@"ChordTableCell" bundle:nil] forCellReuseIdentifier:@"ChordTableCell"];
    [self.chordsTableView registerNib:[UINib nibWithNibName:@"ChordTableCell" bundle:nil] forCellReuseIdentifier:@"ChordTableCell"];
}

#pragma mark - Public

- (void)setupChordExercises:(NSArray<ChordExercise*>*)chordExercises{
    
    self.chordExercises = chordExercises;
    if (chordExercises.count > 0)
        [self setupSelectedExercise:chordExercises[0]];
    else
        [self setupSelectedExercise:nil];
    
}

//- (void)removeSelected

#pragma mark - Submethods

- (void)setupSelectedExercise:(ChordExercise*)chordExercise{
    
    if (chordExercise) {
        self.selectedChordExercise = chordExercise;
        self.selectedExerciseLabel.text = self.selectedChordExercise.exerciseName;
        
        if ([self.delegate respondsToSelector:@selector(exercisesPopupView:didSelectExercise:)]) {
            [self.delegate exercisesPopupView:self didSelectExercise:chordExercise];
        }
    } else{
        self.selectedChordExercise = nil;
        self.selectedExerciseLabel.text = @"";
    }

    [self.chordsTableView reloadData];
    [self.exercisesTableView reloadData];
    
    //update execrises table if opened already
    if (self.exercisesListOpened) {
        [self showExercisesTableAnimated:YES];
    }
}

- (void)deleteChord:(SongPunch*)song{

    [self.selectedChordExercise removeChord:song];
    [self reloadChords];
}

- (void)reloadChords{
    [self.chordsTableView reloadData];
}

- (void)reloadExercises{
    [self.exercisesTableView reloadData];
}

- (void)showExercisesTableAnimated:(BOOL)animated{
    
    self.arrowImageView.image = [UIImage imageNamed:@"UpArrowIcon"];
    
    self.exercisesBottomConstraint.constant = [self bottomForExercisesTable];
    
    self.exercisesContainerView.hidden = NO;
    
    float duration = animated ? 0.2f : 0;
    [UIView animateWithDuration:duration animations:^{
        
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        self.exercisesListOpened = YES;
    }];
}

- (void)hideExercisesTableAnimated:(BOOL)animated{
    
    self.arrowImageView.image = [UIImage imageNamed:@"DownArrowIcon"];

    self.exercisesBottomConstraint.constant = self.containerView.frame.size.height - self.exercisesContainerView.frame.origin.y;
    
    float duration = animated ? 0.2f : 0;
    [UIView animateWithDuration:duration animations:^{
        
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        self.exercisesListOpened = NO;
        self.exercisesContainerView.hidden = YES;
    }];
}

- (void)showSavingViewAnimated:(BOOL)animated{
    
    self.savingView.hidden = NO;
    float duration = animated ? 0.2f : 0;
    [UIView animateWithDuration:duration animations:^{
        
        self.savingView.alpha = 1.f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideSavingViewAnimated:(BOOL)animated{
    
    float duration = animated ? 0.2f : 0;
    [UIView animateWithDuration:duration animations:^{
        
        self.savingView.alpha = 0.f;
    } completion:^(BOOL finished) {
        
        self.savingView.hidden = YES;
    }];
    [self endEditing:YES];
}

- (void)showBlankNameMessage{
    
    self.emptyMessageLabel.hidden = NO;
}

- (void)hideBlankNameMessage{
    
    self.emptyMessageLabel.hidden = YES;
}

- (void)addExercisesListShadow{
    
    self.exercisesContainerView.layer.cornerRadius = 3;
    self.exercisesContainerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.exercisesContainerView.layer.shadowOffset = CGSizeMake(0.5, 4.0); //Here your control your spread
    self.exercisesContainerView.layer.shadowOpacity = 0.5;
    self.exercisesContainerView.layer.shadowRadius = 5.0;
    self.exercisesContainerView.clipsToBounds = NO;
    self.exercisesContainerView.layer.masksToBounds = NO;
}

- (void)addSavingViewShadow{
    
    self.savingView.layer.cornerRadius = 3;
    self.savingView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.savingView.layer.shadowOffset = CGSizeMake(0.5, 4.0); //Here your control your spread
    self.savingView.layer.shadowOpacity = 0.5;
    self.savingView.layer.shadowRadius = 5.0;
}

#pragma mark -

- (float)bottomForExercisesTable{
    
    float bottomSpace;
    
    if (self.chordExercises.count <= 0) {
        bottomSpace = self.containerView.frame.size.height - self.exercisesContainerView.frame.origin.y;
        return bottomSpace;
    }
    
    float height = ExerciseRowHeight * self.chordExercises.count;
    
    bottomSpace = self.containerView.frame.size.height - (height + self.exercisesContainerView.frame.origin.y);
    if (bottomSpace  < ExerciseListMinBottomSpace) {
        bottomSpace = self.containerView.frame.size.height - self.exercisesContainerView.frame.origin.y - ExerciseListMinBottomSpace;
    }
    
    return bottomSpace;
}

#pragma mark - Actions

- (IBAction)onAddExerciseButton:(UIButton*)sender{
    
    if ([self.delegate respondsToSelector:@selector(didTapAddExercise)]) {
        [self.delegate didTapAddExercise];
    }
    [self endEditing:YES];
}

- (IBAction)onDeleteExerciseButton:(UIButton*)sender{
    
    if (self.selectedChordExercise) {
        if ([self.delegate respondsToSelector:@selector(exercisesPopupView:willRemoveExercise:)]) {
            [self.delegate exercisesPopupView:self willRemoveExercise:self.selectedChordExercise];
        }
        //self.selectedChordExercise = nil;
    }
    
    [self endEditing:YES];
}

- (IBAction)onSaveButton:(UIButton*)sender{
    
    if (self.selectedChordExercise) {
        
        if ([self.delegate respondsToSelector:@selector(exercisesPopupView:didSelectForSaveExercise:)])
            [self.delegate exercisesPopupView:self didSelectForSaveExercise:self.selectedChordExercise];
    }
    [self endEditing:YES];
}

- (IBAction)onSaveWithNameButton:(UIButton*)sender{
    
    if (self.nameTextField.text.length > 0) {
        if (self.selectedChordExercise) {
            self.selectedChordExercise.exerciseName = self.nameTextField.text;
            if ([self.delegate respondsToSelector:@selector(exercisesPopupView:didSelectForSaveExercise:)])
                [self.delegate exercisesPopupView:self didSelectForSaveExercise:self.selectedChordExercise];
        }
        [self endEditing:YES];
        [self hideSavingViewAnimated:YES];
    } else{
        [self showBlankNameMessage];
    }
}

- (IBAction)onSaveAsButton:(UIButton*)sender{
    
    if (self.savingView.hidden) {
        [self showSavingViewAnimated:YES];
    } else{
        [self hideSavingViewAnimated:YES];
    }
    [self endEditing:YES];
}

- (IBAction)onOpenListButton:(UIButton*)sender{
    
    if (self.exercisesListOpened) {
        [self hideExercisesTableAnimated:YES];
    } else{
        [self showExercisesTableAnimated:YES];
    }
    [self endEditing:YES];
}

- (IBAction)onTapGesture:(id)sender{
    
    if ([self.delegate respondsToSelector:@selector(didTapToClose)]) {
        [self.delegate didTapToClose];
    }
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ((TableType)tableView.tag == TableTypeChords) {
        return self.selectedChordExercise.chords.count;
    } else{
        return self.chordExercises.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* cellID = @"ChordTableCell";
    ChordTableCell* cell = (ChordTableCell*)[tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    if ((TableType)tableView.tag == TableTypeChords) {
        SongPunch* songChordPunch = self.selectedChordExercise.chords[indexPath.row];
        [cell setupSongPunch:songChordPunch];
        __weak typeof(self) weakSelf = self;
        cell.didTapDeleteChord = ^(SongPunch* chord){
            [weakSelf deleteChord:chord];
        };
    } else{
        ChordExercise* chordExe = self.chordExercises[indexPath.row];
        [cell seExerciseName:chordExe.exerciseName];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ((TableType)tableView.tag == TableTypeExercises) {
        ChordExercise* chordExe = self.chordExercises[indexPath.row];
        [self setupSelectedExercise:chordExe];
        [self hideExercisesTableAnimated:YES];
    }
    [self endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString* currentString = [textField.text stringByAppendingString:string];
    if (currentString.length > 0) {
        [self hideBlankNameMessage];
        
    }
    return YES;
}

@end
