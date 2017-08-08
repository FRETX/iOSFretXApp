//
//  ExerciseTableCell.h
//  FretX
//
//  Created by Developer on 7/11/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChordExercise;

@interface ExerciseTableCell : UITableViewCell

- (void)setupChordExercise:(ChordExercise*)chordExercise;

@end
