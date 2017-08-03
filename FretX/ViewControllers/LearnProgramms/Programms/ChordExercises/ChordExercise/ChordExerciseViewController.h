//
//  ChordExerciseViewController.h
//  FretX
//
//  Created by Developer on 7/11/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "BaseViewController.h"

@class ChordExercise;

typedef void (^DidPassedGuidedExerciseBlock) (ChordExercise* chordExercise, float timeInterval);

@interface ChordExerciseViewController : BaseViewController

@property (copy, nonatomic) DidPassedGuidedExerciseBlock didPassedGuidedExerciseBlock;

- (void)setupChordExercise:(ChordExercise*)chordExercise;

@end
