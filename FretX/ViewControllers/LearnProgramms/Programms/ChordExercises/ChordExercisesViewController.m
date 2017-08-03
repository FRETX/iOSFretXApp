//
//  ChordExercisesViewController.m
//  FretX
//
//  Created by Developer on 7/11/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "ChordExercisesViewController.h"

#import "ChordExerciseViewController.h"
#import "ExerciseTableCell.h"
#import "ContentManager.h"
#import "ChordExercise.h"
#import "RequestManager.h"
#import "UIView+Activity.h"

@interface ChordExercisesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak) IBOutlet UITableView* tableView;

//data
@property (nonatomic,strong) NSArray<ChordExercise*>* exercises;
@property (assign) NSUInteger selectedChordExerciseIndex;
@property (assign) NSUInteger exercisesPassed;
@end

@implementation ChordExercisesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layout];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
    
    if ([segue.identifier isEqualToString:kPickedExerciseSegue]) {
        ChordExercise* exercise = self.exercises[self.selectedChordExerciseIndex];
        
        ChordExerciseViewController* exerciseViewController = (ChordExerciseViewController*)segue.destinationViewController;
        __weak typeof(self) weakSelf = self;
        exerciseViewController.didPassedGuidedExerciseBlock = ^(ChordExercise* chordExercise, float timeInterval){
            
            [weakSelf.view showActivity];
            [[ContentManager defaultManager] saveTime:timeInterval forGuidedExercise:chordExercise block:^(BOOL status) {
                
                [weakSelf updateUserProgress];
            }];
        };
        [exerciseViewController setupChordExercise:exercise];
    }
}

- (void)layout{
    
    [self.view showActivity];
    __weak typeof(self) weakSelf = self;
    [[ContentManager defaultManager] defaultChordsExercisesWithResultBlock:^(BOOL status, NSArray<ChordExercise*>* guidedExercises) {
        
        weakSelf.exercises = guidedExercises;//[[ContentManager defaultManager] defaultChordsExercises];
        [weakSelf updateUserProgress];
    }];
}

- (void)updateUserProgress{
    
    static BOOL isUpdatingNow = NO;
    if (isUpdatingNow) {
        return;
    }
    
    [self.view showActivity];
    __weak typeof(self) weakSelf = self;
    [[ContentManager defaultManager] loadUserProgressWithBlock:^(BOOL status, NSUInteger exercisesPassed) {
        
        [self.view hideActivity];
        isUpdatingNow = NO;
        if (status) {
            weakSelf.exercisesPassed = exercisesPassed;
            [weakSelf.tableView reloadData];
        }
    }];
}

#pragma mark - UITableView


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.exercises.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* cellID = @"ExerciseTableCell";
    ChordExercise* exercise = self.exercises[indexPath.row];
    ExerciseTableCell* cell = (ExerciseTableCell*)[tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    [cell setupChordExercise:exercise locked:(self.exercisesPassed <= indexPath.row)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.exercisesPassed > indexPath.row) {
        self.selectedChordExerciseIndex = indexPath.row;
        [self performSegueWithIdentifier:kPickedExerciseSegue sender:self];
    }

}

@end
