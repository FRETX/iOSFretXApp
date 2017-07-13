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

#import <FretXAudioProcessing/FretXAudioProcessing-Swift.h>
#import <FretXBLE/FretXBLE-Swift.h>

@interface ChordExercisesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak) IBOutlet UITableView* tableView;

//data
@property (nonatomic,strong) NSArray<ChordExercise*>* exercises;
@property (assign) NSUInteger selectedChordExerciseIndex;
@end

@implementation ChordExercisesViewController

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
    
    if ([segue.identifier isEqualToString:kPickedExerciseSegue]) {
        ChordExercise* exercise = self.exercises[self.selectedChordExerciseIndex];
        
        ChordExerciseViewController* exerciseViewController = (ChordExerciseViewController*)segue.destinationViewController;
        [exerciseViewController setupChordExercise:exercise];
    }
}

- (void)layout{
    
    self.exercises = [[ContentManager defaultManager] defaultChordsExercises];
    [self.tableView reloadData];
}

#pragma mark - UITableView


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.exercises.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* cellID = @"ExerciseTableCell";
    ChordExercise* exercise = self.exercises[indexPath.row];
    ExerciseTableCell* cell = (ExerciseTableCell*)[tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    [cell setupChordExercise:exercise];
    return cell;
}

//kPickedExerciseSegue

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedChordExerciseIndex = indexPath.row;
    [self performSegueWithIdentifier:kPickedExerciseSegue sender:self];
}

@end
