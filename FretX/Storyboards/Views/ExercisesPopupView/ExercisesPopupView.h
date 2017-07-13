//
//  ExercisesPopupView.h
//  FretX
//
//  Created by Developer on 7/11/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ExercisesPopupView, ChordExercise;

@protocol ExercisesPopupViewDelegate <NSObject>

- (void)didTapAddExercise;
- (void)exercisesPopupView:(ExercisesPopupView*)exercisesPopupView willRemoveExercise:(ChordExercise*)chordExercise;

- (void)exercisesPopupView:(ExercisesPopupView*)exercisesPopupView didSelectForSaveExercise:(ChordExercise*)chordExercise;
- (void)exercisesPopupView:(ExercisesPopupView*)exercisesPopupView didSelectExercise:(ChordExercise*)chordExercise;
- (void)didTapToClose;

@end

@interface ExercisesPopupView : UIView

@property (weak) id<ExercisesPopupViewDelegate> delegate;

- (void)setupChordExercises:(NSArray<ChordExercise*>*)chordExercises;

@end
